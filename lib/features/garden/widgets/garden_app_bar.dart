import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class GardenAppBar extends StatelessWidget implements PreferredSizeWidget {
  GardenAppBar({super.key}) : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      title: Text(
        'SuccuCare',
        style: textTheme.headlineLarge?.copyWith(color: colorScheme.primary),
      ),
      actions: [IconButton(onPressed: () {}, icon: Icon(Symbols.settings))],
    );
  }
}
