import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:succucare_app/features/garden/datasource/datasource.dart';
import 'package:succucare_app/features/garden/models/models.dart';
import 'package:succucare_app/features/garden/repositories/repositories.dart';

part 'garden_repository_impl_provider.g.dart';

@riverpod
GardenRepository gardenRepositoryImpl(Ref ref) =>
    GardenRespositoryImpl(FirestorePlantsDatasource());

class GardenRespositoryImpl implements GardenRepository {
  GardenRespositoryImpl(this.plantsDatasource);

  final PlantsDatasource plantsDatasource;

  @override
  Future<PlantPage> loadInitialPlants() {
    return plantsDatasource.loadInitialPlants();
  }

  @override
  Future<PlantPage> loadNextPlants(dynamic nextCursor) {
    return plantsDatasource.loadNextPlants(nextCursor);
  }

  @override
  Future<String> createPlant(Plant plant) {
    return plantsDatasource.createPlant(plant);
  }

  @override
  Future<void> updatePlant(Plant plant) {
    return plantsDatasource.updatePlant(plant);
  }

  @override
  Future<void> updatePlantPhotoUrl(String url, String plantId) {
    return plantsDatasource.updatePlantPhotoUrl(url, plantId);
  }
}
