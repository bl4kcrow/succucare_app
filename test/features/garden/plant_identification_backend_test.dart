import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:succucare_app/features/garden/models/models.dart';

import 'package:succucare_app/features/garden/providers/plant_identification_service_provider.dart';
import 'package:succucare_app/features/garden/services/plant_identification_service.dart';
import 'package:succucare_app/features/garden/services/unavailable_plant_identification_service.dart';

const String _firebaseBackendFile =
    'lib/features/garden/services/firebase_ai_plant_identification_service.dart';

class _StubPlantIdentificationService implements PlantIdentificationService {
  const _StubPlantIdentificationService();

  @override
  Future<PlantIdentification> identify(PlantPhotoInput photo) async =>
      const PlantIdentification();
}

ProviderContainer containerFor(String env) {
  dotenv.loadFromString(envString: env);

  final container = ProviderContainer();
  addTearDown(container.dispose);
  return container;
}

void main() {
  setUp(dotenv.clean);

  group('backend selection', () {
    test('an absent AI_PROVIDER selects the unavailable backend', () {
      final container = containerFor('UNRELATED_KEY=present');

      expect(
        container.read(plantIdentificationServiceProvider),
        isA<UnavailablePlantIdentificationService>(),
      );
    });

    test('an unrecognised AI_PROVIDER selects the unavailable backend', () {
      final container = containerFor('AI_PROVIDER=some_other_backend');

      expect(
        container.read(plantIdentificationServiceProvider),
        isA<UnavailablePlantIdentificationService>(),
      );
    });

    test('a near-miss AI_PROVIDER value selects the unavailable backend', () {
      final container = containerFor('AI_PROVIDER=firebase_ai_v2');

      expect(
        container.read(plantIdentificationServiceProvider),
        isA<UnavailablePlantIdentificationService>(),
      );
    });

    test('overriding the provider in a ProviderContainer replaces the backend', () {
      final container = containerFor('AI_PROVIDER=some_other_backend');

      final overridden = ProviderContainer(
        overrides: [
          plantIdentificationServiceProvider.overrideWithValue(
            const _StubPlantIdentificationService(),
          ),
        ],
      );
      addTearDown(overridden.dispose);

      expect(
        overridden.read(plantIdentificationServiceProvider),
        isA<_StubPlantIdentificationService>(),
      );
      expect(
        container.read(plantIdentificationServiceProvider),
        isA<UnavailablePlantIdentificationService>(),
      );
    });

    test('the generated provider file is present beside its source', () {
      expect(
        File(
          'lib/features/garden/providers/'
          'plant_identification_service_provider.g.dart',
        ).existsSync(),
        isTrue,
      );
    });
  });

  group('backend boundary', () {
    late List<File> dartSources;

    setUp(() {
      dartSources = Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .where((file) => !file.path.contains(RegExp(r'[\\/]\.dart_tool[\\/]')))
          .toList();
    });

    test('there is at least one lib source to scan', () {
      expect(dartSources, isNotEmpty);
    });

    test('only the Firebase backend imports package:firebase_ai', () {
      final importers = dartSources
          .where(
            (file) => file.readAsStringSync().contains('package:firebase_ai/'),
          )
          .map((file) => file.path.replaceAll('\\', '/'))
          .toList();

      expect(importers, [_firebaseBackendFile]);
    });

    test('the add-plant flow reaches identification only through the port', () {
      final flowFiles = dartSources
          .map((file) => file.path.replaceAll('\\', '/'))
          .where(
            (path) =>
                path.contains('/features/garden/screens/') ||
                path.contains('/features/garden/widgets/') ||
                path.contains('/features/garden/views/'),
          )
          .toList();

      expect(flowFiles, isNotEmpty);

      for (final path in flowFiles) {
        expect(
          File(path).readAsStringSync(),
          isNot(contains('firebase_ai')),
          reason: '$path must not name an identification backend',
        );
      }
    });

    test('the add-plant notifier reaches identification through the provider', () {
      final notifier = File(
        'lib/features/garden/providers/add_plant_provider.dart',
      ).readAsStringSync();

      expect(notifier, contains('plantIdentificationServiceProvider'));
      expect(notifier, isNot(contains('package:firebase_ai')));
    });
  });
}