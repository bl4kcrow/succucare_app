import 'package:succucare_app/features/garden/models/models.dart';

class PlantMapper {
  static Plant firestorePlantToPlant(FirestorePlant firestorePlant) {
    return Plant(
      id: firestorePlant.id,
      commonName: firestorePlant.commonName,
      scientificName: firestorePlant.scientificName,
      category: Category.values.firstWhere(
        (element) => element.name == firestorePlant.category,
      ),
      primaryPhotoUrl: firestorePlant.primaryPhotoUrl,
      healthStatus: HealthStatus.values.firstWhere(
        (element) => element.name == firestorePlant.healthStatus,
      ),
      lightingChange: firestorePlant.lightingChange,
      needsWater: firestorePlant.needsWater,
      repotting: firestorePlant.repotting,
      moisture: Moisture(
        level: MoistureLevel.values.firstWhere(
          (element) => element.name == firestorePlant.moisture.level,
        ),
        source: MoistureSource.values.firstWhere(
          (element) => element.name == firestorePlant.moisture.source,
        ),
        updatedAt: firestorePlant.moisture.updatedAt,
      ),
      illumination: Illumination(
        current: LightLevel.values.firstWhere(
          (element) => element.name == firestorePlant.illumination.current,
        ),
        target: LightLevel.values.firstWhere(
          (element) => element.name == firestorePlant.illumination.target,
        ),
        updatedAt: firestorePlant.illumination.updatedAt,
      ),
      lastWateredAt: firestorePlant.lastWateredAt,
      wateringIntervalDays: firestorePlant.wateringIntervalDays,
      nextWateringAt: firestorePlant.nextWateringAt,
      searchKeywords: firestorePlant.searchKeywords,
      notes: firestorePlant.notes,
      createdAt: firestorePlant.createdAt,
      updatedAt: firestorePlant.updatedAt,
    );
  }

  static FirestorePlant plantToFirestorePlant(Plant plant) {
    return FirestorePlant(
      id: plant.id,
      commonName: plant.commonName,
      scientificName: plant.scientificName,
      category: plant.category.name,
      primaryPhotoUrl: plant.primaryPhotoUrl,
      healthStatus: plant.healthStatus.name,
      lightingChange: plant.lightingChange,
      needsWater: plant.needsWater,
      repotting: plant.repotting,
      moisture: FirestoreMoisture(
        level: plant.moisture.level.name,
        source: plant.moisture.source.name,
        updatedAt: plant.moisture.updatedAt ?? DateTime.now(),
      ),
      illumination: FirestoreIllumination(
        current: plant.illumination.current.name,
        target: plant.illumination.target.name,
        updatedAt: plant.illumination.updatedAt ?? DateTime.now(),
      ),
      lastWateredAt: plant.lastWateredAt,
      wateringIntervalDays: plant.wateringIntervalDays,
      nextWateringAt: plant.nextWateringAt,
      searchKeywords: plant.searchKeywords,
      notes: plant.notes,
      createdAt: plant.createdAt ?? DateTime.now(),
      updatedAt: plant.updatedAt ?? DateTime.now(),
    );
  }
}
