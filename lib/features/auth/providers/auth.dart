import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/app_user.dart';
import '../models/authentication.dart';
import 'auth_repository_impl.dart';
import 'authentication_state.dart';

part 'auth.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  Authentication build() {
    final appUser = ref.watch(authRepositoryProvider).currentUser();

    return Authentication(user: appUser, errorMessage: '');
  }

  Stream<AuthenticationState> authStateChanges() {
    final authRepository = ref.watch(authRepositoryProvider);
    return authRepository.authStateChanges();
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final authRepository = ref.watch(authRepositoryProvider);
    final userResult = await authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    state = state.copyWith(user: userResult);
  }

  Future<void> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    final authRepository = ref.watch(authRepositoryProvider);
    final userResult = await authRepository.signUpWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );

    state = state.copyWith(user: userResult);
  }

  Future<void> signOut() async {
    final authRepository = ref.watch(authRepositoryProvider);
    await authRepository.signOut();

    state = state.copyWith(
      user: AppUser(id: '', name: 'No name', email: 'No email'),
      errorMessage: '',
    );
  }

  Future<void> deleteAccount() async {
    final authRepository = ref.watch(authRepositoryProvider);
    await authRepository.deleteAccount();

    state = state.copyWith(
      user: AppUser(id: '', name: 'No name', email: 'No email'),
      errorMessage: '',
    );
  }
}
