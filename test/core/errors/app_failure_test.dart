import 'package:flutter_test/flutter_test.dart';

import 'package:succucare_app/core/errors/errors.dart';

void main() {
  group('AppFailure.toString', () {
    test('returns the user-facing wording', () {
      final failure = AppFailure(AppFailureCode.invalidCredentials);

      expect(failure.toString(), 'Email or password is incorrect.');
    });

    test('does not expose the code or the exception type name', () {
      final failure = AppFailure(
        AppFailureCode.accessDenied,
        cause: Exception('[cloud_firestore/permission-denied] missing rules'),
      );

      expect(failure.toString(), isNot(contains('accessDenied')));
      expect(failure.toString(), isNot(contains('AppFailure')));
      expect(failure.toString(), isNot(contains('cloud_firestore')));
      expect(failure.toString(), isNot(contains('permission-denied')));
      expect(failure.toString(), isNot(contains('missing rules')));
    });
  });

  group('AppFailure.from', () {
    test('returns an AppFailure unchanged', () {
      final failure = AppFailure(AppFailureCode.tooManyAttempts);

      expect(identical(AppFailure.from(failure), failure), isTrue);
    });

    test('maps a plain Exception to the generic wording', () {
      final cause = Exception('network unavailable');

      final failure = AppFailure.from(cause);

      expect(failure.code, AppFailureCode.unknown);
      expect(failure.toString(), 'Something went wrong. Try again.');
      expect(identical(failure.cause, cause), isTrue);
    });

    test('maps a plain StateError to the generic wording', () {
      final failure = AppFailure.from(StateError('network unavailable'));

      expect(failure.toString(), 'Something went wrong. Try again.');
    });
  });

  test('every code carries its own wording', () {
    final messages = AppFailureCode.values.map((code) => code.userMessage);

    expect(messages.toSet().length, AppFailureCode.values.length);
    expect(messages, everyElement(isNotEmpty));
  });
}
