import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:succucare_app/core/theme/app_colors.dart';
import 'package:succucare_app/features/garden/models/models.dart';
import 'package:succucare_app/features/garden/providers/providers.dart';
import 'package:succucare_app/features/garden/widgets/widgets.dart';

class AddPlantScreen extends ConsumerStatefulWidget {
  const AddPlantScreen({super.key});

  @override
  ConsumerState<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends ConsumerState<AddPlantScreen> {
  final _scientificNameController = TextEditingController();
  final _commonNameController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scientificNameController.addListener(() {
      ref
          .read(addPlantProvider.notifier)
          .setScientificName(_scientificNameController.text);
    });
    _commonNameController.addListener(() {
      ref
          .read(addPlantProvider.notifier)
          .setCommonName(_commonNameController.text);
    });
    _notesController.addListener(() {
      ref.read(addPlantProvider.notifier).setNotes(_notesController.text);
    });
  }

  @override
  void dispose() {
    _scientificNameController.dispose();
    _commonNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final notifier = ref.read(addPlantProvider.notifier);
    final success = await notifier.submitPlant();
    if (!mounted) return;

    if (success) {
      context.pop();
    }
  }

  void _showError(String? message) {
    if (message == null || message.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.frenchRaspberry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final addPlant = ref.watch(addPlantProvider);
    final errorMessage = addPlant.errorMessage;

    if (errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showError(errorMessage);
        ref.read(addPlantProvider.notifier).clearError();
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: colorScheme.onSurface,
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            Text(
              'Nueva Planta',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 18,
              ),
            ),
            Text(
              'Registrar en Mi Jardín',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              _scientificNameController.clear();
              _commonNameController.clear();
              _notesController.clear();
              ref.read(addPlantProvider.notifier).reset();
            },
            child: Text(
              'Limpiar',
              style: textTheme.labelLarge?.copyWith(
                color: AppColors.mysticMaroon,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PhotoUploadGrid(
                selectedImages: addPlant.selectedImages,
                onImageAdded: ref.read(addPlantProvider.notifier).addImage,
                onImageRemoved: ref.read(addPlantProvider.notifier).removeImage,
              ),
              const SizedBox(height: 24),
              IdentificationCard(
                scientificNameController: _scientificNameController,
                commonNameController: _commonNameController,
                selectedCategory: addPlant.plant.category,
                onCategorySelected: (category) {
                  ref.read(addPlantProvider.notifier).toggleCategory(category);
                },
              ),
              const SizedBox(height: 16),
              MoistureWateringCard(
                selectedLevel: addPlant.plant.moisture.level,
                onLevelChanged: (level) {
                  ref.read(addPlantProvider.notifier).setMoistureLevel(level);
                },
                selectedSource: addPlant.plant.moisture.source,
                onSourceChanged: (source) {
                  ref.read(addPlantProvider.notifier).setMoistureSource(source);
                },
                lastWateredAt: addPlant.plant.lastWateredAt,
                onLastWateredChanged: (date) {
                  ref.read(addPlantProvider.notifier).setLastWateredAt(date);
                },
                wateringIntervalDays: addPlant.plant.wateringIntervalDays,
                onIntervalChanged: (days) {
                  ref
                      .read(addPlantProvider.notifier)
                      .setWateringIntervalDays(days);
                },
              ),
              const SizedBox(height: 16),
              HealthStatusCard(
                selectedStatus: addPlant.plant.healthStatus,
                onStatusChanged: (status) {
                  ref
                      .read(addPlantProvider.notifier)
                      .toggleHealthStatus(status);
                },
                needsWater: addPlant.plant.needsWater,
                onNeedsWaterChanged: (_) {
                  ref.read(addPlantProvider.notifier).toggleNeedsWater();
                },
                lightingChange: addPlant.plant.lightingChange,
                onLightingChanged: (_) {
                  ref.read(addPlantProvider.notifier).toggleLightingChange();
                },
                repotting: addPlant.plant.repotting,
                onRepottingChanged: (_) {
                  ref.read(addPlantProvider.notifier).toggleRepotting();
                },
              ),
              const SizedBox(height: 16),
              IlluminationCard(
                currentLightSelected: addPlant.plant.illumination.current,
                onCurrentLightChanged: (LightLevel value) {
                  ref
                      .read(addPlantProvider.notifier)
                      .setCurrentIllumination(value);
                },
                targetLightSelected: addPlant.plant.illumination.target,
                onTargetLightChanged: (LightLevel value) {
                  ref
                      .read(addPlantProvider.notifier)
                      .setTargetIllumination(value);
                },
              ),
              const SizedBox(height: 16),
              NotesCard(notesController: _notesController),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _SaveButton(onSave: _save),
    );
  }
}

class _SaveButton extends ConsumerWidget {
  const _SaveButton({required this.onSave});

  final Function() onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final addPlant = ref.watch(addPlantProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.7),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: addPlant.isSubmitting ? null : onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: addPlant.isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 20, color: Colors.white),
                      const SizedBox(width: 8),
                      const Text(
                        'Guardar Planta',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
