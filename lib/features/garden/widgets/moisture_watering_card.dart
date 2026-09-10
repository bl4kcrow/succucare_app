import 'package:flutter/material.dart';

import 'package:succucare_app/core/theme/app_colors.dart';
import 'package:succucare_app/features/garden/models/models.dart';

class MoistureWateringCard extends StatelessWidget {
  const MoistureWateringCard({
    super.key,
    required this.selectedLevel,
    required this.onLevelChanged,
    required this.selectedSource,
    required this.onSourceChanged,
    required this.lastWateredAt,
    required this.onLastWateredChanged,
    required this.wateringIntervalDays,
    required this.onIntervalChanged,
  });

  final MoistureLevel? selectedLevel;
  final ValueChanged<MoistureLevel> onLevelChanged;
  final MoistureSource? selectedSource;
  final ValueChanged<MoistureSource> onSourceChanged;
  final DateTime? lastWateredAt;
  final ValueChanged<DateTime?> onLastWateredChanged;
  final int wateringIntervalDays;
  final ValueChanged<int> onIntervalChanged;

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: lastWateredAt ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    onLastWateredChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
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
              Icon(Icons.water_drop, size: 16, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                'HUMEDAD Y RIEGO',
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
                'Nivel de Humedad Actual',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (selectedLevel != null)
                Text(
                  selectedLevel!.label,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.mysticMaroon,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: MoistureLevel.values.map((level) {
              final isSelected = selectedLevel == level;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: GestureDetector(
                    onTap: () => onLevelChanged(level),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.coolGrey.withValues(alpha: 0.12)
                            : const Color(0xFFF8F9FB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outlineVariant,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: colorScheme.primary
                                      .withValues(alpha: 0.15),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isSelected) ...[
                            Icon(
                              Icons.done,
                              size: 14,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 2),
                          ],
                          Text(
                            level.label,
                            style: textTheme.labelMedium?.copyWith(
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Fuente de Datos de Humedad',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: MoistureSource.values.map((source) {
              final isSelected = selectedSource == source;
              final icon = switch (source) {
                MoistureSource.manual => Icons.touch_app,
                MoistureSource.sensor => Icons.sensors,
                MoistureSource.inferred => Icons.psychology,
              };
              final label = switch (source) {
                MoistureSource.manual => 'Manual',
                MoistureSource.sensor => 'Sensor',
                MoistureSource.inferred => 'Inferido (IA)',
              };
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: GestureDetector(
                    onTap: () => onSourceChanged(source),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.rocketMetallic.withValues(alpha: 0.1)
                            : const Color(0xFFF8F9FB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.rocketMetallic
                              : colorScheme.outlineVariant,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            icon,
                            size: 18,
                            color: isSelected
                                ? AppColors.rocketMetallic
                                : colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            label,
                            style: textTheme.labelSmall?.copyWith(
                              fontSize: 11,
                              color: isSelected
                                  ? AppColors.rocketMetallic
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ultimo Riego',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () => _pickDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              lastWateredAt != null
                                  ? '${lastWateredAt!.day}/${lastWateredAt!.month}/${lastWateredAt!.year}'
                                  : 'Fecha',
                              style: textTheme.bodySmall?.copyWith(
                                color: lastWateredAt != null
                                    ? colorScheme.onSurface
                                    : colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Intervalo (Días)',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: wateringIntervalDays.toString(),
                      ),
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF8F9FB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.outlineVariant,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.outlineVariant,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.primary),
                        ),
                        // contentPadding: const EdgeInsets.symmetric(
                        //   horizontal: 12,
                        //   vertical: 4,
                        // ),
                        suffixText: 'días',
                        suffixStyle: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      onChanged: (value) {
                        final parsed = int.tryParse(value);
                        if (parsed != null) onIntervalChanged(parsed);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
