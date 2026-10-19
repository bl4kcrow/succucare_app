# Design

## Context

See proposal.md for motivation. Current state that shapes this design:

- `firebase_messaging: ^16.7.0` is already a dependency, but `lib/main.dart:36-42` imperatively calls `requestPermission(provisional: true)` and `debugPrint`s the token before `runApp`, with no observable state and no listeners.
- `lib/features/notifications/` has generated models (`AppNotification`, `NotificationsState` with `NotificationStatus {authorized, unauthorized, unknown}` and a notifications list), a stub `abstract interface class NotificationsService` with unusable signatures, and empty `providers/`, `repositories/`, `screens/` folders.
- MVVM convention per feature: `screens|views` (Consumer* views) / `providers` (`@riverpod` codegen) / `models` (Freezed) / abstract `services` + `repositories` bound to impls by a generated provider (swap point pattern: `plant_identification_service_provider.dart:10-19`).
- The router is a generated Riverpod provider (`app_router.dart:13-14`) with auth redirects driven by a local `ValueNotifier`; the Alerts branch renders `AlertsView`, currently a placeholder. `auth-routing` already guards `/alerts`.
- Android manifest has no `POST_NOTIFICATIONS` permission or notification channel config. No backend exists to send messages.

## Goals / Non-Goals

**Goals:**
- Riverpod-owned permission lifecycle and notification state (removing the imperative block from `main()`)
- A swappable push-notification service behind an interface, bound by a generated provider
- A working session-scoped inbox at the alerts location and correct tap-through navigation
- Android platform configuration needed for FCM notifications to actually display

**Non-Goals:**
- iOS/APNs setup
- Persisting notification history (Firestore or local) — session-only by decision
- Any sender/backend (verification is manual via Firebase console)
- Re-displaying foreground messages as system ("heads-up") notifications — that would require `flutter_local_notifications`
- Per-message deep-link routes in data payloads, topics, or segments

## Decisions

### D1. Reshape the service interface; bind impl via generated provider
`NotificationsService` becomes an abstract interface exposing: current permission status, a permission-request method, a stream of messages to record (foreground + tapped), token acquisition, and background-message handling. `FirebaseMessagingNotificationsService` implements it over `firebase_messaging`; `@riverpod NotificationsService notificationsService(Ref ref)` in `lib/features/notifications/providers/` binds the interface to the impl.
*Why:* this is the project's established swap point (same shape as `plantIdentificationService`), directly satisfying "change the push service later" without touching state or UI. *Alternative:* calling `FirebaseMessaging` directly from the notifier — rejected, no seam for replacement or fakes in tests.

### D2. One notifier owns `NotificationsState`
`@riverpod class NotificationsNotifier extends _$NotificationsNotifier` builds the existing `NotificationsState` by (a) querying the device's current permission status (no prompt), and (b) subscribing to the service's message stream, appending `AppNotification`s newest-first with de-duplication on `messageId`. It exposes `requestPermission()` for the UI and fetches the token (developer log only) once status is `authorized`. Subscriptions are disposed via `ref.onDispose`.
*Why:* reuses the already-generated state model; one source of truth for permission + inbox; matches the project's `Notifier`/`AsyncNotifier` ViewModel style.

### D3. Bootstrap in `MainApp`, not `main()`
`main()` keeps Firebase/App Check init, registers the top-level background handler (`FirebaseMessaging.onBackgroundMessage`) — a plain registration, no permission prompt — and deletes the inline `requestPermission`/`getToken` block. The notifier is initialized by watching it from `MainApp.build`, so message listeners attach at every app start (required for tap-through) while permission is only *queried*, never requested, at startup.
*Why:* keeps `main()` free of feature logic, ensures listeners exist before any navigation matters, and satisfies "no prompt until user asks".

### D4. Tap-through via a one-shot pending-navigation provider
Tapped messages surface through the service stream. Because the router is provider-based but auth redirects are asynchronous (cold start passes through unresolved/splash first), the notifier records a one-shot `pendingAlertsNavigation` intent instead of calling `go()` directly. The router's redirect consumes it when it next resolves an authenticated destination: destination becomes `/alerts` instead of the default `/home`; if auth resolves unauthenticated, the intent is discarded and `auth-routing` sends the user to login (as the spec requires). Intent clears on consumption.
*Why:* navigation decided by the router's own redirect logic cannot fight `auth-routing`; direct `go()` from a listener would race the splash/auth state. *Alternative:* a global navigator key used from `onMessageOpenedApp` — rejected, bypasses redirects and duplicates router knowledge in the notifications feature.

### D5. Inbox UI lives in the notifications feature; router import swapped
The placeholder `lib/features/garden/views/alerts_view.dart` is replaced by `lib/features/notifications/screens/alerts_view.dart` (class name `AlertsView` kept, so only the router/barrel imports change). It watches `notificationsProvider` and renders: the list (newest-first, title/body/time), an empty state, and — when unauthorized — an "enable notifications" affordance that calls `requestPermission()`.
*Why:* the feature that owns the state owns the screen (fills the empty `screens/` folder, preserves MVVM feature cohesion); the shell's `NavigationBar` entry and `/alerts` path are unchanged.

### D6. Android platform configuration
Add `POST_NOTIFICATIONS` to `AndroidManifest.xml` and a default channel via `com.google.firebase.messaging.default_notification_channel_id` metadata, creating the channel at runtime on first use. Uses only `firebase_messaging` — `permission_handler`/`flutter_local_notifications` are not needed for permission + OS-displayed notifications on Android 13+.
*Why:* FCM notification messages will not display on Android 13+ without the runtime permission, and messages arriving before any channel exists need a default channel.

### D7. Background handling boundary
A top-level `@pragma('vm:entry-point')` handler is registered for completeness (data-only messages; future use), but background/terminated *notification* messages are displayed by the OS and are not recorded into the inbox unless tapped (which D4 handles). Only foreground receipt and taps populate the list — per spec.

## Risks / Trade-offs

- [Redirect changes could regress auth behavior] → Keep the redirect edit minimal (pending-intent check only), rely on existing auth-routing spec scenarios, and run the full `fvm flutter test` + `fvm flutter analyze`.
- [Session-only inbox loses history on restart] → Accepted scope decision; the empty state explains nothing is stored.
- [Cold-start tap timing: intent consumed only after auth resolves] → One-shot provider consumed inside redirect logic; scenario-covered in the spec and widget-tested with a fake router state where practical.
- [No sender exists → easy to ship untested delivery] → Task list includes an explicit manual Firebase console smoke test (token logged for targeting) as the integration check.
- [Default notification icon/channel misconfigured → notifications render badly or not at all] → Covered by the manual smoke test on a real device/emulator.
- [Android background-message semantics differ between notification and data payloads] → Design D7 keeps the spec honest (taps + foreground only), so behavior stays testable regardless.

## Migration Plan

Single-release change; no data or API migration. The inline FCM block in `main.dart` is deleted in the same change that introduces the provider-driven replacement, so there is no period where permission is requested twice. Rollback = revert the commit; no persisted state is left behind.

## Open Questions

None — sending scope (client-only), inbox persistence (session-only), and platform (Android-only) were decided with the user before this change was created.
