import 'firebase_error_mapper.dart';

enum AppFailureCode {
  invalidEmail("That email address isn't valid."),
  invalidCredentials('Email or password is incorrect.'),
  emailAlreadyRegistered('That email is already registered.'),
  weakPassword('Choose a stronger password.'),
  tooManyAttempts('Too many attempts. Try again later.'),
  noNetwork('No connection. Check your network.'),
  userDisabled('This account is disabled.'),
  sessionExpired('Sign in again to continue.'),
  accessDenied("You don't have access to that."),
  notFound('That record no longer exists.'),
  alreadyExists('That already exists.'),
  unavailable('Service is busy. Try again.'),
  quotaExceeded('Storage is full. Free up space.'),
  invalidData("That information isn't valid."),
  validation('Please fill all the fields'),
  plantIdentificationUnavailable("Plant identification isn't available right now."),
  plantIdentificationPhotoTooLarge('That photo is too large to identify. Choose another.'),
  plantIdentificationRateLimited('Identification is busy right now. Try again later.'),
  plantIdentificationNoResult("Couldn't identify that plant. Fill in the details yourself."),
  unknown('Something went wrong. Try again.');

  const AppFailureCode(this.userMessage);

  final String userMessage;
}

class AppFailure implements Exception {
  AppFailure(this.code, {this.cause});

  factory AppFailure.from(Object error) {
    if (error is AppFailure) return error;

    return AppFailure(mapFirebaseErrorCode(error), cause: error);
  }

  final AppFailureCode code;
  final Object? cause;

  String get userMessage => code.userMessage;

  @override
  String toString() => userMessage;
}
