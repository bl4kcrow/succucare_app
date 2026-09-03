import 'package:flutter/material.dart';

import '../models/models.dart';

extension PlantCareMetricLabel on PlantCareMetric {
  String get label => switch (this) {
    PlantCareMetric.moisture => 'Moisture',
    PlantCareMetric.lightExposure => 'Light Exposure',
  };
}

class CareProgressBar extends StatelessWidget {
  const CareProgressBar({
    super.key,
    required this.metric,
    required this.level,
  });

  final PlantCareMetric metric;
  final double level;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final (fillColor, valueLabel) = switch (level) {
      >= 0.6 => (colorScheme.primaryContainer, 'Optimal'),
      >= 0.34 => (colorScheme.primaryContainer, 'Medium'),
      _ => (
        metric == PlantCareMetric.moisture
            ? colorScheme.error
            : colorScheme.tertiary,
        'Low',
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              metric.label,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.outline,
              ),
            ),
            Text(
              valueLabel,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: level.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: colorScheme.surfaceContainer,
            color: fillColor,
          ),
        ),
      ],
    );
  }
}