import 'package:succucare_app/features/garden/models/models.dart';

abstract class GardenRepository {
  Future<PlantPage> loadInitialPlants();
  Future<PlantPage> loadNextPlants(dynamic cursor);
  Future<Plant> loadPlantById(String plantId);
  Future<String> createPlant(Plant plant);
  Future<void> updatePlant(Plant plant);
  Future<void> updatePlantPhotoUrl(String url, String plantId);
}
