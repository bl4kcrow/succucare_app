import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/routes.dart';
import '../../../core/theme/insets.dart';
import '../../auth/providers/auth.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authentication = ref.watch(authProvider);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Home Screen'),
          Text('User: ${authentication.user.name}'),
          const SizedBox(height: Insets.medium),
          ElevatedButton(
            onPressed: () async {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Logging out...')));

              await ref.read(authProvider.notifier).signOut();
              if (context.mounted) {
                context.goNamed(Routes.login.name);
              }
            },
            child: const Text('Logout'),
          ),
          const SizedBox(height: Insets.medium),
          ElevatedButton(
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Deleting account...')),
              );

              await ref.read(authProvider.notifier).deleteAccount();
            },
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}
