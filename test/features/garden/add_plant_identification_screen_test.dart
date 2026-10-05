import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:succucare_app/core/errors/errors.dart';
import 'package:succucare_app/features/garden/models/models.dart';
import 'package:succucare_app/features/garden/providers/providers.dart';
import 'package:succucare_app/features/garden/repositories/repositories.dart';
import 'package:succucare_app/features/garden/screens/screens.dart';
import 'package:succucare_app/features/garden/services/services.dart';

const String transparentPng =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';

const String identifyAction = 'Identificar planta';
const String identifyingLabel = 'Identificando…';

class FakePlantIdentificationService implements PlantIdentificationService {
  FakePlantIdentificationService({this.result, this.error});

  PlantIdentification? result;
  Object? error;
  final List<PlantPhotoInput> requests = [];

  @override
  Future<PlantIdentification> identify(PlantPhotoInput photo) async {
    requests.add(photo);

    final failure = error;
    if (failure != null) throw failure;

    return result ?? const PlantIdentification();
  }
}

class SlowPlantIdentificationService implements PlantIdentificationService {
  final PlantIdentification result;
  final Completer<PlantIdentification> gate = Completer<PlantIdentification>();
  final List<PlantPhotoInput> requests = [];

  SlowPlantIdentificationService({required this.result});

  @override
  Future<PlantIdentification> identify(PlantPhotoInput photo) {
    requests.add(photo);
    return gate.future;
  }
}

class RecordingGardenRepository implements GardenRepository {
  RecordingGardenRepository({this.createPlantId = 'new-plant-id'});

  final String createPlantId;
  final List<Plant> created = [];

  @override
  Future<Plant> loadPlantById(String plantId) async =>
      throw AppFailure(AppFailureCode.notFound);

  @override
  Future<PlantPage> loadInitialPlants() async =>
      const PlantPage(plants: []);

  @override
  Future<PlantPage> loadNextPlants(dynamic cursor) async =>
      const PlantPage(plants: []);

  @override
  Future<String> createPlant(Plant plant) async {
    created.add(plant);
    return createPlantId;
  }

  @override
  Future<void> updatePlant(Plant plant) async {}

  @override
  Future<void> updatePlantPhotoUrl(String url, String plantId) async {}
}

class RecordingPhotosRepository implements PhotosRepository {
  @override
  Future<String> uploadPlantPhoto(String plantId, File imageFile) async =>
      'https://example.com/$plantId.jpg';

  @override
  Future<void> deletePlantPhoto(String photoUrl) async {}
}

