import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:succucare_app/core/theme/app_colors.dart';
import 'package:succucare_app/features/garden/models/models.dart';
import 'package:succucare_app/features/garden/providers/providers.dart';
import 'package:succucare_app/features/garden/widgets/widgets.dart';

class EditPlantScreen extends ConsumerStatefulWidget {
  const EditPlantScreen({super.key, required this.plant});

  final Plant plant;

  @override
  ConsumerState<EditPlantScreen> createState() => _EditPlantScreenState();
}

class _EditPlantScreenState extends ConsumerState<EditPlantScreen> {
  late final TextEditingController _scientificNameController;
  late final TextEditingController _commonNameController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _scientificNameController = TextEditingController(
      text: widget.plant.scientificName,
    );
    _commonNameController = TextEditingController(
      text: widget.plant.commonName,
    );
    _notesController = TextEditingController(text: widget.plant.notes);

    _scientificNameController.addListener(() {
      ref
          .read(editPlantProvider(widget.plant).notifier)
          .setScientificName(_scientificNameController.text);
    });
    _commonNameController.addListener(() {
      ref
          .read(editPlantProvider(widget.plant).notifier)
          .setCommonName(_commonNameController.text);
    });
    _notesController.addListener(() {
      ref
          .read(editPlantProvider(widget.plant).notifier)
          .setNotes(_notesController.text);
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
    final notifier = ref.read(editPlantProvider(widget.plant).notifier);
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
    final editPlant = ref.watch(editPlantProvider(widget.plant));
    final errorMessage = editPlant.errorMessage;

    if (errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showError(errorMessage);
        ref.read(editPlantProvider(widget.plant).notifier).clearError();
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
              'Editar Planta',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 18,
              ),
            ),
            Text(
              'Modificar en Mi Jardín',
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
              _scientificNameController.text = widget.plant.scientificName;
              _commonNameController.text = widget.plant.commonName;
              _notesController.text = widget.plant.notes;
              ref.read(editPlantProvider(widget.plant).notifier).reset();
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
                selectedImages: editPlant.selectedImages,
                existingPhotoUrl: editPlant.plant.primaryPhotoUrl,
                onImageAdded: ref
                    .read(editPlantProvider(widget.plant).notifier)
                    .addImage,
                onImageRemoved: ref
                    .read(editPlantProvider(widget.plant).notifier)
                    .removeImage,
              ),
              const SizedBox(height: 24),
              IdentificationCard(
                scientificNameController: _scientificNameController,
                commonNameController: _commonNameController,
                selectedCategory: editPlant.plant.category,
                onCategorySelected: (category) {
                  ref
                      .read(editPlantProvider(widget.plant).notifier)
                      .toggleCategory(category);
                },
              ),
              const SizedBox(height: 16),
              MoistureWateringCard(
                selectedLevel: editPlant.plant.moisture.level,
                onLevelChanged: (level) {
                  ref
                      .read(editPlantProvider(widget.plant).notifier)
                      .setMoistureLevel(level);
                },
                selectedSource: editPlant.plant.moisture.source,
                onSourceChanged: (source) {
                  ref
                      .read(editPlantProvider(widget.plant).notifier)
                      .setMoistureSource(source);
                },
                lastWateredAt: editPlant.plant.lastWateredAt,
                onLastWateredChanged: (date) {
                  ref
                      .read(editPlantProvider(widget.plant).notifier)
                      .setLastWateredAt(date);
                },
                wateringIntervalDays: editPlant.plant.wateringIntervalDays,
                onIntervalChanged: (days) {
                  ref
                      .read(editPlantProvider(widget.plant).notifier)
                      .setWateringIntervalDays(days);
                },
              ),
              const SizedBox(height: 16),
              HealthStatusCard(
                selectedStatus: editPlant.plant.healthStatus,
                onStatusChanged: (status) {
                  ref
                      .read(editPlantProvider(widget.plant).notifier)
                      .toggleHealthStatus(status);
                },
                needsWater: editPlant.plant.needsWater,
                onNeedsWaterChanged: (_) {
                  ref
                      .read(editPlantProvider(widget.plant).notifier)
                      .toggleNeedsWater();
                },
                lightingChange: editPlant.plant.lightingChange,
                onLightingChanged: (_) {
                  ref
                      .read(editPlantProvider(widget.plant).notifier)
                      .toggleLightingChange();
                },
                repotting: editPlant.plant.repotting,
                onRepottingChanged: (_) {
                  ref
                      .read(editPlantProvider(widget.plant).notifier)
                      .toggleRepotting();
                },
              ),
              const SizedBox(height: 16),
              IlluminationCard(
                currentLightSelected: editPlant.plant.illumination.current,
                onCurrentLightChanged: (LightLevel value) {
                  ref
                      .read(editPlantProvider(widget.plant).notifier)
                      .setCurrentIllumination(value);
                },
                targetLightSelected: editPlant.plant.illumination.target,
                onTargetLightChanged: (LightLevel value) {
                  ref
                      .read(editPlantProvider(widget.plant).notifier)
                      .setTargetIllumination(value);
                },
              ),
              const SizedBox(height: 16),
              NotesCard(notesController: _notesController),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _SaveButton(plant: widget.plant, onSave: _save),
    );
  }
}

class _SaveButton extends ConsumerWidget {
  const _SaveButton({required this.plant, required this.onSave});

  final Plant plant;
  final Function() onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final editPlant = ref.watch(editPlantProvider(plant));

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
            onPressed: editPlant.isSubmitting ? null : onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: editPlant.isSubmitting
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
                        'Guardar Cambios',
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
