import 'package:flutter/material.dart';

import 'package:succucare_app/core/theme/app_colors.dart';
import 'package:succucare_app/features/garden/models/models.dart';

class IlluminationCard extends StatelessWidget {
  const IlluminationCard({
    super.key,
    this.currentLightSelected = LightLevel.fullSun,
    required this.onCurrentLightChanged,
    this.targetLightSelected = LightLevel.fullSun,
    required this.onTargetLightChanged,
  });

  final LightLevel currentLightSelected;
  final ValueChanged<LightLevel> onCurrentLightChanged;
  final LightLevel targetLightSelected;
  final ValueChanged<LightLevel> onTargetLightChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.light_mode, size: 16, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                'ILUMINACION',
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.08,
                  color: AppColors.rocketMetallic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Luz Objetivo (Target)',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                'Recomendada',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3.6,
            children: LightLevel.values
                .map(
                  (option) => _LightOption(
                    label: option.label,
                    selected: targetLightSelected == option,
                    primaryColor: colorScheme.primary,
                    onTap: () => onTargetLightChanged(option),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Luz Actual',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                'Ubicación Actual',
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.rocketMetallic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3.6,
            children: LightLevel.values
                .map(
                  (option) => _LightOption(
                    label: option.label,
                    selected: currentLightSelected == option,
                    primaryColor: AppColors.rocketMetallic,
                    onTap: () => onCurrentLightChanged(option),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _LightOption extends StatelessWidget {
  const _LightOption({
    required this.label,
    required this.selected,
    required this.primaryColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color primaryColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? primaryColor.withValues(alpha: 0.1)
              : const Color(0xFFF8F9FB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? primaryColor : colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selected) ...[
              Icon(
                Icons.done,
                size: 14,
                color: selected ? primaryColor : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 2),
            ],
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: selected ? primaryColor : colorScheme.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
