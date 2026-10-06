# Proposal

## Why

The app cannot notify users about anything: `firebase_messaging` is already a dependency, but the only FCM code is an inline permission request and a `debugPrint` of the token in `main.dart`, with no observable state, no message listeners, and no background handling — and the Alerts tab is a hard-coded placeholder. A partially scaffolded `lib/features/notifications/` feature (models and a service stub) exists but is entirely unwired.

## What Changes

- Move notification permission handling out of `main()` into Riverpod-managed state, exposing an observable permission status (`authorized` / `unauthorized` / `unknown`) and a user-triggered request flow.
- Introduce an abstract push-notification service with a Firebase Cloud Messaging implementation bound through a generated provider, so the push provider can be swapped later without touching state or UI code.
- Handle incoming messages: foreground messages and messages the user taps are recorded into a session-scoped notification list; a background message handler is registered so messages work while the app is terminated/backgrounded (displayed by the OS).
- Replace the placeholder Alerts view with the notifications inbox: list of session notifications (title, body, time, newest first), empty and permission-denied states.
- Tapping a system notification opens the app at the Alerts location, respecting the existing auth redirects.
- Add Android platform configuration: `POST_NOTIFICATIONS` manifest permission and a default notification channel; remove the imperative FCM block from `main.dart`.
- No sender/backend is added: verification uses manual test messages from the Firebase console. No persistence: the inbox resets on app restart. iOS is out of scope.

## Capabilities

### New Capabilities

- `notifications`: Notification permission lifecycle, receipt of push messages, the session-scoped in-app notification inbox (Alerts tab), and notification-tap navigation behavior.

### Modified Capabilities

<!-- None: auth-routing already guards the alerts location; user-facing-errors already governs
     failure wording. Notification work conforms to both without changing their requirements. -->

## Impact

- `lib/main.dart` — removes the inline `requestPermission`/`getToken` block; Firebase init order unchanged.
- `lib/features/notifications/` — wires the existing models; adds service implementation, providers/notifiers; fills empty `providers/`, `screens/` folders.
- `lib/features/garden/views/alerts_view.dart` — placeholder replaced by the inbox UI.
- `lib/core/routes/app_router.dart` — mechanism for routing notification taps to `/alerts` after startup/redirect resolution.
- `android/app/src/main/AndroidManifest.xml` — `POST_NOTIFICATIONS` permission and default notification channel metadata.
- Dependencies: no new packages required (`firebase_messaging: ^16.7.0` already present); Riverpod codegen and `build_runner` output will change.
- Tests: new unit/widget tests for the notifications state layer and inbox UI; existing tests unaffected.
