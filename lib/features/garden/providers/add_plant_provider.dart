import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:succucare_app/core/errors/errors.dart';
import 'package:succucare_app/features/garden/models/models.dart';
import 'package:succucare_app/features/garden/providers/providers.dart';
import 'package:succucare_app/features/garden/services/services.dart';

part 'add_plant_provider.g.dart';

/// The largest photo that will be submitted for identification.
///
/// Inline file data is base64 in transit, which inflates the request by roughly
/// a third, so the guard sits below what the transport would otherwise accept.
const int maxIdentificationPhotoBytes = 5 * 1024 * 1024;

enum IdentificationStatus { idle, inProgress, completed }

class NewPlantState {
  NewPlantState({
    this.plant = const Plant(
      id: '',
      commonName: '',
      scientificName: '',
      category: Category.succulents,
      primaryPhotoUrl: '',
      healthStatus: HealthStatus.healthy,
      lightingChange: false,
      needsWater: false,
      repotting: false,
      moisture: Moisture(
        level: MoistureLevel.medium,
        source: MoistureSource.manual,
      ),
      illumination: Illumination(
        current: LightLevel.fullSun,
        target: LightLevel.fullSun,
      ),
      wateringIntervalDays: 14,
      searchKeywords: [],
      notes: '',
    ),
    this.selectedImages = const [],
    this.isSubmitting = false,
    this.identificationStatus = IdentificationStatus.idle,
    this.errorMessage,
  });

  final Plant plant;
  final List<File> selectedImages;
  final bool isSubmitting;
  final IdentificationStatus identificationStatus;
  final AppFailure? errorMessage;

  bool get isIdentifying => identificationStatus == IdentificationStatus.inProgress;

