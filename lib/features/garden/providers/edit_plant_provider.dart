import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:succucare_app/features/garden/models/models.dart';
import 'package:succucare_app/features/garden/providers/providers.dart';

part 'edit_plant_provider.g.dart';

class EditPlantState {
  EditPlantState({
    required this.plant,
    this.selectedImages = const [],
    this.isSubmitting = false,
    this.errorMessage,
  });

  final Plant plant;
  final List<File> selectedImages;
  final bool isSubmitting;
  final String? errorMessage;

  EditPlantState copyWith({
    Plant? plant,
    List<File>? selectedImages,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EditPlantState(
      plant: plant ?? this.plant,
      selectedImages: selectedImages ?? this.selectedImages,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

@riverpod
class EditPlantNotifier extends _$EditPlantNotifier {
  Plant? _originalPlant;

  @override
  EditPlantState build(Plant plant) {
    _originalPlant = plant;
    return EditPlantState(plant: plant);
  }

  void setScientificName(String value) {
    final plantState = state.plant.copyWith(scientificName: value);
    state = state.copyWith(plant: plantState);
  }

  void setCommonName(String value) {
    final plantState = state.plant.copyWith(commonName: value);
    state = state.copyWith(plant: plantState);
  }

  void toggleCategory(Category value) {
    if (state.plant.category != value) {
      final plantState = state.plant.copyWith(category: value);
      state = state.copyWith(plant: plantState);
    }
  }

  void setMoistureLevel(MoistureLevel value) {
    final plantState = state.plant.copyWith(
      moisture: state.plant.moisture.copyWith(level: value),
    );

    state = state.copyWith(plant: plantState);
  }

  void setMoistureSource(MoistureSource value) {
    final plantState = state.plant.copyWith(
      moisture: state.plant.moisture.copyWith(source: value),
    );

    state = state.copyWith(plant: plantState);
  }

  void setCurrentIllumination(LightLevel value) {
    final plantState = state.plant.copyWith(
      illumination: state.plant.illumination.copyWith(current: value),
      lightingChange: value != state.plant.illumination.target,
    );

    state = state.copyWith(plant: plantState);
  }

  void setTargetIllumination(LightLevel value) {
    final plantState = state.plant.copyWith(
      illumination: state.plant.illumination.copyWith(target: value),
      lightingChange: value != state.plant.illumination.current,
    );

    state = state.copyWith(plant: plantState);
  }

  void toggleHealthStatus(HealthStatus value) {
    if (state.plant.healthStatus != value) {
      final plantState = state.plant.copyWith(healthStatus: value);
      state = state.copyWith(plant: plantState);
    }
  }

  void toggleNeedsWater() {
    final plantState = state.plant.copyWith(
      needsWater: !state.plant.needsWater,
    );

    state = state.copyWith(plant: plantState);
  }

  void toggleLightingChange() {
    final plantState = state.plant.copyWith(
      lightingChange: !state.plant.lightingChange,
    );

    state = state.copyWith(plant: plantState);
  }

  void toggleRepotting() {
    final plantState = state.plant.copyWith(repotting: !state.plant.repotting);

    state = state.copyWith(plant: plantState);
  }

  void setLastWateredAt(DateTime? value) {
    final plantState = state.plant.copyWith(lastWateredAt: value);
    state = state.copyWith(plant: plantState);
  }

  void setWateringIntervalDays(int value) {
    final plantState = state.plant.copyWith(wateringIntervalDays: value);
    state = state.copyWith(plant: plantState);
  }

  void setNotes(String value) {
    final plantState = state.plant.copyWith(notes: value);
    state = state.copyWith(plant: plantState);
  }

  void addImage(File image) => state = state.copyWith(selectedImages: [image]);

  void removeImage(int index) {
    final newList = [...state.selectedImages];
    newList.removeAt(index);
    state = state.copyWith(selectedImages: newList);
  }

  void reset() {
    if (_originalPlant == null) return;
    state = EditPlantState(plant: _originalPlant!);
  }

  void clearError() => state = state.copyWith(clearError: true);

  bool validate() {
    if (state.plant.scientificName.trim().isEmpty) return false;
    if (state.plant.commonName.trim().isEmpty) return false;
    if (state.plant.lastWateredAt == null) return false;
    if (state.plant.notes.isEmpty) return false;
    return true;
  }

  Future<bool> submitPlant() async {
    if (!validate()) {
      state = state.copyWith(errorMessage: 'Please fill all the fields');
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final dateTimeNow = DateTime.now();
      final nextWateringAt = state.plant.lastWateredAt?.add(
        Duration(days: state.plant.wateringIntervalDays),
      );

      var plant = state.plant.copyWith(
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
        updatedAt: dateTimeNow,
      );

      if (state.selectedImages.isNotEmpty) {
        final newPhotoUrl = await ref
            .read(photosRepositoryImplProvider)
            .uploadPlantPhoto(plant.id, state.selectedImages.first);

        if (newPhotoUrl.isNotEmpty) {
          final oldPhotoUrl = plant.primaryPhotoUrl;
          if (oldPhotoUrl.isNotEmpty) {
            await ref
                .read(photosRepositoryImplProvider)
                .deletePlantPhoto(oldPhotoUrl);
          }
          plant = plant.copyWith(primaryPhotoUrl: newPhotoUrl);
        }
      }

      await ref.read(gardenRepositoryImplProvider).updatePlant(plant);

      ref.invalidate(myGardenProvider);

      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.toString(),
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
