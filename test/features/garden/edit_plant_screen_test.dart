import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:succucare_app/core/errors/errors.dart';
import 'package:succucare_app/features/garden/datasource/datasource.dart';
import 'package:succucare_app/features/garden/models/models.dart';
import 'package:succucare_app/features/garden/providers/providers.dart';
import 'package:succucare_app/features/garden/repositories/repositories.dart';
import 'package:succucare_app/features/garden/screens/screens.dart';

String renderedText(WidgetTester tester) {
  return tester
      .widgetList<Text>(find.byType(Text))
      .map((widget) => widget.data ?? widget.textSpan?.toPlainText() ?? '')
      .join(' | ');
}

class FakeGardenRepository implements GardenRepository {
  FakeGardenRepository({this.plants = const [], this.loadError});

  List<Plant> plants;
  Object? loadError;
  int loadCalls = 0;
  final List<String> requestedIds = [];

  void succeed() => loadError = null;

  @override
  Future<Plant> loadPlantById(String plantId) async {
    loadCalls++;
    requestedIds.add(plantId);

    if (loadError != null) throw loadError!;

    final plant = plants.firstWhere(
      (candidate) => candidate.id == plantId,
      orElse: () => throw AppFailure(AppFailureCode.notFound),
    );
    return plant;
  }

  @override
  Future<PlantPage> loadInitialPlants() async => PlantPage(plants: plants);

  @override
  Future<PlantPage> loadNextPlants(dynamic cursor) async =>
      const PlantPage(plants: []);

  @override
  Future<String> createPlant(Plant plant) async => plant.id;

  @override
  Future<void> updatePlant(Plant plant) async {}

  @override
  Future<void> updatePlantPhotoUrl(String url, String plantId) async {}
}

Future<Plant> storedPlant() async {
  final page = await MockPlantsDatasource().loadInitialPlants();
  return page.plants.first.copyWith(primaryPhotoUrl: '');
}

Widget subject(FakeGardenRepository repository, String plantId) {
  final router = GoRouter(
    initialLocation: '/edit-plant/$plantId',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Mi Jardin'))),
      ),
      GoRoute(
        path: '/edit-plant/:plantId',
        builder: (context, state) =>
            EditPlantScreen(plantId: state.pathParameters['plantId']!),
      ),
    ],
  );
  addTearDown(router.dispose);

  return UncontrolledProviderScope(
    container: ProviderContainer(
      overrides: [gardenRepositoryImplProvider.overrideWithValue(repository)],
    ),
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  late Plant plant;

  setUp(() async {
    plant = await storedPlant();
  });

  testWidgets('an unknown id reports the missing record and returns to the garden', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = FakeGardenRepository(plants: [plant]);

    await tester.pumpWidget(subject(repository, 'missing-id'));
    await tester.pumpAndSettle();

    expect(find.text('That record no longer exists.'), findsOneWidget);
    expect(find.text('Guardar Cambios'), findsNothing);
    expect(find.text('Limpiar'), findsNothing);
    expect(find.text('IDENTIFICACIÓN'), findsNothing);
    expect(find.text('Reintentar'), findsNothing);

    await tester.tap(find.text('Volver a Mi Jardín'));
    await tester.pumpAndSettle();

    expect(find.text('Mi Jardin'), findsOneWidget);
  });

  testWidgets('a read failure shows mapped wording with no technical detail and retries', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = FakeGardenRepository(
      plants: [plant],
      loadError: FirebaseException(
        plugin: 'cloud_firestore',
        code: 'permission-denied',
        message: 'Missing or insufficient permissions.',
      ),
    );

    await tester.pumpWidget(subject(repository, plant.id));
    await tester.pumpAndSettle();

    expect(find.text("You don't have access to that."), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);

    var rendered = renderedText(tester);
    expect(rendered, isNot(contains('permission-denied')));
    expect(rendered, isNot(contains('FirebaseException')));
    expect(rendered, isNot(contains('cloud_firestore')));
    expect(rendered, isNot(contains('insufficient permissions')));

    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(find.text("You don't have access to that."), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);

    repository.succeed();
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(find.text('Guardar Cambios'), findsOneWidget);
  });

  testWidgets('a pending load shows progress without editable fields, then the form', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = _DeferredGardenRepository(plants: [plant]);

    await tester.pumpWidget(subject(repository, plant.id));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsWidgets);
    expect(find.text('Guardar Cambios'), findsNothing);
    expect(find.text(plant.commonName), findsNothing);

    repository.complete();
    await tester.pumpAndSettle();

    expect(find.text('Guardar Cambios'), findsOneWidget);
    expect(find.text('IDENTIFICACIÓN'), findsOneWidget);

    final fields = tester
        .widgetList<TextField>(find.byType(TextField))
        .map((field) => field.controller?.text ?? '')
        .toList();
    expect(fields, contains(plant.commonName));
    expect(fields, contains(plant.scientificName));
  });

  testWidgets('a successful save reloads the plant by id', (tester) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = FakeGardenRepository(plants: [plant]);

    await tester.pumpWidget(subject(repository, plant.id));
    await tester.pumpAndSettle();

    expect(repository.loadCalls, 1);

    final success = await _submitFromContainer(tester, plant);
    expect(success, isTrue);

    await tester.pumpAndSettle();

    expect(repository.loadCalls, 2);
  });
}

class _DeferredGardenRepository extends FakeGardenRepository {
  _DeferredGardenRepository({required super.plants});

  final Completer<void> _gate = Completer<void>();

  void complete() => _gate.complete();

  @override
  Future<Plant> loadPlantById(String plantId) async {
    loadCalls++;
    requestedIds.add(plantId);
    await _gate.future;

    return plants.first;
  }
}

Future<bool> _submitFromContainer(WidgetTester tester, Plant plant) async {
  final container = ProviderScope.containerOf(
    tester.element(find.byType(EditPlantScreen)),
  );
  final success = await container
      .read(editPlantProvider(plant).notifier)
      .submitPlant();
  return success;
}
