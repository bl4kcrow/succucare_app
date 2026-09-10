// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Moisture _$MoistureFromJson(Map<String, dynamic> json) => _Moisture(
  level: $enumDecode(_$MoistureLevelEnumMap, json['level']),
  source: $enumDecode(_$MoistureSourceEnumMap, json['source']),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$MoistureToJson(_Moisture instance) => <String, dynamic>{
  'level': _$MoistureLevelEnumMap[instance.level]!,
  'source': _$MoistureSourceEnumMap[instance.source]!,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$MoistureLevelEnumMap = {
  MoistureLevel.low: 'low',
  MoistureLevel.medium: 'medium',
  MoistureLevel.optimal: 'optimal',
};

const _$MoistureSourceEnumMap = {
  MoistureSource.manual: 'manual',
  MoistureSource.sensor: 'sensor',
  MoistureSource.inferred: 'inferred',
};

_Illumination _$IlluminationFromJson(Map<String, dynamic> json) =>
    _Illumination(
      current: $enumDecode(_$LightLEvelEnumMap, json['current']),
      target: $enumDecode(_$LightLEvelEnumMap, json['target']),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$IlluminationToJson(_Illumination instance) =>
    <String, dynamic>{
      'current': _$LightLEvelEnumMap[instance.current]!,
      'target': _$LightLEvelEnumMap[instance.target]!,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$LightLEvelEnumMap = {
  LightLevel.fullSun: 'fullSun',
  LightLevel.brightIndirect: 'brightIndirect',
  LightLevel.partialSun: 'partialSun',
  LightLevel.shade: 'shade',
};

_Plant _$PlantFromJson(Map<String, dynamic> json) => _Plant(
  id: json['id'] as String,
  commonName: json['commonName'] as String,
  scientificName: json['scientificName'] as String,
  category: $enumDecode(_$CategoryEnumMap, json['category']),
  primaryPhotoUrl: json['primaryPhotoUrl'] as String,
  healthStatus: $enumDecode(_$HealthStatusEnumMap, json['healthStatus']),
  lightingChange: json['lightingChange'] as bool,
  needsWater: json['needsWater'] as bool,
  repotting: json['repotting'] as bool,
  moisture: Moisture.fromJson(json['moisture'] as Map<String, dynamic>),
  illumination: Illumination.fromJson(
    json['illumination'] as Map<String, dynamic>,
  ),
  lastWateredAt: json['lastWateredAt'] == null
      ? null
      : DateTime.parse(json['lastWateredAt'] as String),
  wateringIntervalDays: (json['wateringIntervalDays'] as num).toInt(),
  nextWateringAt: json['nextWateringAt'] == null
      ? null
      : DateTime.parse(json['nextWateringAt'] as String),
  searchKeywords: (json['searchKeywords'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  notes: json['notes'] as String,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PlantToJson(_Plant instance) => <String, dynamic>{
  'id': instance.id,
  'commonName': instance.commonName,
  'scientificName': instance.scientificName,
  'category': _$CategoryEnumMap[instance.category]!,
  'primaryPhotoUrl': instance.primaryPhotoUrl,
  'healthStatus': _$HealthStatusEnumMap[instance.healthStatus]!,
  'lightingChange': instance.lightingChange,
  'needsWater': instance.needsWater,
  'repotting': instance.repotting,
  'moisture': instance.moisture.toJson(),
  'illumination': instance.illumination.toJson(),
  'lastWateredAt': instance.lastWateredAt?.toIso8601String(),
  'wateringIntervalDays': instance.wateringIntervalDays,
  'nextWateringAt': instance.nextWateringAt?.toIso8601String(),
  'searchKeywords': instance.searchKeywords,
  'notes': instance.notes,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$CategoryEnumMap = {
  Category.succulents: 'succulents',
  Category.cactus: 'cactus',
  Category.lithops: 'lithops',
};

const _$HealthStatusEnumMap = {
  HealthStatus.healthy: 'healthy',
  HealthStatus.sick: 'sick',
  HealthStatus.recovering: 'recovering',
  HealthStatus.dormant: 'dormant',
};
