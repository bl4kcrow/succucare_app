import 'package:flutter/material.dart';

import '../models/models.dart';

extension PlantHealthStatusLabel on PlantHealthStatus {
  String get label => switch (this) {
    PlantHealthStatus.needsWater => 'Needs Water',
    PlantHealthStatus.thriving => 'Thriving',
    PlantHealthStatus.needsLight => 'Needs Light',
  };
}

class PlantStatusBadge extends StatelessWidget {
  const PlantStatusBadge({super.key, required this.status});

  final PlantHealthStatus status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final (background, foreground, icon) = switch (status) {
      PlantHealthStatus.needsWater => (
        colorScheme.errorContainer,
        colorScheme.onErrorContainer,
        Icons.water_drop,
      ),
      PlantHealthStatus.thriving => (
        colorScheme.secondaryContainer,
        colorScheme.onSecondaryContainer,
        Icons.check_circle,
      ),
      PlantHealthStatus.needsLight => (
        colorScheme.tertiaryContainer,
        colorScheme.onTertiaryContainer,
        Icons.wb_sunny,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: textTheme.labelSmall?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}