import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:succucare_app/core/errors/errors.dart';

FirebaseAuthException authError(String code) =>
    FirebaseAuthException(code: code, message: 'boom');

FirebaseException firestoreError(String code) =>
    FirebaseException(plugin: 'cloud_firestore', code: code, message: 'boom');

FirebaseException storageError(String code) =>
    FirebaseException(plugin: 'firebase_storage', code: code, message: 'boom');

void expectMapped(Object error, String code, String wording) {
  final failure = AppFailure.from(error);

  expect(failure.toString(), wording, reason: 'expected $code to map to $wording');
  expect(failure.toString(), isNot(contains(code)));
  expect(failure.toString(), isNot(contains('Exception')));
  expect(failure.toString(), isNot(contains('firebase')));
}

void main() {
  group('auth codes', () {
    test('invalid-email', () {
      expectMapped(
        authError('invalid-email'),
        'invalid-email',
        "That email address isn't valid.",
      );
    });

    test('email-already-in-use', () {
      expectMapped(
        authError('email-already-in-use'),
        'email-already-in-use',
        'That email is already registered.',
      );
    });

    test('weak-password', () {
      expectMapped(authError('weak-password'), 'weak-password', 'Choose a stronger password.');
    });

    test('too-many-requests', () {
      expectMapped(
        authError('too-many-requests'),
        'too-many-requests',
        'Too many attempts. Try again later.',
      );
    });

    test('network-request-failed', () {
      expectMapped(
        authError('network-request-failed'),
        'network-request-failed',
        'No connection. Check your network.',
      );
    });

    test('user-disabled', () {
      expectMapped(authError('user-disabled'), 'user-disabled', 'This account is disabled.');
    });

    test('requires-recent-login', () {
      expectMapped(
        authError('requires-recent-login'),
        'requires-recent-login',
        'Sign in again to continue.',
      );
    });

    test('the four credential codes collapse to one message', () {
      const credentialCodes = [
        'invalid-credential',
        'invalid-login-credentials',
        'wrong-password',
        'user-not-found',
      ];

      final messages = credentialCodes.map((code) => AppFailure.from(authError(code)).toString()).toSet();

      expect(messages, {'Email or password is incorrect.'});
    });

    test('an unmapped auth code falls back to the generic wording', () {
      expectMapped(authError('some-future-code'), 'some-future-code', 'Something went wrong. Try again.');
    });

  });

  group('firestore codes', () {
    test('permission-denied', () {
      expectMapped(
        firestoreError('permission-denied'),
        'permission-denied',
        "You don't have access to that.",
      );
    });

    test('not-found', () {
      expectMapped(
        firestoreError('not-found'),
        'not-found',
        'That record no longer exists.',
      );
    });

    test('already-exists', () {
      expectMapped(firestoreError('already-exists'), 'already-exists', 'That already exists.');
    });

    test('unavailable', () {
      expectMapped(firestoreError('unavailable'), 'unavailable', 'Service is busy. Try again.');
    });

    test('deadline-exceeded', () {
      expectMapped(
        firestoreError('deadline-exceeded'),
        'deadline-exceeded',
        'Service is busy. Try again.',
      );
    });

    test('resource-exhausted', () {
      expectMapped(
        firestoreError('resource-exhausted'),
        'resource-exhausted',
        'Storage is full. Free up space.',
      );
    });

    test('unauthenticated', () {
      expectMapped(
        firestoreError('unauthenticated'),
        'unauthenticated',
        'Sign in again to continue.',
      );
    });

    test('invalid-argument', () {
      expectMapped(
        firestoreError('invalid-argument'),
        'invalid-argument',
        "That information isn't valid.",
      );
    });

    test('failed-precondition', () {
      expectMapped(
        firestoreError('failed-precondition'),
        'failed-precondition',
        "That information isn't valid.",
      );
    });

    test('an unmapped firestore code falls back to the generic wording', () {
      expectMapped(
        firestoreError('some-future-code'),
        'some-future-code',
        'Something went wrong. Try again.',
      );
    });
  });

  group('storage codes', () {
    test('storage/object-not-found', () {
      expectMapped(
        storageError('storage/object-not-found'),
        'object-not-found',
        'That record no longer exists.',
      );
    });

    test('storage/unauthenticated', () {
      expectMapped(
        storageError('storage/unauthenticated'),
        'unauthenticated',
        'Sign in again to continue.',
      );
    });

    test('storage/unauthorized', () {
      expectMapped(
        storageError('storage/unauthorized'),
        'unauthorized',
        "You don't have access to that.",
      );
    });

    test('storage/canceled', () {
      expectMapped(storageError('storage/canceled'), 'canceled', 'Service is busy. Try again.');
    });

    test('storage/deadline-exceeded', () {
      expectMapped(
        storageError('storage/deadline-exceeded'),
        'deadline-exceeded',
        'Service is busy. Try again.',
      );
    });

    test('storage/retry-limit-exceeded', () {
      expectMapped(
        storageError('storage/retry-limit-exceeded'),
        'retry-limit-exceeded',
        'Service is busy. Try again.',
      );
    });

    test('storage/quota-exceeded', () {
      expectMapped(
        storageError('storage/quota-exceeded'),
        'quota-exceeded',
        'Storage is full. Free up space.',
      );
    });

    test('storage/object-size-too-large', () {
      expectMapped(
        storageError('storage/object-size-too-large'),
        'object-size-too-large',
        'Storage is full. Free up space.',
      );
    });

    test('an unmapped storage code falls back to the generic wording', () {
      expectMapped(
        storageError('storage/some-future-code'),
        'some-future-code',
        'Something went wrong. Try again.',
      );
    });
  });

  group('non-firebase errors', () {
    test('a plain Exception falls back to the generic wording', () {
      expectMapped(Exception('network unavailable'), 'network', 'Something went wrong. Try again.');
    });

    test('a plain StateError falls back to the generic wording', () {
      expectMapped(StateError('network unavailable'), 'StateError', 'Something went wrong. Try again.');
    });

    test('a FirebaseException with no code falls back to the generic wording', () {
      expectMapped(
        FirebaseException(plugin: 'cloud_firestore'),
        'plugin',
        'Something went wrong. Try again.',
      );
    });

    test('an AppFailure is returned unchanged', () {
      final failure = AppFailure(AppFailureCode.notFound);

      expect(identical(AppFailure.from(failure), failure), isTrue);
    });
  });

  test('the mapped wording is identical at every surface', () {
    final fromAuthScreen = AppFailure.from(authError('invalid-credential'));
    final fromSettingsScreen = AppFailure.from(authError('invalid-credential'));

    expect(fromAuthScreen.toString(), fromSettingsScreen.toString());
  });
}
