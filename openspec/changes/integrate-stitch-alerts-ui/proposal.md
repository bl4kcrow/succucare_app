# Proposal

## Why

The alerts UI is currently a placeholder with only basic structure. The Stitch design ("Alertas y Cuidados" / Generating Screen for project "Gemini Succulent Care", ID: 9972045339050982750, screen ID: 6d18a5cd9866487ea4acbf566f371989) provides a more polished, complete UI with Spanish text, notification cards showing plant images, water drop indicators, humidity levels/progress bars, action buttons ("Registrar Riego", "Marcar como leída", "Descartar"), filter chips, unread badges, empty state, and other UX elements that better align with the app's succulent care theme. Integrating this design into `AlertsView` while keeping the existing Riverpod-based notification state (using `AppNotification` model and the current alerts provider) will deliver a better user experience.

## What Changes

- Replace the current minimal `AlertsView` implementation with the UI derived from the Stitch design
- Update the alerts view to consume from `alertsProvider` (`AlertsNotifier`) and display notifications based on `AppNotification` model (title, body, sentDate) with the visual treatment from Stitch
- Add support for filtering (All/Unread) and actions (mark as read, dismiss, mark all, clear read) consistent with the Stitch design, implemented as operations on the provider/state
- Show plant image if present in `AppNotification.data` or `imageUrl` (Stitch shows plant thumbnails with water drop overlays for watering alerts)
- Show unread indicators, timestamps (relative), humidity level bars and text based on notification data
- Add empty state when no notifications exist
- Preserve the existing navigation structure (Alerts tab in bottom nav, same route)
- Use existing app theme/colors/fonts consistent with the project (or map Stitch color tokens to existing theme where appropriate)
- Maintain existing permission/request handling and message handling already wired through the provider

## Capabilities

### New Capabilities

None - no new spec capabilities being introduced. This is purely a UI integration on top of existing notification behavior.

### Modified Capabilities

None - the core notification behavior (receiving messages, permission lifecycle, session-scoped inbox) is already defined by the existing `add-push-notifications` change/specs (notifications capability). This change only updates the presentation layer of the alerts UI. No spec-level requirement changes.

## Impact

- `lib/features/notifications/ui/views/alerts_view.dart` - major UI rewrite to match Stitch design
- `lib/features/notifications/ui/providers/alerts_provider.dart` - may add helper methods for actions (mark read, dismiss, mark all read, clear read) and filtering state if not currently present
- `lib/core/theme/app_theme.dart` - potential minor additions if Stitch-specific styles needed (icons, colors)
- Assets - may add any local images referenced by the design if needed (the Stitch HTML references remote images; we should preserve existing behavior or map appropriately)

The Stitch assets are saved under `openspec/changes/integrate-stitch-alerts-ui/stitch-assets/` for reference during implementation.