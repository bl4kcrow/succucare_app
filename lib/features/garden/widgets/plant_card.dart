import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:succucare_app/features/garden/models/models.dart';
import 'widgets.dart';

class PlantCard extends StatelessWidget {
  const PlantCard({
    super.key,
    required this.plant,
    this.onTap,
    this.onWaterPressed,
  });

  final Plant plant;
  final VoidCallback? onTap;
  final VoidCallback? onWaterPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.surfaceContainerHighest),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A432C).withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 192,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: plant.primaryPhotoUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return _PlantImagePlaceholder();
                      },
                      placeholder: (context, url) {
                        return _PlantImagePlaceholder(isLoading: true);
                      },
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: PlantStatusBadge(status: plant.healthStatus),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plant.commonName,
                                style: textTheme.headlineSmall?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                plant.scientificName,
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.outlineVariant,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (plant.needsWater == true)
                          _WaterButton(onPressed: onWaterPressed),
                      ],
                    ),
                    const SizedBox(height: 16),
                    MoistureProgressBar(moisture: plant.moisture),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WaterButton extends StatelessWidget {
  const _WaterButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainerLow,
        foregroundColor: colorScheme.primary,
      ),
      icon: const Icon(Icons.local_drink),
    );
  }
}

class _PlantImagePlaceholder extends StatelessWidget {
  const _PlantImagePlaceholder({this.isLoading = false});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: 192,
      color: isLoading
          ? colorScheme.surfaceContainerLow
          : colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.local_florist,
          size: 48,
          color: colorScheme.outlineVariant,
        ),
      ),
    );
  }
}
