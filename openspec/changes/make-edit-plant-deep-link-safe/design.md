# Design

## Context

See proposal.md for why. The current state that shapes this approach:

- `lib/core/routes/app_router.dart:151` builds the edit route with `EditPlantScreen(plant: state.extra as Plant)`. go_router 18.0.0 is resolved, so `GoRouterState.pathParameters` and a `pathParameters:` argument on `pushNamed` are available. `pathParameters` keys are parameter names without the leading colon.
- `EditPlantScreen` is a `ConsumerStatefulWidget` whose `initState` seeds three `TextEditingController`s from `widget.plant`. It cannot construct a form before a `Plant` exists — this is what forces the gate/form split rather than an inline swap.
- `editPlantProvider` is a `Notifier` family keyed on the whole `Plant` argument (`edit_plant_provider.dart:45`). No editor method mutates `id`, and Freezed gives the value type `==`/`hashCode`, so the family key stays fixed for a given notifier instance even as `state.plant` is edited.
- There is no single-plant read in the data layer. `PlantsDatasource` exposes only paginated collection reads plus create/update. The document path is `users/{uid}/plants/{plantId}`, and `Plant.id` is written from the auto-generated document id (`plants_datasource.dart:78`), so the domain id is the document id.
- `FirestorePlant.fromSnapshot` does an unguarded `snapshot.data() as Map<String, dynamic>` and requires `createdAt`, `updatedAt`, `moisture.updatedAt`, and `illumination.updatedAt` to be non-null. `DocumentReference.get()` on a missing document returns a snapshot with `exists == false` rather than throwing, so the existence check must be explicit and it must precede mapping.
- `AppFailureCode.notFound` already exists ("That record no longer exists.") and `AppFailure.from` already wraps unknown throws. `user-facing-errors` therefore already mandates both the not-found wording and the no-technical-detail rule for whatever this change adds.
- The router's auth `redirect` special-cases only `/splash` and paths starting with `/login/`; everything else requires an authenticated session, so `/edit-plant/:plantId` is already classified as guarded with no redirect change.
- The test baseline is not green: `fvm flutter analyze` reports a `custom_lint` analyzer-plugin warning and an unused `_SecondaryPhotos`, and all three cases in `test/features/succus/home_screen_test.dart` fail against behavior the UI does not implement. Two fakes in `test/features/garden/plant_failure_test.dart` implement the interfaces this change extends.

## Goals / Non-Goals

**Goals:**
- Make the edit location's address the single source of the plant's identity, and delete the `extra` cast.
- Resolve the plant through the existing datasource → repository → Riverpod layering rather than reaching around it.
- Reuse the `user-facing-errors` vocabulary for the new failure states instead of inventing wording.
- Keep the editable form's behavior and its provider unchanged apart from the seed value and one added invalidation.

**Non-Goals:**
- Migrating the router to go_router's generated typed routes. It would give compile-time-typed path parameters and `extra`, but the generated file name collides with riverpod's `app_router.g.dart` part, and the migration touches every route in the app — a separate change.
- Making other locations addressable by resource id. Only the edit location passes an in-process `Plant` today, so only it needs this.
- Serving the edit location over web. `lib/features/garden/datasource/plants_datasource.dart` and the photo grid reach `dart:io`, and the desktop Firebase options throw, so the reachable code does not run on web today.
- Replacing the garden list's non-reactive paginated load, or making the resolved plant reactive to Firestore writes. The saved-edit requirement is met by invalidating on save, not by observing the document.
- Reusing the Firestore document helper introduced for the new read inside the existing create/update methods.

## Decisions

1. **The plant id is a path parameter, not a query parameter.**
   Declare `path: '${Routes.editPlant.value}/:plantId'` and read `state.pathParameters['plantId']`, while `Routes.editPlant.value` stays `/edit-plant` and keeps its current meaning as the location's base path. Rationale: go_router matches the path parameter with a single segment, so no ambiguity with the location's own segments, and a path-parameterized address is what a platform app link, a notification, and a future browser URL all expect. Alternative: `?plantId=` on the existing bare path — fewer router edits, but it leaves the location's identity in the query string, which is the pattern that reads as accidental to anyone arriving at the URL cold.

2. **The new read goes through all three data layers.**
   Add `loadPlantById(String plantId)` to `PlantsDatasource`, `GardenRepository`, and `GardenRespositoryImpl`, plus a new `plantByIdProvider(String plantId)` async family. Rationale: every other plant read in the app goes datasource → repository → provider, and `gardenRepositoryImplProvider` is already the single override seam that `test/features/garden/plant_failure_test.dart` uses. Alternative: resolve the id against the `myGardenProvider` cache — no extra read, but it only holds the pages a user has scrolled, so a deep link to any other plant, or to a plant the list has not loaded at all, would fail. The cache is also invalidated wholesale after a save, which would discard the in-progress edit.

3. **`editPlantProvider` stays keyed on `Plant`.**
   The gate resolves the plant and hands it to the form; the form keeps calling `editPlantProvider(plant)` exactly as today, and `EditPlantState` is untouched. Rationale: the family key is the loaded record, and since no editor method changes `id` and Freezed value equality is structural, the key is stable while the buffer diverges — `reset()` and the save path keep working untouched. Alternative: re-key the family on `plantId` and make the notifier an `AsyncNotifier` that loads the record itself, collapsing two providers into one. Rejected: it changes `EditPlantState`'s construction, forces every mutation method through `state.requireValue`, and churns the three existing `plant_failure_test.dart` cases for no behavioral gain. Noted as latent, not fixed here: a value-typed family argument means a genuinely different loaded record would construct a fresh notifier.

