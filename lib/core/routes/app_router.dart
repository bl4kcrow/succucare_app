import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/providers/auth.dart';
import '../../features/auth/providers/authentication_state.dart';
import '../../features/auth/views/create_account_screen.dart';
import '../../features/auth/views/splash_screen.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/succus/views/home_screen.dart';
import 'routes.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authenticationState = ValueNotifier<AuthenticationState>(
    AuthenticationState.unknown,
  );

  ref.watch(authProvider.notifier).authStateChanges().listen((state) {
    authenticationState.value = state;
  });

  ref.onDispose(authenticationState.dispose);

  final router = GoRouter(
    initialLocation: Routes.splash.value,
    refreshListenable: authenticationState,
    redirect: (context, state) {
      if (state.fullPath == Routes.splash.value) {
        return authenticationState.value == AuthenticationState.authenticated
            ? Routes.home.value
            : Routes.login.value;
      }

      if (state.fullPath == Routes.login.value ||
          state.fullPath == Routes.createAccount.value) {
        return authenticationState.value == AuthenticationState.authenticated
            ? Routes.home.value
            : null;
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        name: Routes.splash.name,
        path: Routes.splash.value,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        name: Routes.home.name,
        path: Routes.home.value,
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        name: Routes.login.name,
        path: Routes.login.value,
        builder: (context, state) {
          return const LoginScreen();
        },
        routes: [
          GoRoute(
            name: Routes.createAccount.name,
            path: Routes.createAccount.value,
            builder: (context, state) {
              return const CreateAccountScreen();
            },
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
}
