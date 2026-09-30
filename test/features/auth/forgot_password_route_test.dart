import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:succucare_app/core/routes/app_router.dart';
import 'package:succucare_app/core/routes/routes.dart';
import 'package:succucare_app/core/theme/app_theme.dart';
import 'package:succucare_app/features/auth/models/models.dart';
import 'package:succucare_app/features/auth/providers/providers.dart';
import 'package:succucare_app/features/auth/repositories/repositories.dart';

class FakeAuthRepository implements AuthRepository {
  final List<String> resetEmails = [];

  @override
  AppUser currentUser() => AppUser(id: '', name: 'No name', email: 'No email');

  @override
  Stream<AuthenticationState> authStateChanges() =>
      Stream<AuthenticationState>.value(AuthenticationState.unauthenticated);

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    resetEmails.add(email);
  }

  @override
  Future<void> deleteAccount() async {}

  @override
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async => AppUser(id: 'id', name: 'name', email: email);

  @override
  Future<void> signOut() async {}

  @override
  Future<AppUser> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async => AppUser(id: 'id', name: name, email: email);
}

Widget buildApp({
  required String initialLocation,
  required FakeAuthRepository repository,
}) {
  return ProviderScope(
    overrides: [authRepositoryProvider.overrideWithValue(repository)],
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(appRouterProvider);
        router.go(initialLocation);

        return MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.light(),
        );
      },
    ),
  );
}

void main() {
  testWidgets('renders the reset screen for an unauthenticated user at the reset location', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        initialLocation: '/login/${Routes.forgotPassword.value}',
        repository: FakeAuthRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reset Password'), findsOneWidget);
    expect(find.text('Send Reset Link'), findsOneWidget);
  });

  testWidgets('reaches the reset screen by tapping the forgot password label on login', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        initialLocation: Routes.login.value,
        repository: FakeAuthRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reset Password'), findsNothing);
    expect(find.text('Forgot Password?'), findsOneWidget);

    await tester.tapOnText(find.textRange.ofSubstring('Forgot Password?'));
    await tester.pumpAndSettle();

    expect(find.text('Reset Password'), findsOneWidget);
    expect(find.text('Send Reset Link'), findsOneWidget);
  });
}
