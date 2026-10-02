import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:succucare_app/core/errors/errors.dart';
import 'package:succucare_app/features/garden/datasource/datasource.dart';
import 'package:succucare_app/features/garden/models/models.dart';
import 'package:succucare_app/features/garden/providers/providers.dart';
import 'package:succucare_app/features/garden/repositories/repositories.dart';

class RecordingByIdGardenRepository implements GardenRepository {
  RecordingByIdGardenRepository({this.plant, this.error});

  final Plant? plant;
  final Object? error;
  final List<String> requestedIds = [];

  @override
  Future<Plant> loadPlantById(String plantId) async {
    requestedIds.add(plantId);
    if (error != null) throw error!;
    return plant!;
  }

  @override
  Future<PlantPage> loadInitialPlants() async => const PlantPage(plants: []);

  @override
  Future<PlantPage> loadNextPlants(dynamic cursor) async => const PlantPage(plants: []);

  @override
  Future<String> createPlant(Plant plant) async => 'new';

  @override
  Future<void> updatePlant(Plant plant) async {}

  @override
  Future<void> updatePlantPhotoUrl(String url, String plantId) async {}
}

Future<Plant> testPlant() async {
  final page = await MockPlantsDatasource().loadInitialPlants();
  return page.plants.first;
}

void main() {
  test('plantByIdProvider returns the repository plant for the requested id', () async {
    final plant = await testPlant();
    final repository = RecordingByIdGardenRepository(plant: plant);

    final container = ProviderContainer(
      overrides: [gardenRepositoryImplProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final result = await container.read(plantByIdProvider('42').future);

    expect(result, plant);
    expect(repository.requestedIds, ['42']);
  });

  test('plantByIdProvider surfaces notFound as an error state', () async {
    final repository = RecordingByIdGardenRepository(
      error: AppFailure(AppFailureCode.notFound),
    );

    final container = ProviderContainer(
      overrides: [gardenRepositoryImplProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final provider = plantByIdProvider('missing');
    final states = <AsyncValue<Plant>>[];
    container.listen(provider, (_, next) => states.add(next), fireImmediately: true);

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(states.last.hasError, isTrue);
    expect(states.last.error, isA<AppFailure>());
    expect((states.last.error! as AppFailure).code, AppFailureCode.notFound);
    expect(repository.requestedIds, ['missing']);
  });
}