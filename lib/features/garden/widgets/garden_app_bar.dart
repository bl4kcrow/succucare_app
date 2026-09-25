import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class GardenAppBar extends StatelessWidget implements PreferredSizeWidget {
  GardenAppBar({super.key, required this.onSettingsPressed})
    : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  final VoidCallback onSettingsPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      title: Text(
        'SuccuCare',
        style: textTheme.headlineLarge?.copyWith(color: colorScheme.primary),
      ),
      actions: [
        IconButton(
          onPressed: onSettingsPressed,
          icon: Icon(Symbols.settings),
        ),
      ],
    );
  }
}
