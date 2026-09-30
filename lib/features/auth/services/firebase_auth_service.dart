import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/errors/errors.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import 'services.dart';

class FirebaseAuthService implements AuthService {
  @override
  Stream<AuthenticationState> authStateChanges() {
    StreamController<AuthenticationState> controller =
        StreamController<AuthenticationState>();

    FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        if (user != null) {
          controller.add(AuthenticationState.authenticated);
        } else {
          controller.add(AuthenticationState.unauthenticated);
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        controller.add(AuthenticationState.unauthenticated);
        controller.close();
      },
      onDone: controller.close,
    );

    return controller.stream;
  }

  @override
  AppUser currentUser() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    AppUser user = AppUser(
      id: firebaseUser?.uid ?? '',
      name: firebaseUser?.displayName ?? 'No name',
      email: firebaseUser?.email ?? 'No email',
    );

    return user;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (error) {
      debugPrint('Error reset email: $error');
      throw AppFailure.from(error);
    }
  }

  @override
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    AppUser appUser = AppUser(id: '', name: 'No name', email: 'No email');

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      appUser = appUser.copyWith(
        id: credential.user?.uid ?? '',
        name: credential.user?.displayName ?? 'No name',
        email: credential.user?.email ?? 'No email',
      );
    } catch (error) {
      debugPrint('Error signing in: $error');
      throw AppFailure.from(error);
    }

    return appUser;
  }

  @override
  Future<AppUser> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    AppUser appUser = AppUser(id: '', name: 'No name', email: 'No email');

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
        appUser = appUser.copyWith(
          id: credential.user!.uid,
          name: name,
          email: credential.user!.email!,
        );
      }
    } catch (error) {
      debugPrint('Error signing up: $error');
      throw AppFailure.from(error);
    }

    return appUser;
  }

  @override
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (error) {
      debugPrint('Error signing out: $error');
      throw AppFailure.from(error);
    }
  }

  @override
  Future<void> deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.delete();
      } catch (error) {
        debugPrint('Error deleting account: $error');
        throw AppFailure.from(error);
      }
    } else {
      debugPrint('No user is currently signed in.');
    }
  }
}
