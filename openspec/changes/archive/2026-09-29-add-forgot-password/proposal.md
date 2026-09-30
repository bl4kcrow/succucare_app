# Proposal

## Why

Users who forget their password currently cannot regain access on their own. The login screen shows a static "Forgot Password?" label with no destination, and the reset plumbing already scaffolded in the auth layer (`AuthService`, `AuthRepository`, `FirebaseAuthService`, `AuthRepositoryImpl`) throws `UnimplementedError`. Self-service password recovery is a baseline requirement for an email/password authenticated app.

## What Changes

- Make the "Forgot Password?" label on the login screen an actionable link that opens a new password reset location.
- Add a password reset location (`/login/forgot-password`) nested beneath the login location, so it is public under the existing authentication-routing rules.
- Add a reset screen with a validated email field and a submit action that requests a password reset link from the auth backend.
- Implement `sendPasswordResetEmail` end-to-end (auth service, repository, and Riverpod controller) using Firebase Authentication's password reset email.
- On a successful request, return the user to the login screen and show a confirmation that the reset email was sent.
- On a failed request, keep the user on the reset screen and communicate the failure so they can retry.

## Capabilities

### New Capabilities
- `password-reset`: Enables an unauthenticated user to request a password reset email for their account from the authentication flow, and defines how the app communicates success and failure.

### Modified Capabilities
- None. The public classification of the new reset location is already covered by the existing `auth-routing` requirement that any location nested beneath the login location is public; no requirement text changes.

## Impact

- `lib/core/routes/routes.dart` — new `forgotPassword` route constant.
- `lib/core/routes/app_router.dart` — register the reset route nested under the login route.
- `lib/features/auth/screens/login_screen.dart` — wire the "Forgot Password?" label to navigate to the reset location.
- `lib/features/auth/screens/forgot_password_screen.dart` — new reset screen.
- `lib/features/auth/screens/screens.dart` — export the new screen.
- `lib/features/auth/services/auth_service.dart` and `firebase_auth_service.dart` — implement `sendPasswordResetEmail` against `FirebaseAuth.instance.sendPasswordResetEmail`.
- `lib/features/auth/repositories/auth_repository.dart` and `providers/auth_repository_impl.dart` — implement `sendPasswordResetEmail` delegation.
- `lib/features/auth/providers/auth.dart` — expose a `sendPasswordResetEmail` method on the `Auth` controller.