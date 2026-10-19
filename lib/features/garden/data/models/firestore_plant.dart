
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:succucare_app/core/utils/utils.dart';

part 'firestore_plant.freezed.dart';
part 'firestore_plant.g.dart';

@freezed
abstract class FirestoreMoisture with _$FirestoreMoisture {
  const factory FirestoreMoisture({
    required String level,
    required String source,
    @TimestampConverter() required DateTime updatedAt,
  }) = _FirestoreMoisture;

  factory FirestoreMoisture.fromJson(Map<String, Object?> json) =>
      _$FirestoreMoistureFromJson(json);
}

@freezed
abstract class FirestoreIllumination with _$FirestoreIllumination {
  const factory FirestoreIllumination({
    required String current,
    required String target,
    @TimestampConverter() required DateTime updatedAt,
  }) = _FirestoreIllumination;

  factory FirestoreIllumination.fromJson(Map<String, Object?> json) =>
      _$FirestoreIlluminationFromJson(json);
}

@freezed
abstract class FirestorePlant with _$FirestorePlant {
  @JsonSerializable(explicitToJson: true)
  const factory FirestorePlant({
    required String id,
    required String commonName,
    required String scientificName,
    required String category,
    required String primaryPhotoUrl,
    required String healthStatus,
    required bool lightingChange,
    required bool needsWater,
    required bool repotting,
    required FirestoreMoisture moisture,
    required FirestoreIllumination illumination,
    @TimestampConverter() DateTime? lastWateredAt,
    required int wateringIntervalDays,
    @TimestampConverter() DateTime? nextWateringAt,
    required List<String> searchKeywords,
    required String notes,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _FirestorePlant;

  factory FirestorePlant.fromJson(Map<String, Object?> json) => _$FirestorePlantFromJson(json);

  factory FirestorePlant.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return FirestorePlant.fromJson(data);
  }
}