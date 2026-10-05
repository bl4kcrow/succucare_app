import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:succucare_app/core/errors/errors.dart';
import 'package:succucare_app/features/garden/models/models.dart';
import 'package:succucare_app/features/garden/services/firebase_ai_plant_identification_service.dart';

/// A canned model handle, so the real service's request building, response
/// reading and mapping are exercised without a network.
class FakeModelHandle implements PlantIdentificationModel {
  FakeModelHandle({this.responseText, this.error});

  final String? responseText;
  final Object? error;

  int calls = 0;
  List<Content> lastParts = const [];

  @override
  Future<String?> generateText(List<Content> parts) async {
    calls++;
    lastParts = parts;

    final failure = error;
    if (failure != null) throw failure;

    return responseText;
  }
}

FirebaseAiPlantIdentificationService serviceReturning(
  FakeModelHandle model,
) =>
    FirebaseAiPlantIdentificationService(model: model);

final PlantPhotoInput photo = PlantPhotoInput(
  bytes: Uint8List.fromList(<int>[1, 2, 3, 4]),
  mimeType: 'image/jpeg',
);

/// Runs [run] and returns whatever it threw, so the mapping and the retained
/// cause can both be asserted on the same failure.
Future<Object> failureFrom(Future<void> Function() run) async {
  try {
    await run();
  } catch (error) {
    return error;
  }
  fail('expected identify() to fail');
}

/// Runs [run] once, returning both what it threw and everything the backend
/// printed to developer output on the way.
Future<({Object failure, List<String> lines})> capturedFailure(
  Future<void> Function() run,
) async {
  final buffer = StringBuffer();
  final previous = debugPrint;
  debugPrint = (String? message, {int? wrapWidth}) {
    buffer.writeln(message ?? '');
  };
  addTearDown(() => debugPrint = previous);

  Object? thrown;
  try {
    await run();
  } catch (error) {
    thrown = error;
  }

  return (
    failure: thrown ?? (fail('expected identify() to fail')),
    lines: buffer.toString().split('\n').where((l) => l.isNotEmpty).toList(),
  );
}

