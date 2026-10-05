import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:succucare_app/core/errors/errors.dart';
import 'package:succucare_app/features/garden/models/models.dart';
import 'package:succucare_app/features/garden/providers/providers.dart';
import 'package:succucare_app/features/garden/repositories/repositories.dart';
import 'package:succucare_app/features/garden/services/services.dart';

const String transparentPng =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';

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
  int uploadCalls = 0;

  @override
  Future<String> uploadPlantPhoto(String plantId, File imageFile) async {
    uploadCalls++;
    return 'https://example.com/$plantId.jpg';
  }

  @override
  Future<void> deletePlantPhoto(String photoUrl) async {}
}

class BlockingPlantIdentificationService implements PlantIdentificationService {
  final Completer<PlantIdentification> gate = Completer<PlantIdentification>();
  final List<PlantPhotoInput> requests = [];

  @override
  Future<PlantIdentification> identify(PlantPhotoInput photo) {
    requests.add(photo);
    return gate.future;
  }
}

void main() {
  late Directory tempDirectory;

  setUp(() {
    tempDirectory = Directory.systemTemp.createTempSync('add_plant_identify');
  });

  tearDown(() {
    tempDirectory.deleteSync(recursive: true);
  });

  File photoFile({String name = 'luna.png', int bytes = 16}) {
    final file = File(
      '${tempDirectory.path}${Platform.pathSeparator}$name',
    )..writeAsBytesSync(
      bytes == 16 ? base64Decode(transparentPng) : List<int>.filled(bytes, 0),
    );
    return file;
  }

  ProviderContainer containerWith(
    PlantIdentificationService service, {
    RecordingGardenRepository? garden,
  }) {
    final container = ProviderContainer(
      overrides: [
        plantIdentificationServiceProvider.overrideWithValue(service),
        gardenRepositoryImplProvider.overrideWithValue(
          garden ?? RecordingGardenRepository(),
        ),
        photosRepositoryImplProvider.overrideWithValue(
          RecordingPhotosRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    // `addPlantProvider` is autoDispose, so a listener is what keeps the
    // notifier alive across the awaits these tests make.
    addTearDown(container.listen(addPlantProvider, (_, _) {}).close);

    return container;
  }

  AddPlantNotifier notifierOf(ProviderContainer container) =>
      container.read(addPlantProvider.notifier);

  NewPlantState stateOf(ProviderContainer container) =>
      container.read(addPlantProvider);

  group('identification state', () {
    test('a fresh state is idle with no error', () {
      final state = NewPlantState();

      expect(state.identificationStatus, IdentificationStatus.idle);
      expect(state.isIdentifying, isFalse);
      expect(state.errorMessage, isNull);
    });

    test('copyWith moves the status without disturbing the rest', () {
      final images = [photoFile()];
      final state = NewPlantState(selectedImages: images);

      final inProgress = state.copyWith(
        identificationStatus: IdentificationStatus.inProgress,
      );

      expect(inProgress.identificationStatus, IdentificationStatus.inProgress);
      expect(inProgress.isIdentifying, isTrue);
      expect(inProgress.selectedImages, same(images));
      expect(inProgress.plant, same(state.plant));

      final completed = inProgress.copyWith(
        identificationStatus: IdentificationStatus.completed,
      );
      expect(completed.identificationStatus, IdentificationStatus.completed);
      expect(completed.isIdentifying, isFalse);
    });

    test('clearIdentification returns a completed state to idle', () {
      final state = NewPlantState().copyWith(
        identificationStatus: IdentificationStatus.completed,
      );

      final cleared = state.clearIdentification();

      expect(cleared.identificationStatus, IdentificationStatus.idle);
    });

    test('a notifier reset returns the state to idle', () {
      final container = containerWith(FakePlantIdentificationService());
      final notifier = notifierOf(container);

      notifier
        ..addImage(photoFile())
        ..setCommonName('Luna');
      notifier.clearIdentification();

      expect(stateOf(container).identificationStatus, IdentificationStatus.idle);

      notifier.reset();

      final reset = stateOf(container);
      expect(reset.identificationStatus, IdentificationStatus.idle);
      expect(reset.plant.commonName, '');
      expect(reset.selectedImages, isEmpty);
    });
  });

  group('identify', () {
    test('makes no call when no photo is attached', () async {
      final service = FakePlantIdentificationService(
        result: const PlantIdentification(commonName: 'Jade Plant'),
      );
      final container = containerWith(service);

      final success = await notifierOf(container).identify();

      expect(success, isFalse);
      expect(service.requests, isEmpty);
      expect(stateOf(container).identificationStatus, IdentificationStatus.idle);
      expect(stateOf(container).plant.commonName, '');
    });

    test('makes no second call while a request is already in flight', () async {
      final service = BlockingPlantIdentificationService();
      final container = containerWith(service);

      notifierOf(container).addImage(photoFile());

      final first = notifierOf(container).identify();
      // Wait for the photo read to hand off to the blocked service.
      while (service.requests.isEmpty) {
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }

      expect(
        stateOf(container).identificationStatus,
        IdentificationStatus.inProgress,
      );

      expect(await notifierOf(container).identify(), isFalse);
      expect(service.requests, hasLength(1));

      service.gate.complete(
        const PlantIdentification(commonName: 'Jade Plant'),
      );
      expect(await first, isTrue);
      expect(stateOf(container).identificationStatus, IdentificationStatus.completed);
    });

    test('makes no call and reports the too-large wording when the photo is oversized', () async {
      final service = FakePlantIdentificationService(
        result: const PlantIdentification(commonName: 'Jade Plant'),
      );
      final container = containerWith(service);

      notifierOf(container).addImage(
        photoFile(bytes: maxIdentificationPhotoBytes + 1),
      );

      final success = await notifierOf(container).identify();

      expect(success, isFalse);
      expect(service.requests, isEmpty);
      expect(
        stateOf(container).errorMessage?.userMessage,
        'That photo is too large to identify. Choose another.',
      );
      expect(
        stateOf(container).errorMessage?.code,
        AppFailureCode.plantIdentificationPhotoTooLarge,
      );
      expect(stateOf(container).plant.commonName, '');
    });

    test('accepts a photo exactly at the limit', () async {
      final service = FakePlantIdentificationService(
        result: const PlantIdentification(commonName: 'Jade Plant'),
      );
      final container = containerWith(service);

      notifierOf(container).addImage(
        photoFile(bytes: maxIdentificationPhotoBytes),
      );

      final success = await notifierOf(container).identify();

      expect(service.requests, hasLength(1));
      expect(success, isTrue);
    });

    test('sends the attached photo with the type derived from its extension', () async {
      final service = FakePlantIdentificationService(
        result: const PlantIdentification(commonName: 'Jade Plant'),
      );
      final container = containerWith(service);

      notifierOf(container).addImage(photoFile(name: 'luna.heic'));
      await notifierOf(container).identify();

      expect(service.requests.single.mimeType, 'image/heic');
    });

    test('applies a successful result and reports completion', () async {
      final service = FakePlantIdentificationService(
        result: const PlantIdentification(
          commonName: 'Jade Plant',
          scientificName: 'Crassula ovata',
          category: 'succulents',
          wateringIntervalDays: 21,
          lightLevel: 'brightIndirect',
        ),
      );
      final container = containerWith(service);

      notifierOf(container).addImage(photoFile());
      final success = await notifierOf(container).identify();

      expect(success, isTrue);

      final plant = stateOf(container).plant;
      expect(plant.commonName, 'Jade Plant');
      expect(plant.scientificName, 'Crassula ovata');
      expect(plant.category, Category.succulents);
      expect(plant.wateringIntervalDays, 21);
      expect(plant.illumination.current, LightLevel.brightIndirect);
      expect(plant.illumination.target, LightLevel.brightIndirect);
      expect(stateOf(container).identificationStatus, IdentificationStatus.completed);
      expect(stateOf(container).errorMessage, isNull);
    });

    test('reports the unavailable wording and calls nothing', () async {
      final service = FakePlantIdentificationService(
        error: AppFailure(AppFailureCode.plantIdentificationUnavailable),
      );
      final container = containerWith(service);

      notifierOf(container).addImage(photoFile());
      final success = await notifierOf(container).identify();

      expect(success, isFalse);
      expect(
        stateOf(container).errorMessage?.userMessage,
        "Plant identification isn't available right now.",
      );
      expect(stateOf(container).identificationStatus, IdentificationStatus.idle);
    });

    test('reports the no-usable-result wording for an empty proposal', () async {
      final service = FakePlantIdentificationService();
      final container = containerWith(service);

      notifierOf(container)
        ..addImage(photoFile())
        ..setCommonName('My own name');
      final success = await notifierOf(container).identify();

      expect(success, isFalse);
      expect(
        stateOf(container).errorMessage?.userMessage,
        "Couldn't identify that plant. Fill in the details yourself.",
      );
      expect(stateOf(container).plant.commonName, 'My own name');
    });

    test('a failure leaves the existing field values unchanged', () async {
      final service = FakePlantIdentificationService(
        error: Exception('socket closed'),
      );
      final container = containerWith(service);

      notifierOf(container)
        ..addImage(photoFile())
        ..setCommonName('My own name')
        ..setScientificName('My own species')
        ..setWateringIntervalDays(3);

      final before = stateOf(container).plant;
      final success = await notifierOf(container).identify();

      expect(success, isFalse);
      expect(stateOf(container).plant, before);
      expect(stateOf(container).identificationStatus, IdentificationStatus.idle);
    });
  });

  group('applyIdentification', () {
    test('leaves the fields untouched when every value is null', () {
      final container = containerWith(FakePlantIdentificationService());
      final notifier = notifierOf(container);

      notifier
        ..setCommonName('My own name')
        ..setWateringIntervalDays(3);
      final before = stateOf(container).plant;

      notifier.applyIdentification(const PlantIdentification());

      expect(stateOf(container).plant, before);
    });

    test('changes the fields a result carries', () {
      final container = containerWith(FakePlantIdentificationService());

      notifierOf(container).applyIdentification(
        const PlantIdentification(
          commonName: 'Christmas Cactus',
          scientificName: 'Schlumbergera truncata',
          category: 'cactus',
          wateringIntervalDays: 14,
          lightLevel: 'partialSun',
        ),
      );

      final plant = stateOf(container).plant;
      expect(plant.commonName, 'Christmas Cactus');
      expect(plant.scientificName, 'Schlumbergera truncata');
      expect(plant.category, Category.cactus);
      expect(plant.wateringIntervalDays, 14);
      expect(plant.illumination.current, LightLevel.partialSun);
      expect(plant.illumination.target, LightLevel.partialSun);
    });

    test('an out-of-vocabulary category leaves the category untouched', () {
      final container = containerWith(FakePlantIdentificationService());

      notifierOf(container)
        ..toggleCategory(Category.lithops)
        ..applyIdentification(
          const PlantIdentification(category: 'aloe', commonName: 'Aloe Vera'),
        );

      expect(stateOf(container).plant.category, Category.lithops);
      expect(stateOf(container).plant.commonName, 'Aloe Vera');
    });

    test('recomputes lightingChange from the proposed light level', () {
      final container = containerWith(FakePlantIdentificationService());

      notifierOf(container)
        ..setTargetIllumination(LightLevel.shade)
        ..applyIdentification(
          const PlantIdentification(lightLevel: 'brightIndirect'),
        );

      final plant = stateOf(container).plant;
      expect(plant.illumination.current, LightLevel.brightIndirect);
      expect(plant.illumination.target, LightLevel.brightIndirect);
      expect(plant.lightingChange, isFalse);
    });

    test('a later proposal replaces an earlier one', () async {
      final service = FakePlantIdentificationService(
        result: const PlantIdentification(
          commonName: 'Jade Plant',
          category: 'succulents',
        ),
      );
      final container = containerWith(service);

      notifierOf(container).addImage(photoFile());
      await notifierOf(container).identify();
      expect(stateOf(container).plant.commonName, 'Jade Plant');

      service.result = const PlantIdentification(
        commonName: 'Echeveria elegans',
        category: 'succulents',
      );
      await notifierOf(container).identify();

      expect(stateOf(container).plant.commonName, 'Echeveria elegans');
      expect(stateOf(container).identificationStatus, IdentificationStatus.completed);
    });

    test('a proposal covers only the five permitted values', () async {
      final service = FakePlantIdentificationService(
        result: const PlantIdentification(commonName: 'Jade Plant'),
      );
      final container = containerWith(service);
      final notifier = notifierOf(container);

      final lastWatered = DateTime(2026, 9, 1);
      notifier
        ..setLastWateredAt(lastWatered)
        ..setMoistureLevel(MoistureLevel.low)
        ..setMoistureSource(MoistureSource.sensor)
        ..toggleHealthStatus(HealthStatus.sick)
        ..setNotes('sitting on the desk');

      notifier.addImage(photoFile());
      await notifier.identify();

      final plant = stateOf(container).plant;
      expect(plant.commonName, 'Jade Plant');
      expect(plant.lastWateredAt, lastWatered);
      expect(plant.moisture.level, MoistureLevel.low);
      expect(plant.moisture.source, MoistureSource.sensor);
      expect(plant.healthStatus, HealthStatus.sick);
      expect(plant.notes, 'sitting on the desk');
    });
  });

  group('submitPlant after a proposal', () {
    test('refuses to save without the values the system did not propose', () async {
      final service = FakePlantIdentificationService(
        result: const PlantIdentification(
          commonName: 'Jade Plant',
          scientificName: 'Crassula ovata',
        ),
      );
      final garden = RecordingGardenRepository();
      final container = containerWith(service, garden: garden);

      notifierOf(container).addImage(photoFile());
      await notifierOf(container).identify();

      final success = await notifierOf(container).submitPlant();

      expect(success, isFalse);
      expect(garden.created, isEmpty);
      expect(
        stateOf(container).errorMessage?.userMessage,
        'Please fill all the fields',
      );
    });

    test('saves with the proposed identity once the rest is supplied', () async {
      final service = FakePlantIdentificationService(
        result: const PlantIdentification(
          commonName: 'Jade Plant',
          scientificName: 'Crassula ovata',
          category: 'succulents',
          wateringIntervalDays: 21,
          lightLevel: 'brightIndirect',
        ),
      );
      final garden = RecordingGardenRepository();
      final container = containerWith(service, garden: garden);

      notifierOf(container).addImage(photoFile());
      await notifierOf(container).identify();

      notifierOf(container)
        ..setLastWateredAt(DateTime(2026, 9, 1))
        ..setNotes('windowsill plant');

      final success = await notifierOf(container).submitPlant();

      expect(success, isTrue);
      expect(garden.created, hasLength(1));

      final saved = garden.created.single;
      expect(saved.commonName, 'Jade Plant');
      expect(saved.scientificName, 'Crassula ovata');
      expect(saved.category, Category.succulents);
      expect(saved.wateringIntervalDays, 21);
      expect(saved.illumination.current, LightLevel.brightIndirect);
      expect(saved.lightingChange, isFalse);
      expect(saved.searchKeywords, containsAll(['jade', 'plant', 'succulents']));
      expect(saved.searchKeywords, containsAll(['crassula', 'ovata']));
      expect(saved.notes, 'windowsill plant');
      expect(saved.lastWateredAt, DateTime(2026, 9, 1));
    });

    test('a proposed value the user clears stays cleared and is not restored', () async {
      final service = FakePlantIdentificationService(
        result: const PlantIdentification(
          commonName: 'Jade Plant',
          scientificName: 'Crassula ovata',
        ),
      );
      final garden = RecordingGardenRepository();
      final container = containerWith(service, garden: garden);

      notifierOf(container)
        ..addImage(photoFile())
        ..setLastWateredAt(DateTime(2026, 9, 1))
        ..setNotes('windowsill plant');
      await notifierOf(container).identify();

      notifierOf(container).setCommonName('');

      expect(stateOf(container).plant.commonName, '');
      expect(stateOf(container).plant.scientificName, 'Crassula ovata');

      // Clearing a required proposed value leaves the plant unsaveable, on the
      // same wording as any other incomplete input.
      final success = await notifierOf(container).submitPlant();

      expect(success, isFalse);
      expect(garden.created, isEmpty);
      expect(
        stateOf(container).errorMessage?.userMessage,
        'Please fill all the fields',
      );
    });

    test('a plant added without ever requesting identification behaves as before', () async {
      final service = FakePlantIdentificationService(
        result: const PlantIdentification(commonName: 'Jade Plant'),
      );
      final garden = RecordingGardenRepository();
      final container = containerWith(service, garden: garden);

      notifierOf(container)
        ..setCommonName('Echeveria elegans')
        ..setScientificName('Echeveria elegans')
        ..setLastWateredAt(DateTime(2026, 9, 1))
        ..setNotes('windowsill plant')
        ..addImage(photoFile());

      final success = await notifierOf(container).submitPlant();

      expect(success, isTrue);
      expect(service.requests, isEmpty);
      expect(garden.created.single.commonName, 'Echeveria elegans');
    });

    test('validation still refuses a plant missing only the notes', () async {
      final garden = RecordingGardenRepository();
      final container = containerWith(
        FakePlantIdentificationService(),
        garden: garden,
      );

      notifierOf(container)
        ..setCommonName('Luna')
        ..setScientificName('Echeveria elegans')
        ..setLastWateredAt(DateTime(2026, 9, 1));

      final success = await notifierOf(container).submitPlant();

      expect(success, isFalse);
      expect(garden.created, isEmpty);
    });
  });
}