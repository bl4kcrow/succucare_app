import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/app_user.dart';
import '../providers/authentication_state.dart';
import 'auth_service.dart';

class FirebaseAuthService implements AuthService {
  @override
  Stream<AuthenticationState> authStateChanges() {
    StreamController<AuthenticationState> controller =
        StreamController<AuthenticationState>();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        controller.add(AuthenticationState.authenticated);
      } else {
        controller.add(AuthenticationState.unauthenticated);
      }
    });

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
  Future<void> sendPasswordResetEmail(String email) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
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
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (error.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
      rethrow; // Re-throw the exception to handle it in the UI
    } catch (error) {
      debugPrint('Error signing in: $error');
      rethrow;
    }

    return appUser; // Return a default user if sign-in fails
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
    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (error.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
      rethrow;
    } catch (error) {
      debugPrint('Error signing up: $error');
      rethrow;
    }

    return appUser;
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
    } else {
      debugPrint('No user is currently signed in.');
    }
  }
}
