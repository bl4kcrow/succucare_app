import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:succucare_app/features/auth/models/models.dart';
import 'package:succucare_app/features/auth/providers/providers.dart';
import 'package:succucare_app/features/auth/repositories/repositories.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.resetError});

  final List<String> resetEmails = [];
  final Object? resetError;

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

void main() {
  group('Auth.sendPasswordResetEmail', () {
    test('forwards the email to the repository', () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(authProvider.notifier).sendPasswordResetEmail(
        email: 'peter@example.com',
      );

      expect(repository.resetEmails, ['peter@example.com']);
    });

    test('rethrows repository errors to the caller', () async {
      final repository = FakeAuthRepository(
        resetError: StateError('network unavailable'),
      );
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await expectLater(
        container
            .read(authProvider.notifier)
            .sendPasswordResetEmail(email: 'peter@example.com'),
        throwsStateError,
      );
    });
  });
}