void main() {
  late Directory tempDirectory;

  setUp(() {
    tempDirectory = Directory.systemTemp.createTempSync(
      'add_plant_identify_screen',
    );
  });

tearDown(() {
    try {
      tempDirectory.deleteSync(recursive: true);
    } on FileSystemException {
      // A pending image read can still hold a handle; harmless in a temp dir.
    }
  });

/// Pads a valid PNG past [bytes] so the size guard is what trips, not the
  /// image codec: decoders ignore anything trailing the PNG's IEND chunk.
  File photoFile({String name = 'luna.png', int? bytes}) {
    final data = <int>[
      ...base64Decode(transparentPng),
      ...List<int>.filled(
        (bytes ?? 0) > 0 ? bytes! - base64Decode(transparentPng).length : 0,
        0,
      ),
    ];

    return File('${tempDirectory.path}${Platform.pathSeparator}$name')
      ..writeAsBytesSync(data);
  }

  ({ProviderContainer container, RecordingGardenRepository garden})
  pumpSubject(
    WidgetTester tester,
    PlantIdentificationService service,
  ) {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final garden = RecordingGardenRepository();
    final container = ProviderContainer(
      overrides: [
        plantIdentificationServiceProvider.overrideWithValue(service),
        gardenRepositoryImplProvider.overrideWithValue(garden),
        photosRepositoryImplProvider.overrideWithValue(
          RecordingPhotosRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(container.listen(addPlantProvider, (_, _) {}).close);

    return (container: container, garden: garden);
  }

  Future<({ProviderContainer container, RecordingGardenRepository garden})>
  pumpScreen(WidgetTester tester, PlantIdentificationService service) async {
    final subject = pumpSubject(tester, service);

final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Mi Jardin'))),
        ),
        GoRoute(
          path: '/add-plant',
          builder: (context, state) => const AddPlantScreen(),
        ),
      ],
    );
addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: subject.container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    // Pushed only once the router is mounted, so the screen really does sit on
    // top of a route that `context.pop()` can return to after a save.
    unawaited(router.push('/add-plant'));
    await tester.pumpAndSettle();

    return subject;
  }

/// `identify()` reads the photo off disk. Those I/O futures only make
  /// progress while the real event loop runs, and each `await` then resumes on
  /// the test's fake-async microtask queue, so every hop needs its own turn of
  /// the real loop followed by a pump.
  Future<void> pumpIoSteps(WidgetTester tester, {int steps = 8}) async {
    for (var i = 0; i < steps; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 5)),
      );
      await tester.pump();
    }
  }

  /// [pumpIoSteps] followed by a settle, for requests that finish on their own.
  /// Never use this while a progress indicator is on screen: it never stops
  /// animating, so `pumpAndSettle` would time out.
  Future<void> pumpAfterIo(WidgetTester tester) async {
    await pumpIoSteps(tester);
    await tester.pumpAndSettle();
  }

  List<String> textFieldValues(WidgetTester tester) => tester
      .widgetList<TextField>(find.byType(TextField))
      .map((field) => field.controller?.text ?? '')
      .toList();

  group('the identification action', () {
    testWidgets('is absent when no photo is attached', (tester) async {
      final service = FakePlantIdentificationService(
        result: const PlantIdentification(commonName: 'Jade Plant'),
      );
      await pumpScreen(tester, service);

      expect(find.text(identifyAction), findsNothing);
      expect(find.text(identifyingLabel), findsNothing);
      expect(find.text('Añadir foto'), findsOneWidget);
    });

    testWidgets('appears once a photo is attached', (tester) async {
      final service = FakePlantIdentificationService(
        result: const PlantIdentification(commonName: 'Jade Plant'),
      );
      final subject = await pumpScreen(tester, service);

      await tester.pumpAndSettle();
      expect(find.text(identifyAction), findsNothing);

      subject.container.read(addPlantProvider.notifier).addImage(photoFile());
      await tester.pumpAndSettle();

      expect(find.text(identifyAction), findsOneWidget);
      expect(find.text('Añadir foto'), findsNothing);
    });

    testWidgets('shows progress and stops responding while a request is in flight', (
      tester,
    ) async {
      final service = SlowPlantIdentificationService(
        result: const PlantIdentification(commonName: 'Jade Plant'),
      );
      final subject = await pumpScreen(tester, service);

      subject.container.read(addPlantProvider.notifier).addImage(photoFile());
      await tester.pumpAndSettle();

await tester.tap(find.text(identifyAction));
      await pumpIoSteps(tester);

      expect(find.text(identifyingLabel), findsOneWidget);
      expect(find.text(identifyAction), findsNothing);
      expect(
        subject.container.read(addPlantProvider).identificationStatus,
        IdentificationStatus.inProgress,
      );

      await tester.tap(find.text(identifyingLabel), warnIfMissed: false);
      await tester.pump();

      expect(service.requests, hasLength(1));

      service.gate.complete(service.result);
      await pumpIoSteps(tester);

      expect(find.text(identifyAction), findsOneWidget);
    });
  });

  group('failure reporting', () {
    Future<void> expectFailureWording(
      WidgetTester tester,
      PlantIdentificationService service,
      String wording,
    ) async {
      final subject = await pumpScreen(tester, service);

      subject.container.read(addPlantProvider.notifier).addImage(photoFile());
      await tester.pumpAndSettle();

      await tester.tap(find.text(identifyAction));
      await pumpAfterIo(tester);

      expect(find.text(wording), findsOneWidget);
    }

    testWidgets('an absent source reports that identification is unavailable', (
      tester,
    ) async {
      await expectFailureWording(
        tester,
        FakePlantIdentificationService(
          error: AppFailure(AppFailureCode.plantIdentificationUnavailable),
        ),
        "Plant identification isn't available right now.",
      );
    });

    testWidgets('an oversized photo reports that it is too large', (
      tester,
    ) async {
      final service = FakePlantIdentificationService(
        result: const PlantIdentification(commonName: 'Jade Plant'),
      );
      final subject = await pumpScreen(tester, service);

      subject.container
          .read(addPlantProvider.notifier)
          .addImage(photoFile(bytes: maxIdentificationPhotoBytes + 1));
      await tester.pumpAndSettle();

      await tester.tap(find.text(identifyAction));
      await pumpAfterIo(tester);

      expect(
        find.text('That photo is too large to identify. Choose another.'),
        findsOneWidget,
      );
      expect(service.requests, isEmpty);
    });

    testWidgets('an exhausted rate limit reports its own wording', (tester) async {
      await expectFailureWording(
        tester,
        FakePlantIdentificationService(
          error: AppFailure(AppFailureCode.plantIdentificationRateLimited),
        ),
        'Identification is busy right now. Try again later.',
      );
    });

    testWidgets('no usable result reports that the plant could not be identified', (
      tester,
    ) async {
      await expectFailureWording(
        tester,
        FakePlantIdentificationService(),
        "Couldn't identify that plant. Fill in the details yourself.",
      );
    });

    testWidgets('a failure leaves the form editable and the values unchanged', (
      tester,
    ) async {
      final subject = await pumpScreen(tester, FakePlantIdentificationService(
          error: AppFailure(AppFailureCode.plantIdentificationUnavailable),
        ),
      );

      subject.container.read(addPlantProvider.notifier)
        ..setCommonName('My own name')
        ..addImage(photoFile());
      await tester.pumpAndSettle();

      await tester.tap(find.text(identifyAction));
      await pumpAfterIo(tester);

      expect(textFieldValues(tester), contains('My own name'));
      expect(find.text('Guardar Planta'), findsOneWidget);
    });
  });

  group('a proposal in the form', () {
    testWidgets('lands in the ordinary editable fields and not a saved plant', (
      tester,
    ) async {
      final subject = await pumpScreen(tester, FakePlantIdentificationService(
          result: const PlantIdentification(
            commonName: 'Jade Plant',
            scientificName: 'Crassula ovata',
            category: 'succulents',
            wateringIntervalDays: 21,
            lightLevel: 'brightIndirect',
          ),
        ),
      );

      subject.container.read(addPlantProvider.notifier).addImage(photoFile());
      await tester.pumpAndSettle();

      await tester.tap(find.text(identifyAction));
      await pumpAfterIo(tester);

      final values = textFieldValues(tester);
      expect(values, contains('Jade Plant'));
      expect(values, contains('Crassula ovata'));

      // The proposed category is the one the form already offers, selected.
      final category = subject.container.read(addPlantProvider).plant.category;
      expect(category, Category.succulents);

      // Nothing was saved.
      expect(subject.garden.created, isEmpty);
      expect(
        subject.container.read(addPlantProvider).plant.wateringIntervalDays,
        21,
      );
      expect(
        subject.container.read(addPlantProvider).plant.illumination.current,
        LightLevel.brightIndirect,
      );
      expect(find.text('Guardar Planta'), findsOneWidget);
    });

    testWidgets('a value the user edits after a proposal is the value shown', (
      tester,
    ) async {
      final subject = await pumpScreen(tester, FakePlantIdentificationService(
          result: const PlantIdentification(commonName: 'Jade Plant'),
        ),
      );

      subject.container.read(addPlantProvider.notifier).addImage(photoFile());
      await tester.pumpAndSettle();

      await tester.tap(find.text(identifyAction));
      await pumpAfterIo(tester);

      await tester.enterText(
        find.widgetWithText(TextField, 'Jade Plant'),
        'My own name',
      );
      await tester.pumpAndSettle();

      expect(textFieldValues(tester), contains('My own name'));
      expect(
        subject.container.read(addPlantProvider).plant.commonName,
        'My own name',
      );
    });

    testWidgets('holds only what the user entered for the un-proposed values', (
      tester,
    ) async {
      final subject = await pumpScreen(tester, FakePlantIdentificationService(
          result: const PlantIdentification(commonName: 'Jade Plant'),
        ),
      );

      final lastWatered = DateTime(2026, 9, 1);
      subject.container.read(addPlantProvider.notifier)
        ..setNotes('windowsill plant')
        ..setLastWateredAt(lastWatered)
        ..setMoistureLevel(MoistureLevel.low)
        ..toggleHealthStatus(HealthStatus.dormant)
        ..addImage(photoFile());
      await tester.pumpAndSettle();

      await tester.tap(find.text(identifyAction));
      await pumpAfterIo(tester);

      final plant = subject.container.read(addPlantProvider).plant;
      expect(plant.commonName, 'Jade Plant');
      expect(plant.lastWateredAt, lastWatered);
      expect(plant.moisture.level, MoistureLevel.low);
      expect(plant.healthStatus, HealthStatus.dormant);
      expect(plant.notes, 'windowsill plant');
    });

    testWidgets('a repeated proposal replaces the earlier one in the fields', (
      tester,
    ) async {
      final service = FakePlantIdentificationService(
        result: const PlantIdentification(commonName: 'Jade Plant'),
      );
      final subject = await pumpScreen(tester, service);

      subject.container.read(addPlantProvider.notifier).addImage(photoFile());
      await tester.pumpAndSettle();

      await tester.tap(find.text(identifyAction));
      await pumpAfterIo(tester);
      expect(textFieldValues(tester), contains('Jade Plant'));

      service.result = const PlantIdentification(commonName: 'Echeveria elegans');
      await tester.tap(find.text(identifyAction));
      await pumpAfterIo(tester);

      final values = textFieldValues(tester);
      expect(values, contains('Echeveria elegans'));
      expect(values, isNot(contains('Jade Plant')));
    });
  });

  group('submitting around a proposal', () {
    testWidgets('refuses to save without the values the system did not propose', (
      tester,
    ) async {
      final subject = await pumpScreen(tester, FakePlantIdentificationService(
          result: const PlantIdentification(
            commonName: 'Jade Plant',
            scientificName: 'Crassula ovata',
          ),
        ),
      );

      subject.container.read(addPlantProvider.notifier).addImage(photoFile());
      await tester.pumpAndSettle();

      await tester.tap(find.text(identifyAction));
      await pumpAfterIo(tester);

      await tester.tap(find.text('Guardar Planta'));
      await tester.pumpAndSettle();

      expect(subject.garden.created, isEmpty);
      expect(find.text('Please fill all the fields'), findsOneWidget);
    });

    testWidgets('saves once the user supplies the rest, with the proposed identity', (
      tester,
    ) async {
      final subject = await pumpScreen(tester, FakePlantIdentificationService(
          result: const PlantIdentification(
            commonName: 'Jade Plant',
            scientificName: 'Crassula ovata',
            category: 'succulents',
            wateringIntervalDays: 21,
          ),
        ),
      );

subject.container.read(addPlantProvider.notifier)
        ..addImage(photoFile())
        ..setMoistureLevel(MoistureLevel.low)
        ..setLastWateredAt(DateTime(2026, 9, 1))
        ..setNotes('windowsill plant');
      await tester.pumpAndSettle();

      await tester.tap(find.text(identifyAction));
      await pumpAfterIo(tester);

      await tester.tap(find.text('Guardar Planta'));
      await tester.pumpAndSettle();

      expect(subject.garden.created, hasLength(1));

      final saved = subject.garden.created.single;
      expect(saved.commonName, 'Jade Plant');
      expect(saved.scientificName, 'Crassula ovata');
      expect(saved.category, Category.succulents);
      expect(saved.wateringIntervalDays, 21);
      expect(saved.moisture.level, MoistureLevel.low);
      expect(saved.notes, 'windowsill plant');
      expect(saved.lastWateredAt, DateTime(2026, 9, 1));
    });

    testWidgets('a plant added without requesting identification behaves as before', (
      tester,
    ) async {
      final service = FakePlantIdentificationService(
        result: const PlantIdentification(commonName: 'Jade Plant'),
      );
      final subject = await pumpScreen(tester, service);

      await tester.pumpAndSettle();
      expect(find.text(identifyAction), findsNothing);

      subject.container.read(addPlantProvider.notifier)
        ..addImage(photoFile())
        ..setCommonName('Echeveria elegans')
        ..setScientificName('Echeveria elegans')
        ..setNotes('windowsill plant')
        ..setLastWateredAt(DateTime(2026, 9, 1));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Guardar Planta'));
      await tester.pumpAndSettle();

      expect(service.requests, isEmpty);
      expect(subject.garden.created, hasLength(1));
      expect(
        subject.garden.created.single.commonName,
        'Echeveria elegans',
      );
    });
  });
}