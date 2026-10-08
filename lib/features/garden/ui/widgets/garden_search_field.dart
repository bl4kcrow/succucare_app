import 'package:flutter/material.dart';

class GardenSearchField extends StatelessWidget {
  const GardenSearchField({
    super.key,
    required this.onChanged,
    this.focusNode,
  });

  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return TextField(
      focusNode: focusNode,
      onChanged: onChanged,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      textInputAction: TextInputAction.search,
      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: 'Search your garden...',
        hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
        prefixIcon: Icon(Icons.search, color: colorScheme.outline),
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}