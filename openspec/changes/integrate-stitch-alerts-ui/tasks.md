# Tasks

## 1. Alerts Provider Enhancements

- [x] 1.1 Extend `AlertsNotifier` to add filtering state (all/unread) and action methods: `setFilter(FilterType)`, `markAsRead(String messageId)`, `dismiss(String messageId)`, `markAllAsRead()`, `clearRead()`. Preserve existing message handling logic.
- [x] 1.2 Add helper for determining if notification is unread (e.g., track read status). Since session-scoped and simple, can add `readMessageIds` set in state or extend model - but easier to track read state in provider state. Update `NotificationsState` if needed, or manage read state separately in notifier by storing read IDs.
- [x] 1.3 Regenerate code with `fvm dart run build_runner build --delete-conflicting-outputs` and verify `fvm flutter analyze` passes.

## 2. Alerts View UI Implementation

- [x] 2.1 Rewrite `alerts_view.dart` to match Stitch design: header with title "Alertas y Cuidados", unread badge, filter chips (Todas/Sin leer), notification list, empty state, bottom bar with "Sensores sincronizados" and "Limpiar leídas". Watch `alertsProvider` for state.
- [x] 2.2 Implement notification card UI: plant image from `AppNotification.imageUrl` with placeholder if missing, water drop overlay, title, body, relative timestamp, humidity level from `AppNotification.data['moistureLevel']` (Low/Medium/High) shown as progress bar and text, action buttons (Registrar Riego, Marcar como leída, Descartar).
- [x] 2.3 Add relative time formatting (e.g., "Hace X min", "Hace Xh") for Spanish locale.
- [x] 2.4 Wire up actions: mark as read, dismiss, mark all, clear read, register watering (can be a no-op or just mark as read for now per Stitch behavior).
- [x] 2.5 Implement filtering logic (all vs unread) based on read state.
- [x] 2.6 Verify `fvm flutter analyze` passes.

## 3. Tests

- [x] 3.1 Add/update unit tests for `AlertsNotifier` covering new actions (mark read, dismiss, mark all, clear read, filtering). Use existing test patterns.
- [x] 3.2 Add widget tests for `AlertsView` covering rendering of notifications, empty state, filtering, and action buttons.
- [x] 3.3 Run `fvm flutter test` to ensure tests pass (no regressions beyond known baseline).

## 4. Verification

- [x] 4.1 Run `fvm dart run build_runner build --delete-conflicting-outputs`, then `fvm flutter analyze`.
- [x] 4.2 Run `fvm flutter test` - confirm no new failures beyond known baseline.
- [ ] 4.3 Manual check: UI matches Stitch design visually in general layout and behavior.