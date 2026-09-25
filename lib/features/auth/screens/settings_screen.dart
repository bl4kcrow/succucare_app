import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:succucare_app/core/theme/app_colors.dart';
import 'package:succucare_app/core/theme/insets.dart';
import 'package:succucare_app/core/utils/custom_snack_bar_content.dart';
import 'package:succucare_app/features/auth/providers/providers.dart';
import 'package:succucare_app/features/garden/providers/providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isSigningOut = false;

  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);

    try {
      ref.invalidate(myGardenProvider);
      await ref.read(authProvider.notifier).signOut();
    } catch (error) {
      if (!mounted) return;

      setState(() => _isSigningOut = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarContent(message: error.toString()),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          showCloseIcon: true,
          closeIconColor: AppColors.frenchRaspberry,
        ),
      );
    }
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: textTheme.headlineMedium?.copyWith(color: colorScheme.primary),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Insets.medium),
          children: [
            const SizedBox(height: Insets.large),
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: colorScheme.primary,
                child: Text(
                  _initials(user.name),
                  style: textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Insets.medium),
            Text(
              user.name,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: Insets.xsmall),
            Text(
              user.email,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Insets.extraLarge),
            ElevatedButton.icon(
              onPressed: _isSigningOut ? null : _signOut,
              icon: const Icon(Icons.logout),
              label: Text(_isSigningOut ? 'Signing out...' : 'Sign Out'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: Insets.medium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
