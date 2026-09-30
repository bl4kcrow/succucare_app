# Tasks

## 1. Core failure type and Firebase mapping

- [x] 1.1 Create `lib/core/errors/app_failure.dart` with `AppFailure implements Exception` and an
      `AppFailureCode` enum whose values carry exactly the wording in
      `specs/user-facing-errors/spec.md` (including the validation wording that replaces the
      current `'Please fill all the fields'` literal). Expose `code` and `Object? cause` for
      diagnostics, override `toString()` to return the user-facing wording and never the cause, and
      add a `AppFailure.from(Object error)` normalizer that returns an `AppFailure` unchanged and
      otherwise maps it. Add the `lib/core/errors/errors.dart` barrel to match the existing
      per-folder barrel convention. Verify: add `test/core/errors/app_failure_test.dart` asserting
      `toString()` returns the wording, returns no error code or exception type name, an
      `AppFailure` passed to `from` is returned unchanged, and a plain `Exception` yields the
      generic wording; `fvm flutter test test/core/errors/app_failure_test.dart` passes.
- [x] 1.2 Create `lib/core/errors/firebase_error_mapper.dart` mapping on the error `code` only, with
      three tables: `FirebaseAuthException` codes (unprefixed, covering the current
      `invalid-credential` and `invalid-login-credentials` alongside the legacy
      `wrong-password` and `user-not-found`), Cloud Firestore codes, and the `storage/`-prefixed
      Firebase Storage codes. Collapse the four credential codes onto one message. Fall back to the
      generic code for any unmapped or non-Firebase error, never to the raw error text. Export it
      from the barrel. Verify: add `test/core/errors/firebase_error_mapper_test.dart` covering one
      representative code per table row, the four credential codes resolving to a single identical
      message, an unmapped Auth code, an unmapped Storage code, a non-Firebase `Exception`, and a
      `null`-code `FirebaseException`; each asserts the exact wording and that no Firebase code
      string appears in the result. `fvm flutter test test/core/errors/firebase_error_mapper_test.dart`
      passes.
- [x] 1.3 Confirm no code-generation is required for this change: no `freezed`, `json_serializable`,
      or `riverpod` annotation is touched and the two garden state classes are hand-written.
      Verify: `fvm dart run build_runner build --delete-conflicting-outputs` produces no diff in
      any `*.g.dart` or `*.freezed.dart` under `lib/`.

## 2. Auth service conversion

- [x] 2.1 Replace the three `debugPrint`-and-rethrow blocks in
      `lib/features/auth/services/firebase_auth_service.dart` with a throw of the mapped failure
      that still records the original error via `debugPrint`, and bring `deleteAccount` and the
      `signOut` path under the same handling. Leave the `AuthService` interface signature
      unchanged. Verify: `fvm flutter analyze` reports no new findings, and
      `fvm flutter test test/features/auth/auth_repository_impl_test.dart test/features/auth/auth_controller_test.dart`
      still passes unchanged — those two suites assert that a thrown error propagates out of the
      repository and controller, which the conversion must not break.
- [x] 2.2 Rewire the three auth screens to build the message with `AppFailure.from(error)` and pass
      its wording to the existing notification, leaving each screen's `SnackBar` configuration
      byte-for-byte unchanged: `login_screen.dart:132`, `forgot_password_screen.dart:64`,
      `settings_screen.dart:33`. Verify: `fvm flutter analyze` reports no new findings.

## 3. Auth screen behaviour

- [x] 3.1 Update `test/features/auth/forgot_password_screen_test.dart:170`, which currently expects
      the raw `Exception: network unavailable` text, to expect the mapped wording, and add a case
      asserting the raw exception text is not present anywhere on screen. Verify:
      `fvm flutter test test/features/auth/forgot_password_screen_test.dart` passes.
- [x] 3.2 Add `test/features/auth/login_screen_error_test.dart` using the existing
      `FakeAuthRepository` pattern, covering: a `FirebaseAuthException`-shaped failure surfaces the
      "Email or password is incorrect." wording; the same exception's code and type name appear
      nowhere on screen; and a non-Firebase failure surfaces the generic wording. Verify:
      `fvm flutter test test/features/auth/login_screen_error_test.dart` passes.
- [x] 3.3 Add a sign-out failure case covering `settings_screen.dart`, confirming the user remains
      signed in, the mapped wording is shown, and the sign-out action becomes available again per
      the existing `user-settings` requirement. Verify: the new case passes under
      `fvm flutter test`.

## 4. Garden datasources, state, and screens

- [x] 4.1 Convert the Cloud Firestore calls in `lib/features/garden/datasource/plants_datasource.dart`
      and the Firebase Storage calls in
      `lib/features/garden/datasource/plant_photo_datasource.dart` to throw the mapped failure while
      still recording the original error, leaving the `PlantsDatasource` and `PlantPhotoDatasource`
      interfaces and `MockPlantsDatasource` untouched. Verify: `fvm flutter analyze` reports no new
      findings, and no `FirebaseFirestore` or `FirebaseStorage` call remains outside a converted
      method body.
- [x] 4.2 Replace `String? errorMessage` with the failure type in the hand-written
      `NewPlantState` and `EditPlantState` classes, updating their hand-written `copyWith` and
      `clearError` handling, and convert the `'Please fill all the fields'` validation assignment in
      both notifiers to the validation code. Verify: `fvm flutter analyze` reports no new findings
      and the generated `.g.dart` files are unchanged.
- [x] 4.3 Rewire `add_plant_screen.dart` and `edit_plant_screen.dart` to render the failure's
      wording, keeping each screen's existing `SnackBar` configuration unchanged. Verify:
      `fvm flutter analyze` reports no new findings.
- [x] 4.4 Add `test/features/garden/plant_failure_test.dart` overriding `gardenRepositoryImplProvider`
      and `photosRepositoryImplProvider` with throwing fakes, covering: an add-plant submit that
      fails on a Storage failure stores the mapped wording in state and renders it in the existing
      notification; an edit-plant submit that fails on a Firestore access-refused failure does the
      same; the validation path shows the validation wording and does not call the repository; and
      no rendered text contains a Firebase code or exception type name. Verify:
      `fvm flutter test test/features/garden/plant_failure_test.dart` passes.

## 5. Integration verification

- [x] 5.1 Run the repository verification suite in the order given in `AGENTS.md` —
      `fvm flutter analyze` then `fvm flutter test` — and confirm findings are limited to the
      documented baseline: the `custom_lint` analyzer-plugin warning, the unused `_SecondaryPhotos`,
      and the three pre-existing `test/features/succus/home_screen_test.dart` failures. Verify:
      command output shows no failure outside that baseline.
- [x] 5.2 Audit that no caught error is still stringified into a user-facing surface, confirming
      `error.toString()` is gone from `login_screen.dart`, `forgot_password_screen.dart`,
      `settings_screen.dart`, `add_plant_provider.dart`, and `edit_plant_provider.dart`. Verify: a
      search for `error.toString()` across `lib/` returns no hit in those five files.
