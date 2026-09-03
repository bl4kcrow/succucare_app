import 'package:flutter/material.dart';

import '../models/models.dart';

extension PlantCategoryFilterLabel on PlantCategoryFilter {
  String get label => switch (this) {
    PlantCategoryFilter.all => 'Todas',
    PlantCategoryFilter.succulents => 'Suculentas',
    PlantCategoryFilter.cactus => 'Cactus',
    PlantCategoryFilter.indoor => 'Interior',
    PlantCategoryFilter.outdoor => 'Exterior',
  };
}

class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final PlantCategoryFilter selected;
  final ValueChanged<PlantCategoryFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: PlantCategoryFilter.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = PlantCategoryFilter.values[index];
          return _CategoryChip(
            label: filter.label,
            isSelected: filter == selected,
            onTap: () => onSelected(filter),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: isSelected
          ? colorScheme.primary
          : colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: isSelected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}