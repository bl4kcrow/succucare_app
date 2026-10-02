import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:succucare_app/core/errors/errors.dart';
import 'package:succucare_app/core/routes/app_router.dart';
import 'package:succucare_app/core/routes/routes.dart';
import 'package:succucare_app/core/theme/app_theme.dart';
import 'package:succucare_app/features/auth/models/models.dart';
import 'package:succucare_app/features/auth/providers/providers.dart';
import 'package:succucare_app/features/auth/repositories/repositories.dart';
import 'package:succucare_app/features/garden/datasource/datasource.dart';
import 'package:succucare_app/features/garden/models/models.dart';
import 'package:succucare_app/features/garden/providers/providers.dart';
import 'package:succucare_app/features/garden/repositories/repositories.dart';
import 'package:succucare_app/features/garden/widgets/widgets.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({required this.authenticated});

  final bool authenticated;

  @override
  AppUser currentUser() =>
      AppUser(id: 'user-1', name: 'Tester', email: 'tester@example.com');

  @override
  Stream<AuthenticationState> authStateChanges() => Stream<AuthenticationState>.value(
    authenticated ? AuthenticationState.authenticated : AuthenticationState.unauthenticated,
  );

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> deleteAccount() async {}

  @override
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async => currentUser();

  @override
  Future<void> signOut() async {}

  @override
  Future<AppUser> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async => currentUser();
}

class FakeGardenRepository implements GardenRepository {
  FakeGardenRepository(this.plants);

  final List<Plant> plants;
  final List<String> requestedIds = [];

  @override
  Future<Plant> loadPlantById(String plantId) async {
    requestedIds.add(plantId);

    return plants.firstWhere(
      (candidate) => candidate.id == plantId,
      orElse: () => throw AppFailure(AppFailureCode.notFound),
    );
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

GoRouter? capturedRouter;

Widget buildApp({
  required String initialLocation,
  required FakeAuthRepository authRepository,
  required FakeGardenRepository gardenRepository,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      gardenRepositoryImplProvider.overrideWithValue(gardenRepository),
    ],
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(appRouterProvider);
        capturedRouter = router;

        return MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.light(),
        );
      },
    ),
  );
}

Future<void> openLocation(WidgetTester tester, String location) async {
  capturedRouter!.go(location);
  await tester.pumpAndSettle();
}

Future<List<Plant>> testPlants() async {
  final page = await MockPlantsDatasource().loadInitialPlants();
  return page.plants
      .take(2)
      .map((plant) => plant.copyWith(primaryPhotoUrl: ''))
      .toList();
}

void main() {
  late List<Plant> plants;

  setUp(() async {
    plants = await testPlants();
  });

  testWidgets('an authenticated user reaches the edit form by address alone', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final gardenRepository = FakeGardenRepository(plants);

    await tester.pumpWidget(
      buildApp(
        initialLocation: Routes.splash.value,
        authRepository: FakeAuthRepository(authenticated: true),
        gardenRepository: gardenRepository,
      ),
    );
    await tester.pumpAndSettle();

    await openLocation(tester, '/edit-plant/${plants.first.id}');

    expect(find.text('Guardar Cambios'), findsOneWidget);
    expect(gardenRepository.requestedIds, [plants.first.id]);

    final fields = tester
        .widgetList<TextField>(find.byType(TextField))
        .map((field) => field.controller?.text ?? '')
        .toList();
    expect(fields, contains(plants.first.commonName));
    expect(fields, contains(plants.first.scientificName));
  });

  testWidgets('an unauthenticated user at the edit address lands on login', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final gardenRepository = FakeGardenRepository(plants);

    await tester.pumpWidget(
      buildApp(
        initialLocation: Routes.login.value,
        authRepository: FakeAuthRepository(authenticated: false),
        gardenRepository: gardenRepository,
      ),
    );
    await tester.pumpAndSettle();

    await openLocation(tester, '/edit-plant/${plants.first.id}');

    expect(find.text('Guardar Cambios'), findsNothing);
    expect(find.text('Sign In'), findsWidgets);
    expect(gardenRepository.requestedIds, isEmpty);
  });

  testWidgets('the edit address without an id lands on the garden', (tester) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        initialLocation: Routes.home.value,
        authRepository: FakeAuthRepository(authenticated: true),
        gardenRepository: FakeGardenRepository(plants),
      ),
    );
    await tester.pumpAndSettle();

    await openLocation(tester, Routes.editPlant.value);

    expect(find.byType(PlantCard), findsNWidgets(plants.length));
    expect(find.text('Guardar Cambios'), findsNothing);
    expect(capturedRouter!.state.uri.path, Routes.home.value);
  });

  testWidgets('tapping a garden plant card opens its own edit address', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final gardenRepository = FakeGardenRepository(plants);

    await tester.pumpWidget(
      buildApp(
        initialLocation: Routes.home.value,
        authRepository: FakeAuthRepository(authenticated: true),
        gardenRepository: gardenRepository,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PlantCard), findsNWidgets(plants.length));

    await tester.tap(find.byType(PlantCard).first);
    await tester.pumpAndSettle();

    expect(find.text('Guardar Cambios'), findsOneWidget);
    expect(gardenRepository.requestedIds, [plants.first.id]);
    expect(
      GoRouterState.of(tester.element(find.text('Guardar Cambios'))).uri.path,
      '/edit-plant/${plants.first.id}',
    );
  });
}
