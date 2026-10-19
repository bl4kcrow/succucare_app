import 'plant.dart';

class PlantPage {
  const PlantPage({required this.plants, this.nextCursor});

  final List<Plant> plants;
  final dynamic nextCursor;
}