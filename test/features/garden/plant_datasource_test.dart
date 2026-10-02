import 'package:flutter_test/flutter_test.dart';

import 'package:succucare_app/core/errors/errors.dart';
import 'package:succucare_app/features/garden/datasource/datasource.dart';
import 'package:succucare_app/features/garden/models/models.dart';
import 'package:succucare_app/features/garden/providers/providers.dart';

class FakePlantsDatasource implements PlantsDatasource {
  FakePlantsDatasource({required this.plant});

  final Plant plant;

  @override
  Future<PlantPage> loadInitialPlants() async => PlantPage(plants: [plant]);

  @override
  Future<PlantPage> loadNextPlants(dynamic cursor) async => const PlantPage(plants: []);

  @override
  Future<Plant> loadPlantById(String plantId) async {
    if (plantId == plant.id) {
      return plant;
    }
    throw AppFailure(AppFailureCode.notFound);
  }

  @override
  Future<String> createPlant(Plant plant) async => 'new';

  @override
  Future<void> updatePlant(Plant plant) async {}

  @override
  Future<void> updatePlantPhotoUrl(String url, String plantId) async {}
}

void main() {
  test('MockPlantsDatasource returns plant for existing id', () async {
    final ds = MockPlantsDatasource();
    final page = await ds.loadInitialPlants();
    final result = await ds.loadPlantById('1');
    expect(result.id, '1');
    expect(result.commonName, page.plants.first.commonName);
  });

  test('MockPlantsDatasource throws notFound for unknown id', () async {
    final ds = MockPlantsDatasource();
    expect(
      () => ds.loadPlantById('unknown'),
      throwsA(isA<AppFailure>().having((f) => f.code, 'code', AppFailureCode.notFound)),
    );
  });

  test('GardenRepository delegates loadPlantById to datasource', () async {
    final plant = (await MockPlantsDatasource().loadInitialPlants()).plants.first;
    final ds = FakePlantsDatasource(plant: plant);
    final repo = GardenRespositoryImpl(ds);
    final result = await repo.loadPlantById('1');
    expect(result, plant);
  });
}
