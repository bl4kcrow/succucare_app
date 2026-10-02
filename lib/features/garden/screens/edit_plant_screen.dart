import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:succucare_app/core/errors/errors.dart';
import 'package:succucare_app/core/routes/routes.dart';
import 'package:succucare_app/core/theme/app_colors.dart';
import 'package:succucare_app/features/garden/models/models.dart';
import 'package:succucare_app/features/garden/providers/providers.dart';
import 'package:succucare_app/features/garden/widgets/widgets.dart';

class EditPlantScreen extends ConsumerWidget {
  const EditPlantScreen({super.key, required this.plantId});

  final String plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plant = ref.watch(plantByIdProvider(plantId));

    return SafeArea(
      top: false,
      child: plant.when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, _) => _EditPlantLoadFailure(
          error: error,
          onRetry: () => ref.invalidate(plantByIdProvider(plantId)),
        ),
        data: (resolved) =>
            _EditPlantForm(key: ValueKey(plantId), plant: resolved),
      ),
    );
  }
}

class _EditPlantAppBar extends StatelessWidget implements PreferredSizeWidget {
  _EditPlantAppBar(this.customActions)
    : preferredSize = Size.fromHeight(kToolbarHeight);

  final List<Widget>? customActions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF4F6F9),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Theme.of(context).colorScheme.onSurface,
        onPressed: () => context.pop(),
      ),
      title: Column(
        children: [
          Text(
            'Editar Planta',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
            ),
          ),
          Text(
            'Modificar en Mi Jardín',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: customActions,
    );
  }

  @override
  final Size preferredSize;
}

class _EditPlantLoadFailure extends ConsumerWidget {
  const _EditPlantLoadFailure({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  bool get _isNotFound =>
      AppFailure.from(error).code == AppFailureCode.notFound;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: _EditPlantAppBar([]),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: colorScheme.outlineVariant,
              ),
              const SizedBox(height: 16),
              Text(
                AppFailure.from(error).userMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              if (_isNotFound)
                ElevatedButton(
                  onPressed: () => context.go(Routes.home.value),
                  child: const Text('Volver a Mi Jardín'),
                )
              else
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Reintentar'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditPlantForm extends ConsumerStatefulWidget {
  const _EditPlantForm({super.key, required this.plant});

  final Plant plant;

  @override
  ConsumerState<_EditPlantForm> createState() => _EditPlantFormState();
}

class _EditPlantFormState extends ConsumerState<_EditPlantForm> {
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

  void _showError(AppFailure? failure) {
    if (failure == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failure.userMessage),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.frenchRaspberry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final editPlant = ref.watch(editPlantProvider(widget.plant));
    final failure = editPlant.errorMessage;

    if (failure != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showError(failure);
        ref.read(editPlantProvider(widget.plant).notifier).clearError();
      });
    }

    return Scaffold(
      // backgroundColor: const Color(0xFFF4F6F9),
      appBar: _EditPlantAppBar([
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
      ]),
      body: SingleChildScrollView(
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
