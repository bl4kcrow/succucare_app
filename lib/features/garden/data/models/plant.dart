import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant.freezed.dart';
part 'plant.g.dart';

enum HealthStatus {
  healthy('Saludable'),
  sick('Enferma'),
  recovering('Recuperación'),
  dormant('Inactiva');

  final String label;
  const HealthStatus(this.label);
}

enum Category {
  succulents('Suculenta'),
  cactus('Cactus'),
  lithops('Lithops');

  final String label;
  const Category(this.label);
}

enum MoistureLevel {
  low('Baja'),
  medium('Media'),
  optimal('Optima');

  final String label;
  const MoistureLevel(this.label);
}

enum MoistureSource {
  manual('Manual'),
  sensor('Sensor'),
  inferred('Inferida');

  final String label;
  const MoistureSource(this.label);
}

enum LightLevel {
  fullSun('Sol Pleno'),
  brightIndirect('Luz Indirecta'),
  partialSun('Sol Parcial'),
  shade('Sombra');

  final String label;
  const LightLevel(this.label);
}

@freezed
abstract class Moisture with _$Moisture {
  const factory Moisture({
    required MoistureLevel level,
    required MoistureSource source,
    DateTime? updatedAt,
  }) = _Moisture;

  factory Moisture.fromJson(Map<String, Object?> json) =>
      _$MoistureFromJson(json);
}

@freezed
abstract class Illumination with _$Illumination {
  const factory Illumination({
    required LightLevel current,
    required LightLevel target,
    DateTime? updatedAt,
  }) = _Illumination;

  factory Illumination.fromJson(Map<String, Object?> json) =>
      _$IlluminationFromJson(json);
}

@freezed
abstract class Plant with _$Plant {
  @JsonSerializable(explicitToJson: true)
  const factory Plant({
    required String id,
    required String commonName,
    required String scientificName,
    required Category category,
    required String primaryPhotoUrl,
    required HealthStatus healthStatus,
    required bool lightingChange,
    required bool needsWater,
    required bool repotting,
    required Moisture moisture,
    required Illumination illumination,
    DateTime? lastWateredAt,
    required int wateringIntervalDays,
    DateTime? nextWateringAt,
    required List<String> searchKeywords,
    required String notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Plant;

  factory Plant.fromJson(Map<String, Object?> json) => _$PlantFromJson(json);
}
