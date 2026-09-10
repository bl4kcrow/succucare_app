import 'package:flutter/material.dart';

import 'package:succucare_app/features/garden/models/models.dart';

class MoistureProgressBar extends StatelessWidget {
  const MoistureProgressBar({super.key, required this.moisture});

  final Moisture moisture;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final (fillColor, levelValue) = switch (moisture.level) {
      MoistureLevel.low => (colorScheme.tertiary, 0.3),
      MoistureLevel.medium => (colorScheme.primaryContainer, 0.5),
      MoistureLevel.optimal => (colorScheme.primaryContainer, 1.0),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Moisture',
              style: textTheme.labelSmall?.copyWith(color: colorScheme.outline),
            ),
            Text(
              moisture.level.label,
              style: textTheme.labelSmall?.copyWith(color: colorScheme.outline),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: levelValue,
            minHeight: 6,
            backgroundColor: colorScheme.surfaceContainer,
            color: fillColor,
          ),
        ),
      ],
    );
  }
}
