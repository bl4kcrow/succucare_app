import 'package:succucare_app/features/garden/models/models.dart';

abstract class GardenRepository {
  Future<List<Plant>> loadInitialplants();
  Future<List<Plant>> loadNextplants();
  Future<String> createPlant(Plant plant);
  Future<void> updatePlantPhotoUrl(String url, String plantId);
}
