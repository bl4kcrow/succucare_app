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
  FakeAuthRepository({this.signInError});

  final List<String> signedInEmails = [];
  Object? signInError;

  @override
  AppUser currentUser() => AppUser(id: '', name: 'No name', email: 'No email');

  @override
  Stream<AuthenticationState> authStateChanges() =>
      Stream<AuthenticationState>.value(AuthenticationState.unauthenticated);

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> deleteAccount() async {}

  @override
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    signedInEmails.add(email);

    if (signInError != null) throw signInError!;

    return AppUser(id: 'id', name: 'name', email: email);
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<AppUser> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async => AppUser(id: 'id', name: name, email: email);
}

Widget buildApp({required FakeAuthRepository repository}) {
  return ProviderScope(
    overrides: [authRepositoryProvider.overrideWithValue(repository)],
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(appRouterProvider);
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

Future<void> submitCredentials(WidgetTester tester) async {
  await tester.enterText(
    find.byType(TextFormField).at(0),
    'peter@example.com',
  );
  await tester.enterText(find.byType(TextFormField).at(1), 'hunter2hunter2');
  await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('surfaces the credential wording for a Firebase failure', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = FakeAuthRepository(
      signInError: FirebaseAuthException(
        code: 'invalid-credential',
        message: 'ERROR [auth/invalid-credential] peter@example.com',
      ),
    );
    await tester.pumpWidget(buildApp(repository: repository));
    await tester.pumpAndSettle();

    await submitCredentials(tester);

    expect(find.text('Email or password is incorrect.'), findsOneWidget);
    expect(find.text('Sign In'), findsWidgets);
    expect(repository.signedInEmails, ['peter@example.com']);
  });

  testWidgets('never reveals the failure code or type name on screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = FakeAuthRepository(
      signInError: FirebaseAuthException(
        code: 'invalid-credential',
        message: 'ERROR [auth/invalid-credential] peter@example.com',
      ),
    );
    await tester.pumpWidget(buildApp(repository: repository));
    await tester.pumpAndSettle();

    await submitCredentials(tester);

    final rendered = renderedText(tester);
    expect(rendered, isNot(contains('invalid-credential')));
    expect(rendered, isNot(contains('FirebaseAuthException')));
    expect(rendered, isNot(contains('ERROR [')));
    expect(rendered, isNot(contains('firebase_auth')));
    expect(rendered, isNot(contains('peter@example.com: ')));
  });

  testWidgets('surfaces the generic wording for a non-Firebase failure', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repository = FakeAuthRepository(
      signInError: StateError('network unavailable'),
    );
    await tester.pumpWidget(buildApp(repository: repository));
    await tester.pumpAndSettle();

    await submitCredentials(tester);

    expect(find.text('Something went wrong. Try again.'), findsOneWidget);

    final rendered = renderedText(tester);
    expect(rendered, isNot(contains('network unavailable')));
    expect(rendered, isNot(contains('StateError')));
  });

  testWidgets('the wording does not disclose which credential was wrong', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    Future<String> wordingFor(String code) async {
      final repository = FakeAuthRepository(
        signInError: FirebaseAuthException(code: code, message: 'boom'),
      );
      await tester.pumpWidget(buildApp(repository: repository));
      await tester.pumpAndSettle();
      await submitCredentials(tester);

      return renderedText(tester);
    }

    final credentialWording = await wordingFor('wrong-password');
    final userWording = await wordingFor('user-not-found');

    expect(credentialWording, userWording);
    expect(credentialWording, contains('Email or password is incorrect.'));
  });
}