void main() {
  group('a well-formed response', () {
    test('yields all five values', () async {
      final model = FakeModelHandle(
        responseText: jsonEncode({
          'commonName': 'Jade Plant',
          'scientificName': 'Crassula ovata',
          'category': 'succulents',
          'wateringIntervalDays': 14,
          'lightLevel': 'brightIndirect',
        }),
      );

      final result = await serviceReturning(model).identify(photo);

      expect(result.commonName, 'Jade Plant');
      expect(result.scientificName, 'Crassula ovata');
      expect(result.category, 'succulents');
      expect(result.wateringIntervalDays, 14);
      expect(result.lightLevel, 'brightIndirect');
    });

    test('sends the prompt and the photo as inline data', () async {
      final model = FakeModelHandle(responseText: '{}');

      await serviceReturning(model).identify(photo);

      expect(model.calls, 1);
      expect(model.lastParts, hasLength(2));
      expect(model.lastParts.first.role, 'user');
      expect(
        model.lastParts.first.parts.whereType<TextPart>().single.text,
        contains('commonName'),
      );

      final inline = model.lastParts.last.parts.whereType<InlineDataPart>();
      expect(inline, hasLength(1));
      expect(inline.single.mimeType, 'image/jpeg');
      expect(inline.single.bytes, photo.bytes);
    });
  });

  group('a response that omits fields', () {
    test('yields nulls for the omitted values and keeps the others', () async {
      final model = FakeModelHandle(
        responseText: jsonEncode({'commonName': 'Christmas Cactus'}),
      );

      final result = await serviceReturning(model).identify(photo);

      expect(result.commonName, 'Christmas Cactus');
      expect(result.scientificName, isNull);
      expect(result.category, isNull);
      expect(result.wateringIntervalDays, isNull);
      expect(result.lightLevel, isNull);
    });

    test('an empty response body yields an empty identification', () async {
      final result = await serviceReturning(
        FakeModelHandle(responseText: null),
      ).identify(photo);

      expect(result.commonName, isNull);
      expect(result.scientificName, isNull);
      expect(result.category, isNull);
      expect(result.wateringIntervalDays, isNull);
      expect(result.lightLevel, isNull);
    });

    test('a non-JSON response yields an empty identification rather than an error', () async {
      final result = await serviceReturning(
        FakeModelHandle(responseText: 'I could not identify that plant.'),
      ).identify(photo);

      expect(result.commonName, isNull);
      expect(result.category, isNull);
    });
  });

  group('a response whose values are all out of vocabulary', () {
    test('yields an empty identification rather than an error', () async {
      final model = FakeModelHandle(
        responseText: jsonEncode({
          'commonName': '',
          'scientificName': '   ',
          'category': 'aloe',
          'wateringIntervalDays': 0,
          'lightLevel': 'direct',
        }),
      );

      final result = await serviceReturning(model).identify(photo);

      expect(result.commonName, isNull);
      expect(result.scientificName, isNull);
      expect(result.category, isNull);
      expect(result.wateringIntervalDays, isNull);
      expect(result.lightLevel, isNull);
    });

    test('one unusable value does not suppress the usable ones', () async {
      final model = FakeModelHandle(
        responseText: jsonEncode({
          'commonName': 'Aloe Vera',
          'category': 'aloe',
          'wateringIntervalDays': 999,
          'lightLevel': 'fullSun',
        }),
      );

      final result = await serviceReturning(model).identify(photo);

      expect(result.commonName, 'Aloe Vera');
      expect(result.category, isNull);
      expect(result.wateringIntervalDays, isNull);
      expect(result.lightLevel, 'fullSun');
    });
  });

  group('AI SDK failures', () {
    test('a quota failure reports the identification rate limit wording', () async {
      final model = FakeModelHandle(
        error: QuotaExceeded('Quota exceeded for gemini-3.7-flash'),
      );

      final failure = await failureFrom(
        () => serviceReturning(model).identify(photo),
      );

      expect(
        failure,
        isA<AppFailure>().having(
          (f) => f.code,
          'code',
          AppFailureCode.plantIdentificationRateLimited,
        ),
      );
    });

    test('an API-not-enabled failure reports the generic busy wording', () async {
      final model = FakeModelHandle(
        error: ServiceApiNotEnabled('projects/succucare-db-dev'),
      );

      final failure = await failureFrom(
        () => serviceReturning(model).identify(photo),
      );

      expect(
        failure,
        isA<AppFailure>().having(
          (f) => f.code,
          'code',
          AppFailureCode.unavailable,
        ),
      );
      expect((failure as AppFailure).userMessage, 'Service is busy. Try again.');
    });

    test('an unmapped throw becomes a generic failure', () async {
      final model = FakeModelHandle(error: Exception('socket closed'));

      final failure = await failureFrom(
        () => serviceReturning(model).identify(photo),
      );

      expect(
        failure,
        isA<AppFailure>().having(
          (f) => f.code,
          'code',
          AppFailureCode.unknown,
        ),
      );
    });

    test('the retained cause reaches developer output but not the user message', () async {
      final cause = QuotaExceeded('Quota exceeded for project succucare-db-dev');
      final service = serviceReturning(FakeModelHandle(error: cause));

      final result = await capturedFailure(() => service.identify(photo));
      final failure = result.failure;

      expect(failure, isA<AppFailure>());
      expect((failure as AppFailure).cause, same(cause));
      expect(result.lines.join('\n'), contains('Quota exceeded'));

      final userMessage = failure.userMessage;
      expect(userMessage, 'Identification is busy right now. Try again later.');
      expect(userMessage, isNot(contains('Quota exceeded')));
      expect(userMessage, isNot(contains('succucare-db-dev')));
      expect(userMessage, isNot(contains('QuotaExceeded')));
      expect(userMessage, isNot(contains('AppFailure')));
    });

    test('an unmapped throw has its cause debug-printed before it is thrown', () async {
      final service = serviceReturning(
        FakeModelHandle(error: StateError('no response body')),
      );

      final result = await capturedFailure(() => service.identify(photo));

      expect((result.failure as AppFailure).cause, isA<StateError>());
      expect(result.lines.join('\n'), contains('no response body'));
    });
  });
}