4. **The screen splits into a gate and a form.**
   `EditPlantScreen` becomes a `ConsumerWidget` taking `plantId`, watching `plantByIdProvider(plantId)` and rendering progress, the failure state, or `_EditPlantForm(plant: plant)`. `_EditPlantForm` is the current `_EditPlantScreenState` body, unchanged — the same three controllers seeded in `initState`, the same `addPostFrameCallback` error snackbar, the same `_SaveButton`. Rationale: the form's `initState` dependency is the precise thing that made the location unsafe, and moving the existing stateful body into a child widget resolves it without rewriting the form's logic. Alternative: keep one widget and lazily create the controllers once the plant arrives — that puts mutable, order-sensitive setup behind a `null` check and makes dispose/reset handling conditional, for a smaller file at a real readability cost.

5. **The form is keyed by plant id.**
   `_EditPlantForm` receives `key: ValueKey(plantId)`. Rationale: after a save the gate invalidates `plantByIdProvider(plantId)`, which rebuilds the gate with a newly loaded record. Without a stable key, Flutter would tear down the form's `State` and its controllers, and — if the reloaded record differs from the seeded one — the `editPlantProvider` family key would change too, silently discarding the edit buffer. The key keeps the element alive across that rebuild. Verified safe because invalidation happens only after a successful save, at which point the form is popped and holds no unsaved edits.

6. **The bare location redirects rather than showing an unmatched-route error.**
   Register a second, unnamed `GoRoute` at `Routes.editPlant.value` whose `redirect` returns `Routes.home.value`. Rationale: a redirect is deterministic, testable, and cannot be confused with a bug report; go_router's default error screen is a red screen in a debug build and an unhelpful page in release. The route must stay unnamed because the parameterized sibling already owns `Routes.editPlant.name`.

7. **Not-found and other load failures are different states.**
   Distinguish them on `AppFailure.from(error).code == AppFailureCode.notFound`: not-found shows the mapped message with a back-to-garden action and no retry; every other failure shows the mapped message with a retry action that invalidates the provider. Rationale: retrying a record that does not exist can only fail again, and offering it would train users to tap a button that never works — the retry affordance is the one place this change touches `user-facing-errors`, whose prohibition on adding a retry control is scoped to a failure reported inside a notification, and this is a full-page state. Alternative: one uniform error state — less code, but it cannot offer a useful action in one of its two cases.

8. **Existence is checked before mapping, and mapping failures are wrapped.**
   `loadPlantById` reads the document, throws `AppFailure(AppFailureCode.notFound)` when `!snapshot.exists`, then maps through the existing `FirestorePlant.fromSnapshot` → `PlantMapper` path, wrapping any other throw with `AppFailure.from` and logging via `debugPrint` like the sibling methods. Rationale: the unchecked `snapshot.data() as Map<String, dynamic>` would throw a cast error on a missing document, and a legacy document missing one of the four required timestamps would throw a null-assignment error that `AppFailure.from` maps to the generic wording — which is what `user-facing-errors` requires for an unrecognized cause.

## Risks / Trade-offs

- One extra Firestore read per entry into the edit location, even when the list already holds the plant → Mitigation: accepted; it is the cost of an address that is self-sufficient, the read is a single-document get, and the family provider caches the result for the location's lifetime so re-entering the same id within a session does not refetch.
- Reusing the list cache would have avoided the read but cannot serve an arbitrary id → Mitigation: not adopted; see Decision 2.
- A document missing `createdAt`, `updatedAt`, or a nested `updatedAt` fails to map and surfaces the generic wording → Mitigation: wrapped by Decision 8 rather than crashing; the wording is what `user-facing-errors` already prescribes, and the retry action lets the user re-attempt if the write that failed was transient.
- Invalidating `plantByIdProvider` after a save re-keys `editPlantProvider` if the reloaded record differs from the seeded one, which would drop the buffer → Mitigation: Decision 5's `ValueKey`, plus invalidation only on the success path immediately before `context.pop()`.
- `_EditPlantForm` inherits the pre-existing `addPostFrameCallback`-inside-`build` error snackbar → Mitigation: left unchanged to keep this change's diff to routing and resolution; it is safe today because `clearError()` runs in the same frame, and it is worth a separate change.
- `_EditPlantScreenState`'s listeners call `ref.read(...notifier)` after disposal is not guarded → Mitigation: out of scope; unchanged behavior.
- Adding an abstract method to `PlantsDatasource` and `GardenRepository` breaks every implementer → Mitigation: `MockPlantsDatasource` and `RecordingGardenRepository` are updated in the same change, and `fvm flutter analyze` names any implementer missed.
- The `dart:io` imports in reachable garden code mean the location still cannot actually be served over a browser URL → Mitigation: stated as a Non-Goal; this change makes the location addressable, which is a precondition for serving it, not a claim that it is served.

## Migration Plan

No data, schema, or index change; no dependency change. Rollout is a single branch touching routing, the data layer, one new provider, one screen, and two test files; `fvm dart run build_runner build --delete-conflicting-outputs` regenerates `plant_by_id_provider.g.dart` and refreshes the `providers.dart` export graph. Rollback is reverting those files — the previous `extra`-based route is self-contained, so there is nothing to unwind in Firestore and no partially-migrated state. `openspec archive` will add `plant-editing` to the main spec set; no existing spec file changes.

## Open Questions

None.
