// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_plant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FirestoreMoisture _$FirestoreMoistureFromJson(Map<String, dynamic> json) =>
    _FirestoreMoisture(
      level: json['level'] as String,
      source: json['source'] as String,
      updatedAt: const TimestampConverter().fromJson(
        json['updatedAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$FirestoreMoistureToJson(_FirestoreMoisture instance) =>
    <String, dynamic>{
      'level': instance.level,
      'source': instance.source,
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

_FirestoreIllumination _$FirestoreIlluminationFromJson(
  Map<String, dynamic> json,
) => _FirestoreIllumination(
  current: json['current'] as String,
  target: json['target'] as String,
  updatedAt: const TimestampConverter().fromJson(
    json['updatedAt'] as Timestamp,
  ),
);

Map<String, dynamic> _$FirestoreIlluminationToJson(
  _FirestoreIllumination instance,
) => <String, dynamic>{
  'current': instance.current,
  'target': instance.target,
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};

_FirestorePlant _$FirestorePlantFromJson(Map<String, dynamic> json) =>
    _FirestorePlant(
      id: json['id'] as String,
      commonName: json['commonName'] as String,
      scientificName: json['scientificName'] as String,
      category: json['category'] as String,
      primaryPhotoUrl: json['primaryPhotoUrl'] as String,
      healthStatus: json['healthStatus'] as String,
      lightingChange: json['lightingChange'] as bool,
      needsWater: json['needsWater'] as bool,
      repotting: json['repotting'] as bool,
      moisture: FirestoreMoisture.fromJson(
        json['moisture'] as Map<String, dynamic>,
      ),
      illumination: FirestoreIllumination.fromJson(
        json['illumination'] as Map<String, dynamic>,
      ),
      lastWateredAt: _$JsonConverterFromJson<Timestamp, DateTime>(
        json['lastWateredAt'],
        const TimestampConverter().fromJson,
      ),
      wateringIntervalDays: (json['wateringIntervalDays'] as num).toInt(),
      nextWateringAt: _$JsonConverterFromJson<Timestamp, DateTime>(
        json['nextWateringAt'],
        const TimestampConverter().fromJson,
      ),
      searchKeywords: (json['searchKeywords'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      notes: json['notes'] as String,
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
      updatedAt: const TimestampConverter().fromJson(
        json['updatedAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$FirestorePlantToJson(_FirestorePlant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'commonName': instance.commonName,
      'scientificName': instance.scientificName,
      'category': instance.category,
      'primaryPhotoUrl': instance.primaryPhotoUrl,
      'healthStatus': instance.healthStatus,
      'lightingChange': instance.lightingChange,
      'needsWater': instance.needsWater,
      'repotting': instance.repotting,
      'moisture': instance.moisture.toJson(),
      'illumination': instance.illumination.toJson(),
      'lastWateredAt': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.lastWateredAt,
        const TimestampConverter().toJson,
      ),
      'wateringIntervalDays': instance.wateringIntervalDays,
      'nextWateringAt': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.nextWateringAt,
        const TimestampConverter().toJson,
      ),
      'searchKeywords': instance.searchKeywords,
      'notes': instance.notes,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
