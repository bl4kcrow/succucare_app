import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../../data/services/services.dart';
import 'providers.dart';

part 'auth_repository_impl.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) =>
    AuthRepositoryImpl(authService: FirebaseAuthService());

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.authService});
  final AuthService authService;

  @override
  AppUser currentUser() {
    return authService.currentUser();
  }

  @override
  Stream<AuthenticationState> authStateChanges() => authService.authStateChanges();

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await authService.sendPasswordResetEmail(email);
  }

  @override
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final appUser = await authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return appUser;
  }

  @override
  Future<AppUser> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    final appUser = await authService.signUpWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );

    return appUser;
  }

  @override
  Future<void> signOut() async {
    await authService.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    await authService.deleteAccount();
  }
}
