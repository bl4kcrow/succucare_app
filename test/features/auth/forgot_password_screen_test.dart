import 'package:firebase_auth/firebase_auth.dart';
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
  FakeAuthRepository({this.resetError});

  final List<String> resetEmails = [];
  Object? resetError;

  @override
  AppUser currentUser() => AppUser(id: '', name: 'No name', email: 'No email');

  @override
  Stream<AuthenticationState> authStateChanges() =>
      Stream<AuthenticationState>.value(AuthenticationState.unauthenticated);

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    resetEmails.add(email);

    if (resetError != null) throw resetError!;
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

const String successMessage = 'Password reset email sent. Check your inbox.';

String renderedText(WidgetTester tester) {
  return tester
      .widgetList<Text>(find.byType(Text))
      .map(
        (widget) =>
            widget.data ?? widget.textSpan?.toPlainText() ?? '',
      )
      .join(' | ');
}

Widget buildApp({required FakeAuthRepository repository}) {
  return ProviderScope(
    overrides: [authRepositoryProvider.overrideWithValue(repository)],
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(appRouterProvider);
        router.go('/login/${Routes.forgotPassword.value}');

        return MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.light(),
        );
      },
    ),
  );
}

void main() {
  testWidgets('shows a validation error for an empty email and does not call the repository', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = FakeAuthRepository();
    await tester.pumpWidget(buildApp(repository: repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Send Reset Link'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Reset Password'), findsOneWidget);
    expect(repository.resetEmails, isEmpty);
  });

  testWidgets('shows a validation error for a malformed email and does not call the repository', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = FakeAuthRepository();
    await tester.pumpWidget(buildApp(repository: repository));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'not-an-email');
    await tester.tap(find.text('Send Reset Link'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('Reset Password'), findsOneWidget);
    expect(repository.resetEmails, isEmpty);
  });

  testWidgets('returns to login and shows the confirmation on a successful request', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = FakeAuthRepository();
    await tester.pumpWidget(buildApp(repository: repository));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'peter@example.com');
    await tester.tap(find.text('Send Reset Link'));
    await tester.pumpAndSettle();

    expect(repository.resetEmails, ['peter@example.com']);
    expect(find.text('Reset Password'), findsNothing);
    expect(find.text(successMessage), findsOneWidget);
    expect(find.text('Sign In'), findsWidgets);
  });

  testWidgets('shows the same confirmation for an email with no associated account', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = FakeAuthRepository();
    await tester.pumpWidget(buildApp(repository: repository));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'nobody@example.com');
    await tester.tap(find.text('Send Reset Link'));
    await tester.pumpAndSettle();

    expect(repository.resetEmails, ['nobody@example.com']);
    expect(find.text('Reset Password'), findsNothing);
    expect(find.text(successMessage), findsOneWidget);
  });

  testWidgets('keeps the screen on failure and allows a successful resubmission', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = FakeAuthRepository(
      resetError: Exception('network unavailable'),
    );
    await tester.pumpWidget(buildApp(repository: repository));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'peter@example.com');
    await tester.tap(find.text('Send Reset Link'));
    await tester.pumpAndSettle();

    expect(find.text('Reset Password'), findsOneWidget);
    expect(find.text('Something went wrong. Try again.'), findsOneWidget);
    expect(renderedText(tester), isNot(contains('network unavailable')));
    expect(renderedText(tester), isNot(contains('Exception')));
    expect(find.text('Send Reset Link'), findsOneWidget);
    expect(repository.resetEmails, ['peter@example.com']);

    repository.resetError = null;
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Send Reset Link'));
    await tester.pumpAndSettle();

    expect(repository.resetEmails, ['peter@example.com', 'peter@example.com']);
    expect(find.text('Reset Password'), findsNothing);
    expect(find.text(successMessage), findsOneWidget);
  });

  testWidgets('shows specific wording for a Firebase failure and never its raw detail', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = FakeAuthRepository(
      resetError: FirebaseAuthException(
        code: 'network-request-failed',
        message: 'ERROR [auth/network-request-failed] peter@example.com',
      ),
    );
    await tester.pumpWidget(buildApp(repository: repository));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'peter@example.com');
    await tester.tap(find.text('Send Reset Link'));
    await tester.pumpAndSettle();

    expect(find.text('No connection. Check your network.'), findsOneWidget);

    final rendered = renderedText(tester);
    expect(rendered, isNot(contains('network-request-failed')));
    expect(rendered, isNot(contains('FirebaseAuthException')));
    expect(rendered, isNot(contains('ERROR [')));
    expect(rendered, isNot(contains('firebase_auth')));
  });
}
