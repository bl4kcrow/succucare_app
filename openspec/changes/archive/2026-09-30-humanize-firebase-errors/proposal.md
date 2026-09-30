# Proposal

## Why

Firebase failure text reaches the user verbatim. Every screen that reports a failure passes the
caught object's `toString()` straight into its snackbar, so a wrong password surfaces as
`Exception: [firebase_auth/wrong-password] ...` and a failed Firestore write surfaces as
`Exception: [cloud_firestore/permission-denied] ...`. None of that is actionable, and the four
credential codes that mean "these credentials did not work" are also not distinguishable to the
user, who only needs to be told which field to correct. The app already carries the information
needed to say something useful; nothing currently translates it.

## What Changes

- Introduce a domain failure type that carries a short, plain-English message intended for the
  user, alongside the originating error code and cause which are retained for logging only.
- Map the Firebase Authentication, Cloud Firestore, and Firebase Storage error codes the app can
  actually encounter onto specific user-facing copy.
- Convert failures at the layer that talks to Firebase — the auth service and the garden
  datasources — so the rest of the app never sees a raw Firebase exception.
- Render the mapped message at the five surfaces that report a failure in a snackbar: sign in,
  password reset, sign out, add plant, and edit plant.
- Collapse the four credential-specific Authentication codes onto one message so a failed sign-in
  does not disclose which part of the credential was wrong.
- Resolve any error with no known mapping, and any error that did not originate in Firebase, to a
  single generic message.
- Carry the failure type, not a pre-formatted string, in the add-plant and edit-plant state, so the
  mapping is applied once rather than at each display site.

No breaking change. Public repository, service, and datasource signatures are unchanged; the
existing hand-written test fakes keep compiling.

## Capabilities

### New Capabilities

- `user-facing-errors`: Defines that no technical error text is ever shown to the user, that
  recognized failures carry specific actionable wording, that unrecognized failures carry exactly
  one generic wording, and that the underlying cause remains available for diagnostics.

### Modified Capabilities

- None. The existing `password-reset` and `user-settings` requirements mandate only that a
  failure *is communicated* and that the user can retry; neither states what the message contains,
  so no requirement text changes. `auth-routing` does not concern error text at all.

## Impact

- `lib/core/errors/` — new `AppFailure` type carrying user-facing copy, its code enum, the
  Firebase code mapping, and a normalizer for errors that are not already a domain failure.
- `lib/features/auth/services/firebase_auth_service.dart` — the three `debugPrint`-and-rethrow
  blocks become a throw of the mapped failure; `deleteAccount` is brought under the same handling.
- `lib/features/garden/datasource/plants_datasource.dart` and
  `lib/features/garden/datasource/plant_photo_datasource.dart` — Firestore and Storage calls
  convert failures at the datasource boundary.
- `lib/features/garden/providers/add_plant_provider.dart` and
  `lib/features/garden/providers/edit_plant_provider.dart` — the hand-written state classes
  replace `String? errorMessage` with the failure type, including the local "fill in all fields"
  validation message which becomes a validation code on the same type.
- `lib/features/auth/screens/login_screen.dart`,
  `lib/features/auth/screens/forgot_password_screen.dart`, and
  `lib/features/auth/screens/settings_screen.dart` — render the mapped message in the existing
  snackbar configuration.
- `lib/features/garden/screens/add_plant_screen.dart` and
  `lib/features/garden/screens/edit_plant_screen.dart` — render the mapped message in the existing
  snackbar configuration.
- `test/features/auth/forgot_password_screen_test.dart` — one assertion currently expects the raw
  `Exception: network unavailable` text and must be updated to the mapped wording.

Explicitly out of scope: the inline `Error: $err` text in the garden list error branch, the
account creation screen's lack of error handling, and the unguarded image picker call. No retry
affordance is added, and no existing snackbar styling is changed.