  NewPlantState copyWith({
    Plant? plant,
    List<File>? selectedImages,
    bool? isSubmitting,
    IdentificationStatus? identificationStatus,
    AppFailure? errorMessage,
    bool clearError = false,
  }) {
    return NewPlantState(
      plant: plant ?? this.plant,
      selectedImages: selectedImages ?? this.selectedImages,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      identificationStatus: identificationStatus ?? this.identificationStatus,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  NewPlantState clearIdentification() =>
      copyWith(identificationStatus: IdentificationStatus.idle);
}

@riverpod
class AddPlantNotifier extends _$AddPlantNotifier {
  @override
  NewPlantState build() => NewPlantState();

  void setScientificName(String value) {
    final Plant plantState = state.plant.copyWith(scientificName: value);
    state = state.copyWith(plant: plantState);
  }

  void setCommonName(String value) {
    final Plant plantState = state.plant.copyWith(commonName: value);
    state = state.copyWith(plant: plantState);
  }

  void toggleCategory(Category value) {
    if (state.plant.category != value) {
      final Plant plantState = state.plant.copyWith(category: value);
      state = state.copyWith(plant: plantState);
    }
  }

  void setMoistureLevel(MoistureLevel value) {
    final Plant plantState = state.plant.copyWith(
      moisture: state.plant.moisture.copyWith(level: value),
    );

    state = state.copyWith(plant: plantState);
  }

  void setMoistureSource(MoistureSource value) {
    final Plant plantState = state.plant.copyWith(
      moisture: state.plant.moisture.copyWith(source: value),
    );

    state = state.copyWith(plant: plantState);
  }

  void setCurrentIllumination(LightLevel value) {
    final Plant plantState = state.plant.copyWith(
      illumination: state.plant.illumination.copyWith(current: value),
      lightingChange: value != state.plant.illumination.target,
    );

    state = state.copyWith(plant: plantState);
  }

  void setTargetIllumination(LightLevel value) {
    final Plant plantState = state.plant.copyWith(
      illumination: state.plant.illumination.copyWith(target: value),
      lightingChange: value != state.plant.illumination.current,
    );

    state = state.copyWith(plant: plantState);
  }

  void toggleHealthStatus(HealthStatus value) {
    if (state.plant.healthStatus != value) {
      final Plant plantState = state.plant.copyWith(healthStatus: value);
      state = state.copyWith(plant: plantState);
    }
  }

  void toggleNeedsWater() {
    final Plant plantState = state.plant.copyWith(
      needsWater: !state.plant.needsWater,
    );

    state = state.copyWith(plant: plantState);
  }

  void toggleLightingChange() {
    final Plant plantState = state.plant.copyWith(
      lightingChange: !state.plant.lightingChange,
    );

    state = state.copyWith(plant: plantState);
  }

  void toggleRepotting() {
    final Plant plantState = state.plant.copyWith(
      repotting: !state.plant.repotting,
    );

    state = state.copyWith(plant: plantState);
  }

  void setLastWateredAt(DateTime? value) {
    final Plant plantState = state.plant.copyWith(lastWateredAt: value);
    state = state.copyWith(plant: plantState);
  }

  void setWateringIntervalDays(int value) {
    final Plant plantState = state.plant.copyWith(wateringIntervalDays: value);
    state = state.copyWith(plant: plantState);
  }

  void setNotes(String value) {
    final Plant plantState = state.plant.copyWith(notes: value);
    state = state.copyWith(plant: plantState);
  }

  void addImage(File image) =>
      state = state.copyWith(selectedImages: [...state.selectedImages, image]);

  void removeImage(int index) {
    final newList = [...state.selectedImages];
    newList.removeAt(index);
    state = state.copyWith(selectedImages: newList);
  }

  void clearIdentification() => state = state.clearIdentification();

  void reset() => state = NewPlantState();

  void clearError() => state = state.copyWith(clearError: true);

  /// Submits the attached photo for identification and, when the answer is
  /// usable, writes the proposed values through the setters above so the
  /// derivation `submitPlant` performs stays in one place.
  Future<bool> identify() async {
    if (state.selectedImages.isEmpty) return false;

    // The button is disabled while a request is in flight, but the notifier is
    // the thing that has to refuse a second one.
    if (state.isIdentifying) return false;

    final image = state.selectedImages.first;

    if (await image.length() > maxIdentificationPhotoBytes) {
      state = state.copyWith(
        errorMessage: AppFailure(AppFailureCode.plantIdentificationPhotoTooLarge),
      );
      return false;
    }

    state = state.copyWith(
      identificationStatus: IdentificationStatus.inProgress,
      clearError: true,
    );

    try {
      final identification = await ref
          .read(plantIdentificationServiceProvider)
          .identify(
            PlantPhotoInput(
              bytes: await image.readAsBytes(),
              mimeType: resolveMimeTypeFromPath(image.path),
            ),
          );

      if (_usableValues(identification).isEmpty) {
        state = state.copyWith(
          identificationStatus: IdentificationStatus.idle,
          errorMessage: AppFailure(AppFailureCode.plantIdentificationNoResult),
        );
        return false;
      }

      applyIdentification(identification);
      return true;
    } catch (error) {
      debugPrint('Plant identification failed: $error');
      state = state.copyWith(
        identificationStatus: IdentificationStatus.idle,
        errorMessage: AppFailure.from(error),
      );
      return false;
    }
  }

  /// Writes each non-null proposed value through the existing setter, so a
  /// proposal cannot produce a plant whose derived fields disagree with it.
  void applyIdentification(PlantIdentification identification) {
    final commonName = identification.commonName;
    if (commonName != null) setCommonName(commonName);

    final scientificName = identification.scientificName;
    if (scientificName != null) setScientificName(scientificName);

    final category = identification.category == null
        ? null
        : mapStringToCategory(identification.category);
    if (category != null) toggleCategory(category);

    final interval = identification.wateringIntervalDays;
    if (interval != null) setWateringIntervalDays(interval);

    final lightLevel = identification.lightLevel == null
        ? null
        : mapStringToLightLevel(identification.lightLevel);
    if (lightLevel != null) {
      setCurrentIllumination(lightLevel);
      setTargetIllumination(lightLevel);
    }

    state = state.copyWith(
      identificationStatus: IdentificationStatus.completed,
    );
  }

  /// The proposed values the form can actually store. A source that answered
  /// with nothing usable is reported rather than applied as an empty proposal.
  List<Object?> _usableValues(PlantIdentification identification) => [
    identification.commonName,
    identification.scientificName,
    identification.category,
    identification.wateringIntervalDays,
    identification.lightLevel,
  ].where((value) => value != null).toList();

  bool validate() {
    if (state.plant.scientificName.trim().isEmpty) return false;
    if (state.plant.commonName.trim().isEmpty) return false;
    if (state.plant.lastWateredAt == null) return false;
    if (state.plant.notes.isEmpty) return false;
    return true;
  }

  Future<bool> submitPlant() async {
    if (!validate()) {
      state = state.copyWith(
        errorMessage: AppFailure(AppFailureCode.validation),
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final dateTimeNow = DateTime.now();
      final nextWateringAt = state.plant.lastWateredAt?.add(
        Duration(days: state.plant.wateringIntervalDays),
      );

      String primaryPhotoUrl = '';

      final plant = state.plant.copyWith(
        moisture: state.plant.moisture.copyWith(updatedAt: dateTimeNow),
        illumination: state.plant.illumination.copyWith(updatedAt: dateTimeNow),
        lightingChange:
            state.plant.illumination.current != state.plant.illumination.target,
        nextWateringAt: nextWateringAt,
        searchKeywords: _buildSearchKeywords(
          state.plant.scientificName.trim(),
          state.plant.commonName.trim(),
          state.plant.category,
        ),
        createdAt: dateTimeNow,
        updatedAt: dateTimeNow,
      );

      final newPlantId = await ref
          .read(gardenRepositoryImplProvider)
          .createPlant(plant);

      if (newPlantId.isNotEmpty && state.selectedImages.isNotEmpty) {
        primaryPhotoUrl = await ref
            .read(photosRepositoryImplProvider)
            .uploadPlantPhoto(newPlantId, state.selectedImages.first);

        if (primaryPhotoUrl.isNotEmpty) {
          await ref
              .read(gardenRepositoryImplProvider)
              .updatePlantPhotoUrl(primaryPhotoUrl, newPlantId);
        }
      }

      if (newPlantId.isNotEmpty) {
        ref.invalidate(myGardenProvider);
      }

      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: AppFailure.from(error),
      );
      return false;
    }
  }

  List<String> _buildSearchKeywords(
    String scientificName,
    String commonName,
    Category category,
  ) {
    final keywords = <String>[
      ...scientificName.toLowerCase().split(' '),
      ...commonName.toLowerCase().split(' '),
      category.name,
    ];
    return keywords.where((k) => k.isNotEmpty).toSet().toList();
  }
}
