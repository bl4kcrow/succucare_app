# Proposal

## Why

The plant edit location is identified by an in-process object, not by its address. `lib/core/routes/app_router.dart` reads `state.extra as Plant`, and the only caller that supplies it is the garden list (`my_garden_home_view.dart` pushes `Routes.editPlant` with `extra: plant`). Any other way into that location — a deep link, an app link, a notification, a navigation stack restored after the process is killed, or a browser URL once web is supported — carries no `extra`, so the cast throws in the route builder. The URL does not name the plant, so the location cannot be re-entered, shared, or reloaded. Every other location in the app is addressable by path; this one is not.

## What Changes

- Make the plant edit location addressable by plant id: the route becomes `/edit-plant/:plantId` and the id is read from the path, replacing the `state.extra as Plant` cast with no value supplied by navigating code.
- Add a single-plant read to the garden data layer (`loadPlantById`) through the datasource, the repository, and a new Riverpod family provider, so a plant can be resolved from an id alone.
- Resolve the plant asynchronously in the edit screen: a thin route-level gate handles loading, failure, and unknown-id states, and the existing editable form is moved behind it so it only builds once a record is available.
- Have the garden list navigate by id (`pathParameters: {'plantId': plant.id}`) so the URL, not the object graph, carries the plant's identity.
- Report an unknown id in the app's existing wording with no editable form and a way back to the garden; report other load failures in the same wording with a retry action.
- Redirect the edit location reached without an id back to the garden, since there is no plant to edit.
- Invalidate the resolved plant after a successful save, so a later visit to the same location shows the saved values.

No breaking change to any existing location's path, and no change to any existing requirement.

## Capabilities

### New Capabilities

- `plant-editing`: Defines the plant edit location as addressable by plant id — how a plant is resolved from that id, and what the location shows when the id names no record, when the record cannot be read, and when the id is absent entirely.

### Modified Capabilities

- None. `auth-routing` already lists edit plant among the guarded locations, and its redirect logic special-cases only splash and locations nested under login, so a path-parameterized edit location is already classified correctly. `user-facing-errors` already mandates mapped wording for a record that does not exist, already forbids presenting technical failure detail, and its rule against adding a retry control is scoped to a failure reported inside a notification — the retry action added here lives in a full-page state, not a notification. No requirement text changes.

## Impact

- `lib/core/routes/app_router.dart` — the edit route gains a `:plantId` path parameter, the `state.extra as Plant` cast is removed, a bare `/edit-plant` route redirects to the garden, and the `Plant` import is no longer needed.
- `lib/features/garden/datasource/plants_datasource.dart` — new `loadPlantById` on `PlantsDatasource`; implemented in `FirestorePlantsDatasource` (existence check, then mapping, with failures wrapped) and `MockPlantsDatasource`.
- `lib/features/garden/repositories/garden_repository.dart` and `lib/features/garden/providers/garden_repository_impl_provider.dart` — new `loadPlantById` on `GardenRepository` plus delegation.
- `lib/features/garden/providers/plant_by_id_provider.dart` — new; an async family provider resolving a plant by id, exported from `providers.dart`.
- `lib/features/garden/screens/edit_plant_screen.dart` — `EditPlantScreen` takes a `plantId` and gates on the resolved record; the existing form becomes a child widget that receives the plant.
- `lib/features/garden/providers/edit_plant_provider.dart` — invalidates the resolved plant after a successful save.
- `lib/features/garden/views/my_garden_home_view.dart` — navigates with a path parameter instead of `extra`.
- `test/features/garden/plant_failure_test.dart` — its recording repository gains `loadPlantById` and the edit screen is constructed by id.
- `test/features/garden/edit_plant_route_test.dart` — new; covers deep-link entry, unknown id, load failure with retry, the id-less location, and garden-list navigation.
- No new dependencies, no Firestore schema or index change, no change to any other route.
