# Design

## Context

The auth layer already declares but does not implement `sendPasswordResetEmail` end-to-end: `AuthService` (`lib/features/auth/services/auth_service.dart`), `FirebaseAuthService`, `AuthRepository` (`lib/features/auth/repositories/auth_repository.dart`), and `AuthRepositoryImpl` all stub it with `UnimplementedError`, and the `Auth` controller has no method for it. The login screen renders a static "Forgot Password?" label with no action. Routing is go_router with a `Routes` enum; `createAccount` is already a child of the `/login` route, and the router's public-route check (`fullPath.startsWith('${Routes.login.value}/')`) plus the existing `auth-routing` spec already treat any location nested under `/login` as public. See proposal.md for motivation.

## Goals / Non-Goals

**Goals:**
- Add a public password reset location reachable from the login screen.
- Complete the reset plumbing (service → repository → provider) using Firebase Authentication's password reset email.
- On success, return to login with a confirmation; on failure, stay and let the user retry.

**Non-Goals:**
- In-app handling of the emailed reset link (password set form lives on Firebase's hosted flow).
- Resend cooldowns or rate limiting beyond what Firebase enforces.
- Changing an already-signed-in user's password from account settings.
- Fixing the dormant Google/Instagram/Facebook sign-in buttons.

## Decisions

1. **Nest the reset route under `/login`.**
   Add `Routes.forgotPassword('forgot-password')` as a child GoRoute of the login route, mirroring `createAccount`. Rationale: the existing router check and the `auth-routing` requirement already classify nested login locations as public, so no redirect logic or spec change is needed. Alternative (a top-level `/forgot-password`) would require extending `isPublicRoute` and touching routing behavior for no benefit.

2. **Implement the reset call in the existing layers.**
   `FirebaseAuthService.sendPasswordResetEmail` becomes `await FirebaseAuth.instance.sendPasswordResetEmail(email)`; `AuthRepositoryImpl` delegates to the service; the `Auth` controller gains a method that awaits the repository and lets exceptions propagate. The reset op does not change the user/session state, so it stays a plain method on `Auth` rather than a dedicated notifier/provider.

3. **Screen mirrors `CreateAccountScreen` conventions.**
   `ForgotPasswordScreen` is a `ConsumerStatefulWidget` with an email field reusing the existing email regex validator, a submit button, and `onTapOutside` unfocus behavior, matching `create_account_screen.dart`/`login_screen.dart` style (core theme `Insets`, `AppColors`, `CustomSnackBarContent`).

4. **Success auto-returns to login with a snackbar.**
   On success the screen shows a confirmation snackbar through the app `ScaffoldMessenger` and then `context.pop()`s back to login. SnackBars are owned by the messenger, so the confirmation continues to display on the login scaffold after the pop. This matches the requested flow (auto-return + success snackbar) over a dedicated success screen or staying put.

5. **Failures stay on screen and are retryable.**
   The submit handler catches exceptions (as `LoginScreen` does), surfaces them in a floating snackbar with `CustomSnackBarContent`, keeps the user on the reset screen, and re-enables submission. No error-code-to-message mapping; the existing auth screens already pass error text through verbatim.

6. **Account existence is not disclosed.**
   `FirebaseAuth.instance.sendPasswordResetEmail` returns success for well-formed emails regardless of registration, which satisfies the anti-enumeration requirement without extra handling. This must not be "fixed" later by surfacing user-not-found errors.

7. **Login entry point becomes tappable.**
   Replace the static "Forgot Password?" `Text` with the `Text.rich` + `TapGestureRecognizer` pattern already used for "Don't have an account? Sign Up", pushing `Routes.forgotPassword`.

## Risks / Trade-offs

- Snackbar racing the screen pop → Mitigation: raise the snackbar via the app-level `ScaffoldMessenger` before popping; verify in widget testing that it is visible on the login screen.
- Emulator/local auth can't deliver real emails → Mitigation: dev relies on the real Firebase project for delivery; the UI path and error handling remain testable with overrides.
- Anti-enumeration regression risk → Mitigation: pinned by the spec scenario; keep Firebase's silent-success behavior and cover it in tests.

## Migration Plan

No data or schema changes. Rollout is a single feature branch (route + screen + plumbing); rollback is reverting the same files. `openspec archive` will move the new `password-reset` capability into the main spec set; nothing else changes.

## Open Questions

None.