# Tasks

## 1. Service layer (swappable push service)

- [ ] 1.1 Reshape `lib/features/notifications/services/notifications_service.dart` into an interface exposing current permission status (query, no prompt), permission request, a stream of recordable messages (foreground + tapped), and token acquisition; verify with `fvm flutter analyze` passing for the file.
- [ ] 1.2 Implement `FirebaseMessagingNotificationsService` over `firebase_messaging` (foreground stream from `onMessage`, tapped stream from `onMessageOpenedApp` + `getInitialMessage`, permission query/request, token fetch) plus a top-level `@pragma('vm:entry-point')` background handler; verify with `fvm flutter analyze` passing.
- [ ] 1.3 Bind interface to impl with a generated `@riverpod NotificationsService notificationsService(Ref ref)` provider in `lib/features/notifications/providers/`, following the `plant_identification_service_provider.dart` swap-point pattern; verify with `fvm dart run build_runner build --delete-conflicting-outputs` producing the `.g.dart` and `fvm flutter analyze` passing.

## 2. Notifications state layer (ViewModel)

- [ ] 2.1 Create the `@riverpod` `NotificationsNotifier` owning `NotificationsState`: build queries current permission status without prompting, subscribes to the service's recordable-message stream, appends newest-first with de-duplication on `messageId`, exposes `requestPermission()` that reconciles status with the outcome, fetches and developer-logs the token when `authorized`, and never throws out of build (initialization failures leave status `unknown`/`unauthorized` and an empty list); verify with `fvm flutter analyze` passing.
- [ ] 2.2 Create a one-shot `pendingAlertsNavigation` provider (set on tap, consumed exactly once, cleared on consumption) for design decision D4; verify with `fvm flutter analyze` passing.
- [ ] 2.3 Write unit tests with a fake `NotificationsService` covering: permission status reflected on build with no prompt issued, grant flow flips status to `authorized` and starts recording, decline flips to `unauthorized`, foreground messages appended newest-first, duplicate `messageId` recorded only once, service failure during build does not throw and leaves the app usable, token fetched and logged only when `authorized`, and pending navigation set-then-consumed-once; verify with `fvm flutter test test/features/notifications` passing.

## 3. Platform config & bootstrap

- [ ] 3.1 Add `POST_NOTIFICATIONS` permission and `com.google.firebase.messaging.default_notification_channel_id` metadata to `android/app/src/main/AndroidManifest.xml`, and create the default notification channel at runtime on first use; verify with `fvm flutter build apk --debug` succeeding.
- [ ] 3.2 Remove the inline `requestPermission`/`getToken` block from `lib/main.dart`, register the top-level background handler before `runApp`, and initialize the notifications state by watching it from `MainApp.build`; verify with `fvm flutter analyze` passing and the app booting to the login/garden location without any notification permission prompt appearing.

## 4. Inbox UI at the alerts location

- [ ] 4.1 Replace the placeholder `lib/features/garden/views/alerts_view.dart` with the real inbox at `lib/features/notifications/screens/alerts_view.dart` (class `AlertsView` kept), updating router and barrel imports: newest-first list showing title, body, and time, an empty state when nothing recorded, and an enable-notifications affordance when `unauthorized` that calls `requestPermission()`; verify with `fvm flutter analyze` passing.
- [ ] 4.2 Write widget tests (provider-overridden fake service) covering: recorded notifications render newest-first with title/body/time, empty state shown when list is empty, enable affordance appears when `unauthorized` and triggers the permission request, affordance hidden when `authorized`; verify with `fvm flutter test test/features/notifications` passing.

## 5. Notification tap-through navigation

- [ ] 5.1 Set the `pendingAlertsNavigation` intent when a tapped message is recorded, and extend the router redirect (design D4) to consume it: authenticated destination resolution goes to `/alerts` instead of the default home, unauthenticated discards the intent so `auth-routing` redirects to login unchanged; verify with `fvm flutter analyze` passing.
- [ ] 5.2 Write tests for the redirect behavior: with intent set and authenticated, cold-start resolution lands on `/alerts`; with intent set and unauthenticated, user is redirected to login and the intent is discarded; intent is consumed only once across successive redirects; verify with `fvm flutter test` passing for those test files.

## 6. Integration checks

- [ ] 6.1 Run `fvm dart run build_runner build --delete-conflicting-outputs`, then `fvm flutter analyze` and confirm no issues beyond the known baseline (legacy `custom_lint` plugin warning, unused `_SecondaryPhotos`).
- [ ] 6.2 Run the full `fvm flutter test` and confirm no new failures beyond the known baseline (the three pre-existing `test/features/succus/home_screen_test.dart` failures).
- [ ] 6.3 Manual smoke test on a device/emulator: token appears in developer logs when authorized; a test message sent from the Firebase console displays as a system notification while backgrounded; tapping it lands on the Alerts location with the message listed; a message received while the app is open appears in the inbox; restarting the app empties the inbox; declining the permission prompt leaves the app fully usable with the enable affordance still available.
