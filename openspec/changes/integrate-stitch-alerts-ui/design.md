# Design

## Context

See proposal.md for motivation. Current state:
- `lib/features/notifications/ui/views/alerts_view.dart` is a minimal placeholder `Scaffold(body: Center(child: Text('Alerts View')))`
- `lib/features/notifications/ui/providers/alerts_provider.dart` provides `AlertsNotifier` that builds `NotificationsState` (status + notifications list), subscribes to repository streams (foreground/background) to append messages newest-first, and has `configureMessageHandlers()` called from `main.dart`
- `AppNotification` model has `messageId`, `title`, `body`, `sentDate`, optional `data` (Map), optional `imageUrl`
- Stitch design is in `openspec/changes/integrate-stitch-alerts-ui/stitch-assets/alerts_y_cuidados.html` with Spanish UI showing notification cards, filters, actions, empty state

The existing provider/state already handles receiving messages and storing them; we need to extend the UI and possibly add actions/filtering to the provider.

## Goals / Non-Goals

**Goals:**
- Implement the Stitch UI in Flutter while preserving existing Riverpod architecture
- Display notifications from `alertsProvider` with filtering (All/Unread), actions (mark as read, dismiss, mark all, clear read)
- Map Stitch visual elements to the existing app theme where possible
- Keep changes minimal and follow existing code patterns

**Non-Goals:**
- Changing the core notification behavior (already handled by add-push-notifications)
- Adding backend/FCM sending logic
- Major theme refactoring - reuse existing theme

## Decisions

### D1. UI Structure
Use `ConsumerWidget` watching `alertsProvider` (AsyncValue<NotificationsState>). Build UI with Material widgets styled to match Stitch (cards, chips, action buttons). Translate Tailwind classes to Flutter styling.

### D2. State Extensions
Add filtering state and action methods to `AlertsNotifier`: track `filter` (all/unread), methods `markAsRead(String messageId)`, `dismiss(String messageId)`, `markAllAsRead()`, `clearRead()`. This keeps UI stateless and logic in provider.

### D3. Timestamp Formatting
Add relative time formatting for `sentDate` (e.g., "Hace 25 min", "Hace 2h") matching Spanish from Stitch design.

### D4. Data Extraction
For plant image, use `AppNotification.imageUrl` directly. If the image is missing, place a placeholder image. For humidity/category, extract `moistureLevel` from `AppNotification.data` with possible values [Low, Medium, High]. Map these to appropriate display text, colors, and progress bar widths for the UI.

### D5. Styling
Leverage existing app colors from theme. Map Stitch's tertiary/primary colors conceptually to existing theme values for consistency.

## Risks / Trade-offs

- [Translation/formatting] → Need to handle Spanish relative time strings carefully
- [Data mapping] → Notification payload structure varies; make extraction defensive
- [UI complexity] → Keep implementation focused on the core list UI first

## Migration Plan

No migration needed - UI-only change. Existing notifications continue to work.