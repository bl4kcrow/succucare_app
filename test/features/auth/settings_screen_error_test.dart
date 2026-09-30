import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:succucare_app/core/routes/app_router.dart';
import 'package:succucare_app/core/routes/routes.dart';
import 'package:succucare_app/core/theme/app_theme.dart';
import 'package:succucare_app/features/auth/models/models.dart';
import 'package:succucare_app/features/auth/providers/providers.dart';
import 'package:succucare_app/features/auth/repositories/repositories.dart';

final AppUser signedInUser = AppUser(
  id: 'uid-1',
  name: 'Peter Petterson',
  email: 'peter@example.com',
);

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.signOutError});

  int signOutAttempts = 0;
  Object? signOutError;

  @override
  AppUser currentUser() => signedInUser;

  @override
  Stream<AuthenticationState> authStateChanges() =>
      Stream<AuthenticationState>.value(AuthenticationState.authenticated);

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> deleteAccount() async {}

  @override
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async => signedInUser;

  @override
  Future<void> signOut() async {
    signOutAttempts++;

    if (signOutError != null) throw signOutError!;
  }

  @override
  Future<AppUser> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async => signedInUser;
}

GoRouter? testRouter;

Widget buildApp({required FakeAuthRepository repository}) {
  return ProviderScope(
    overrides: [authRepositoryProvider.overrideWithValue(repository)],
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(appRouterProvider);
        testRouter = router;
        router.go(Routes.login.value);

        return MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.light(),
        );
      },
    ),
  );
}

String renderedText(WidgetTester tester) {
  return tester
      .widgetList<Text>(find.byType(Text))
      .map((widget) => widget.data ?? widget.textSpan?.toPlainText() ?? '')
      .join(' | ');
}

final Finder signOutButton = find.ancestor(
  of: find.text('Sign Out'),
  matching: find.byWidgetPredicate((widget) => widget is ButtonStyleButton),
);

void main() {
  testWidgets('reports the mapped wording and keeps the session on failure', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = FakeAuthRepository(
      signOutError: FirebaseAuthException(
        code: 'network-request-failed',
        message: 'ERROR [auth/network-request-failed] sign out',
      ),
    );
    await tester.pumpWidget(buildApp(repository: repository));
    await tester.pumpAndSettle();

    testRouter!.go(Routes.settings.value);
    await tester.pumpAndSettle();

    await tester.tap(signOutButton);
    await tester.pumpAndSettle();

    expect(find.text('No connection. Check your network.'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Peter Petterson'), findsOneWidget);
    expect(find.text('peter@example.com'), findsOneWidget);

    final rendered = renderedText(tester);
    expect(rendered, isNot(contains('network-request-failed')));
    expect(rendered, isNot(contains('FirebaseAuthException')));
    expect(rendered, isNot(contains('ERROR [')));
  });

  testWidgets('makes the sign-out action available again on failure', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = FakeAuthRepository(
      signOutError: StateError('network unavailable'),
    );
    await tester.pumpWidget(buildApp(repository: repository));
    await tester.pumpAndSettle();

    testRouter!.go(Routes.settings.value);
    await tester.pumpAndSettle();

    await tester.tap(signOutButton);
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong. Try again.'), findsOneWidget);
    expect(repository.signOutAttempts, 1);
    expect(find.text('Signing out...'), findsNothing);
    expect(find.text('Sign Out'), findsOneWidget);
    expect(tester.widget<ButtonStyleButton>(signOutButton).onPressed, isNotNull);

    await tester.tap(signOutButton);
    await tester.pumpAndSettle();

    expect(repository.signOutAttempts, 2);
    expect(find.text('Settings'), findsOneWidget);
  });
}
