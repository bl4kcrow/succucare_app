import 'package:firebase_auth/firebase_auth.dart';

import 'app_failure.dart';

const Map<String, AppFailureCode> _authCodes = {
  'invalid-email': AppFailureCode.invalidEmail,
  'invalid-credential': AppFailureCode.invalidCredentials,
  'invalid-login-credentials': AppFailureCode.invalidCredentials,
  'wrong-password': AppFailureCode.invalidCredentials,
  'user-not-found': AppFailureCode.invalidCredentials,
  'email-already-in-use': AppFailureCode.emailAlreadyRegistered,
  'weak-password': AppFailureCode.weakPassword,
  'too-many-requests': AppFailureCode.tooManyAttempts,
  'network-request-failed': AppFailureCode.noNetwork,
  'user-disabled': AppFailureCode.userDisabled,
  'requires-recent-login': AppFailureCode.sessionExpired,
};

const Map<String, AppFailureCode> _firestoreCodes = {
  'permission-denied': AppFailureCode.accessDenied,
  'not-found': AppFailureCode.notFound,
  'already-exists': AppFailureCode.alreadyExists,
  'unavailable': AppFailureCode.unavailable,
  'deadline-exceeded': AppFailureCode.unavailable,
  'resource-exhausted': AppFailureCode.quotaExceeded,
  'unauthenticated': AppFailureCode.sessionExpired,
  'invalid-argument': AppFailureCode.invalidData,
  'failed-precondition': AppFailureCode.invalidData,
};

const Map<String, AppFailureCode> _storageCodes = {
  'storage/object-not-found': AppFailureCode.notFound,
  'storage/unauthenticated': AppFailureCode.sessionExpired,
  'storage/unauthorized': AppFailureCode.accessDenied,
  'storage/canceled': AppFailureCode.unavailable,
  'storage/deadline-exceeded': AppFailureCode.unavailable,
  'storage/retry-limit-exceeded': AppFailureCode.unavailable,
  'storage/quota-exceeded': AppFailureCode.quotaExceeded,
  'storage/object-size-too-large': AppFailureCode.quotaExceeded,
};

AppFailureCode mapFirebaseErrorCode(Object error) {
  if (error is FirebaseAuthException) {
    return _authCodes[error.code] ?? AppFailureCode.unknown;
  }

  if (error is FirebaseException) {
    final code = error.code;

    return (code.startsWith('storage/') ? _storageCodes[code] : _firestoreCodes[code]) ??
        AppFailureCode.unknown;
  }

  return AppFailureCode.unknown;
}
