# Tasks

## 1. Password reset plumbing

- [x] 1.1 Implement `sendPasswordResetEmail` in `FirebaseAuthService` by awaiting `FirebaseAuth.instance.sendPasswordResetEmail(email)`, and remove the `UnimplementedError` stub. Verify: `fvm flutter analyze` reports no issues in `lib/features/auth/services/firebase_auth_service.dart`.
- [x] 1.2 Implement `AuthRepositoryImpl.sendPasswordResetEmail` to delegate to `authService.sendPasswordResetEmail`, replacing the `UnimplementedError` stub. Verify: add `test/features/auth/auth_repository_impl_test.dart` with a recording fake `AuthService`, and `fvm flutter test test/features/auth/auth_repository_impl_test.dart` passes.
- [x] 1.3 Add a `sendPasswordResetEmail({required String email})` method to the `Auth` Riverpod controller that awaits `authRepositoryProvider` and lets thrown errors propagate (no state change, since the user is unauthenticated). Verify: unit test overriding `authRepositoryProvider` with a fake confirms the email reaches the repository on success and that a thrown repository error is rethrown to the caller; the test passes.

## 2. Routing

- [x] 2.1 Add `forgotPassword('forgot-password')` to the `Routes` enum in `lib/core/routes/routes.dart`. Verify: `fvm flutter analyze` reports no issues.
- [x] 2.2 Register a `forgotPassword` GoRoute as a child of the login route in `lib/core/routes/app_router.dart`, mirroring the existing `createAccount` nesting. Verify: `fvm flutter analyze` reports no issues.
- [x] 2.3 Add `test/features/auth/forgot_password_route_test.dart` that overrides `authRepositoryProvider` with a fake (no Firebase access) and pumps the app router at `/login/forgot-password` for an unauthenticated user, asserting the reset screen renders and is not redirected away. Verify: `fvm flutter test test/features/auth/forgot_password_route_test.dart` passes.

## 3. Reset screen and login entry point

- [x] 3.1 Create `lib/features/auth/screens/forgot_password_screen.dart` (`ForgotPasswordScreen`, `ConsumerStatefulWidget` matching the `CreateAccountScreen` layout conventions) with an email field reusing the existing email validator, a submit button, and no submit while a request is in flight. Verify: add `test/features/auth/forgot_password_screen_test.dart` overriding `authRepositoryProvider` with a fake, asserting empty and malformed emails show validation errors and do not call the repository; the test passes.
- [x] 3.2 Implement the submit action: on validated submit, call `authProvider.notifier.sendPasswordResetEmail`; on success show a confirmation in a floating snackbar via the app `ScaffoldMessenger` and `context.pop()` back to the login location; on failure keep the user on the screen, show the error in a `CustomSnackBarContent` snackbar, and allow resubmission. Verify: extend the three screen tests — (a) success returns to login and the confirmation snackbar is visible, (b) failure keeps the screen displayed with an error snackbar and a second submission can succeed, (c) a well-formed email with no account yields the same confirmation as a registered one — and `fvm flutter test test/features/auth/forgot_password_screen_test.dart` passes.
- [x] 3.3 Wire the static "Forgot Password?" label on `LoginScreen` to navigate to the forgot-password location using the existing `Text.rich` + `TapGestureRecognizer` pattern, and export `ForgotPasswordScreen` from `lib/features/auth/screens/screens.dart`. Verify: extend the router test from 2.3 (or an equivalent widget test) so an unauthenticated user starting at `/login` who taps the label lands on the reset screen, and `fvm flutter test test/features/auth/forgot_password_route_test.dart` passes.

## 4. Integration verification

- [x] 4.1 Run the project verification suite (`fvm flutter analyze` then `fvm flutter test`) and confirm no new findings beyond the documented baseline (the `custom_lint` analyzer-plugin warning, the unused `_SecondaryPhotos`, and the three pre-existing `test/features/succus/home_screen_test.dart` failures). Verify: command output shows pass/fail only for the cases touched by this change beyond the baseline.