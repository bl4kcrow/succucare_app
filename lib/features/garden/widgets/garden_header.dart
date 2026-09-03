import 'package:flutter/material.dart';

class GardenHeader extends StatelessWidget {
  const GardenHeader({super.key, required this.plantCount});

  final int plantCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'My Garden',
          style: textTheme.headlineLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          '$plantCount ${plantCount == 1 ? 'Plant' : 'Plants'}',
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.outline,
          ),
        ),
      ],
    );
  }
}