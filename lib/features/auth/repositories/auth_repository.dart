import '../models/models.dart';
import '../providers/providers.dart';

abstract class AuthRepository {
  AppUser currentUser();

  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AppUser> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signOut();

   Stream<AuthenticationState>authStateChanges();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> deleteAccount();
}