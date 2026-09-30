import 'package:flutter_test/flutter_test.dart';

import 'package:succucare_app/features/auth/models/models.dart';
import 'package:succucare_app/features/auth/providers/providers.dart';
import 'package:succucare_app/features/auth/services/services.dart';

class RecordingAuthService implements AuthService {
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

void main() {
  group('AuthRepositoryImpl.sendPasswordResetEmail', () {
    test('delegates the email to the auth service', () async {
      final authService = RecordingAuthService();
      final repository = AuthRepositoryImpl(authService: authService);

      await repository.sendPasswordResetEmail('peter@example.com');

      expect(authService.resetEmails, ['peter@example.com']);
    });

    test('propagates errors thrown by the auth service', () async {
      final authService = RecordingAuthService()
        ..resetError = StateError('network unavailable');
      final repository = AuthRepositoryImpl(authService: authService);

      await expectLater(
        repository.sendPasswordResetEmail('peter@example.com'),
        throwsStateError,
      );
      expect(authService.resetEmails, ['peter@example.com']);
    });
  });
}
