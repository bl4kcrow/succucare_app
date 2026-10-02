import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:succucare_app/core/errors/errors.dart';
import 'package:succucare_app/features/garden/datasource/datasource.dart';
import 'package:succucare_app/features/garden/models/models.dart';
import 'package:succucare_app/features/garden/providers/providers.dart';
import 'package:succucare_app/features/garden/repositories/repositories.dart';
import 'package:succucare_app/features/garden/screens/screens.dart';

const String transparentPng =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';

class RecordingGardenRepository implements GardenRepository {
  RecordingGardenRepository({
    this.createPlantId = 'new-plant-id',
    this.createError,
    this.updateError,
    this.plants = const [],
  });

  int createCalls = 0;
  int updateCalls = 0;
  final String createPlantId;
  final Object? createError;
  final Object? updateError;
  final List<Plant> plants;

  @override
  Future<Plant> loadPlantById(String plantId) async {
    final plant = plants.where((candidate) => candidate.id == plantId).firstOrNull;
    if (plant == null) throw AppFailure(AppFailureCode.notFound);
    return plant;
  }

  @override
  Future<PlantPage> loadInitialPlants() async =>
      const PlantPage(plants: []);

  @override
  Future<PlantPage> loadNextPlants(dynamic cursor) async =>
      const PlantPage(plants: []);

  @override
  Future<String> createPlant(Plant plant) async {
    createCalls++;

    if (createError != null) throw createError!;

    return createPlantId;
  }

  @override
  Future<void> updatePlant(Plant plant) async {
    updateCalls++;

    if (updateError != null) throw updateError!;
  }

  @override
  Future<void> updatePlantPhotoUrl(String url, String plantId) async {}
}

class RecordingPhotosRepository implements PhotosRepository {
  RecordingPhotosRepository({this.uploadError});

  int uploadCalls = 0;
  final Object? uploadError;

  @override
  Future<String> uploadPlantPhoto(String plantId, File imageFile) async {
    uploadCalls++;

    if (uploadError != null) throw uploadError!;

    return 'https://example.com/$plantId.jpg';
  }

  @override
  Future<void> deletePlantPhoto(String photoUrl) async {}
}

String renderedText(WidgetTester tester) {
  return tester
      .widgetList<Text>(find.byType(Text))
      .map((widget) => widget.data ?? widget.textSpan?.toPlainText() ?? '')
      .join(' | ');
}

Future<Plant> plantWithoutPhoto() async {
  final page = await MockPlantsDatasource().loadInitialPlants();

  return page.plants.first.copyWith(primaryPhotoUrl: '');
}

void main() {
  late Directory tempDirectory;

  setUp(() {
    tempDirectory = Directory.systemTemp.createTempSync('plant_failure');
  });

  tearDown(() {
    tempDirectory.deleteSync(recursive: true);
  });

  testWidgets('add plant stores the mapped storage wording and renders it', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final garden = RecordingGardenRepository();
    final photos = RecordingPhotosRepository(
      uploadError: FirebaseException(
        plugin: 'firebase_storage',
        code: 'storage/quota-exceeded',
        message: 'Quota exceeded for bucket succucare',
      ),
    );
    final image = File('${tempDirectory.path}${Platform.pathSeparator}luna.png')
      ..writeAsBytesSync(base64Decode(transparentPng));

    final container = ProviderContainer(
      overrides: [
        gardenRepositoryImplProvider.overrideWithValue(garden),
        photosRepositoryImplProvider.overrideWithValue(photos),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: AddPlantScreen()),
      ),
    );
    await tester.pumpAndSettle();

    final notifier = container.read(addPlantProvider.notifier)
      ..setScientificName('Echeveria elegans')
      ..setCommonName('Luna')
      ..setLastWateredAt(DateTime(2026, 9, 1))
      ..setNotes('windowsill plant')
      ..addImage(image);

    final success = await notifier.submitPlant();

    expect(success, isFalse);
    expect(garden.createCalls, 1);
    expect(photos.uploadCalls, 1);
    expect(
      container.read(addPlantProvider).errorMessage?.userMessage,
      'Storage is full. Free up space.',
    );

    await tester.pumpAndSettle();

    expect(find.text('Storage is full. Free up space.'), findsOneWidget);

    final rendered = renderedText(tester);
    expect(rendered, isNot(contains('storage/quota-exceeded')));
    expect(rendered, isNot(contains('FirebaseException')));
    expect(rendered, isNot(contains('succucare')));
    expect(rendered, isNot(contains('Quota exceeded')));
  });

  testWidgets('edit plant stores the mapped firestore wording and renders it', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final plant = await plantWithoutPhoto();
    final garden = RecordingGardenRepository(
      plants: [plant],
      updateError: FirebaseException(
        plugin: 'cloud_firestore',
        code: 'permission-denied',
        message: 'Missing or insufficient permissions.',
      ),
    );

    final container = ProviderContainer(
      overrides: [gardenRepositoryImplProvider.overrideWithValue(garden)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(home: EditPlantScreen(plantId: plant.id)),
      ),
    );
    await tester.pumpAndSettle();

    final success = await container
        .read(editPlantProvider(plant).notifier)
        .submitPlant();

    expect(success, isFalse);
    expect(garden.updateCalls, 1);
    expect(
      container.read(editPlantProvider(plant)).errorMessage?.userMessage,
      "You don't have access to that.",
    );

    await tester.pumpAndSettle();

    expect(find.text("You don't have access to that."), findsOneWidget);

    final rendered = renderedText(tester);
    expect(rendered, isNot(contains('permission-denied')));
    expect(rendered, isNot(contains('FirebaseException')));
    expect(rendered, isNot(contains('cloud_firestore')));
    expect(rendered, isNot(contains('insufficient permissions')));
  });

  testWidgets('the validation path shows the validation wording and skips the repository', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final garden = RecordingGardenRepository();
    final photos = RecordingPhotosRepository();

    final container = ProviderContainer(
      overrides: [
        gardenRepositoryImplProvider.overrideWithValue(garden),
        photosRepositoryImplProvider.overrideWithValue(photos),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: AddPlantScreen()),
      ),
    );
    await tester.pumpAndSettle();

    final success = await container.read(addPlantProvider.notifier).submitPlant();

    expect(success, isFalse);
    expect(garden.createCalls, 0);
    expect(photos.uploadCalls, 0);
    expect(
      container.read(addPlantProvider).errorMessage?.userMessage,
      'Please fill all the fields',
    );

    await tester.pumpAndSettle();

    expect(find.text('Please fill all the fields'), findsOneWidget);
    expect(renderedText(tester), isNot(contains('AppFailure')));
  });
}
