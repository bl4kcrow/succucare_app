import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:succucare_app/features/garden/screens/screens.dart';
import 'package:succucare_app/features/auth/providers/providers.dart';
import 'package:succucare_app/features/auth/screens/screens.dart';
import 'package:succucare_app/features/garden/views/views.dart';
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

  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final shellNavigatorKeyHome = GlobalKey<NavigatorState>(
    debugLabel: 'ShellNavKey Home',
  );
  final shellNavigatorKeyScan = GlobalKey<NavigatorState>(
    debugLabel: 'ShellNavKey Plant Scan',
  );
  final shellNavigatorKeyAlerts = GlobalKey<NavigatorState>(
    debugLabel: 'ShellNavKey Alerts',
  );

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MyGardenScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: shellNavigatorKeyHome,
            routes: [
              GoRoute(
                name: Routes.home.name,
                path: Routes.home.value,
                builder: (context, state) {
                  return const MyGardenHomeView();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorKeyScan,
            routes: [
              GoRoute(
                name: Routes.scanPlant.name,
                path: Routes.scanPlant.value,
                builder: (context, state) {
                  return const PlantScanView();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorKeyAlerts,
            routes: [
              GoRoute(
                name: Routes.alerts.name,
                path: Routes.alerts.value,
                builder: (context, state) {
                  return const AlertsView();
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: Routes.addPlant.name,
        path: Routes.addPlant.value,
        builder: (context, state) {
          return const AddPlantScreen();
        },
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
}
