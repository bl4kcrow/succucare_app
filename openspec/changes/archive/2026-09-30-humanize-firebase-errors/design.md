# Design

## Context

Every surface that reports a failure does it the same way today: catch, then hand the caught
object's `toString()` to a notification. `login_screen.dart:132`, `forgot_password_screen.dart:64`
and `settings_screen.dart:33` pass `error.toString()` into `CustomSnackBarContent`;
`add_plant_provider.dart:239` and `edit_plant_provider.dart:220` store `error.toString()` in a
state field that the corresponding screen renders. The Firebase calls themselves are wrapped in
`debugPrint`-and-rethrow blocks in `firebase_auth_service.dart`, so the raw exception propagates
through the repository and controller layers untouched. The garden datasources
(`plants_datasource.dart`, `plant_photo_datasource.dart`) do not catch at all.

Two constraints shape the approach. The `AuthService`, `AuthRepository`, `PlantsDatasource` and
`PlantPhotoDatasource` interfaces are implemented by hand-written fakes in
`test/features/auth/*_test.dart`, so their signatures must not change. And the two garden
notifications are deliberately styled differently from the three auth notifications —
`Text` on a solid colour versus `CustomSnackBarContent` — so the styling is not incidental and
must survive. See proposal.md for the motivation and the spec delta for the required behaviour.

## Goals / Non-Goals

**Goals:**
- Make it structurally impossible for a raw backend failure string to reach a user-facing surface.
- Produce the mapping once, at the layer that already owns the Firebase call, rather than at each
  of the five display sites.
- Keep the existing interfaces and the existing notification styling intact.

**Non-Goals:**
- Changing the styling, duration, or positioning of any notification.
- Adding a retry control, an error log screen, or a copy of the failure in the UI.
- Localising the message copy.
- Touching the three surfaces excluded in the proposal: the garden list's inline `Error: $err`
  branch, the account creation screen's missing error handling, and the unguarded image picker
  call.

## Decisions

1. **A domain failure type in `lib/core/errors/`, not in a feature.**
   `AppFailure` carries an `AppFailureCode` whose values hold the user-facing string, plus the
   originating `code` and `Object? cause` for diagnostics. It lives in `core` because two features
   need it and `core` is already the shared home for cross-feature code (`theme`, `utils`,
   `routes`). Putting it under `features/auth` would force `features/garden` to import from
   `features/auth`; putting it in `core/utils` next to `CustomSnackBarContent` would file a
   non-UI concern in a UI grab-bag. A barrel `errors.dart` matches the existing per-folder barrel
   convention.

2. **Services and datasources produce the failure; the UI only displays it.**
   `FirebaseAuthService` and the two garden datasources convert at the Firebase boundary, so no
   layer above them sees a `FirebaseAuthException` or `FirebaseException`. Rationale: the mapping
   becomes part of the contract these layers already own, and adding a new call site later cannot
   forget to map. The alternative — a shared helper invoked at each of the five `catch` blocks —
   is a smaller diff and was considered, but it leaves the service layer logging and rethrowing
   platform exceptions, keeps the failure taxonomy untyped, and makes "did we map this?" a
   per-call-site question instead of a per-implementation one.

3. **The failure's `toString()` returns the user-facing message.**
   Not the code, and never the cause. This is the backstop: any string interpolation of a failure
   anywhere in the app yields readable copy, so a future `Text('Error: $err')` cannot reintroduce
   the bug. Returning the code name was considered and rejected — the garden list's inline error
   branch is out of scope to change, and a code name would render there as a bare identifier.
   Returning the user message improves that branch incidentally, from
   `Error: Exception: [cloud_firestore/permission-denied] ...` to `Error: You don't have access to
   that.`, at no cost. `code` and `cause` remain public fields, so nothing is lost for logging.

4. **A normalizer for errors that are not already a domain failure.**
   `AppFailure.from(Object error)` returns the error unchanged when it is already an
   `AppFailure`, and otherwise maps it. Catch sites use it so that a plain `Exception` from a test
   fake, or from any future non-Firebase producer, still produces a safe message. This is
   required, not defensive: the existing test fakes throw `StateError` and `Exception`, and those
   tests must keep passing unchanged.

5. **Provider state carries the failure, not a pre-formatted string.**
   `NewPlantState.errorMessage` and `EditPlantState.errorMessage` become `AppFailure?`. Both are
   hand-written classes with hand-written `copyWith`, so no codegen is involved. This also absorbs
   the local validation literal `'Please fill all the fields'` (currently `add_plant_provider.dart:185`
   and `edit_plant_provider.dart:169`) as a validation code on the same type, so validation and
   backend failure copy live in one place. Keeping `String?` and storing `failure.userMessage` at
   the catch site was considered and rejected: it discards the type and re-serialises at the edge,
   which is exactly the pattern that produced this bug.

6. **No shared notification helper.**
   The mapping is applied where the message is built; each call site keeps its existing
   `SnackBar` configuration verbatim. A `showErrorSnackBar(context, error)` helper that also
   normalised the notification configuration was considered — it would have collapsed five
   copy-pasted blocks and resolved the styling inconsistency between the two features — but that
   is a visual change nobody asked for, and it would convert a copy change into a restyle. If the
   styling is ever unified, that is a separate change.

7. **Mapping keys on the error `code` only, never on the error `message`.**
   Firebase's `message` is human-readable but varies by platform, is not localised, and routinely
   embeds identifiers. The `code` is a stable contract. Storage failures arrive on
   `FirebaseException.code` with a `storage/` prefix (for example `storage/object-not-found`) and
   need their own table; Firestore and Auth codes are unprefixed. The Auth table also carries the
   legacy `wrong-password` and `user-not-found` codes alongside the current `invalid-credential`
   and `invalid-login-credentials`, because older Auth responses and the emulator still emit them.

8. **The four credential codes collapse to one message.**
   `user-not-found`, `wrong-password`, `invalid-credential` and `invalid-login-credentials` all
   mean the same thing to a user: those two fields did not work. Splitting them would tell an
   attacker which half of a credential to keep guessing. This extends to sign-in the same posture
   the `password-reset` spec already takes for account existence.

9. **Copy is inline English on the code enum, with no localisation.**
   The app has no `flutter_localizations` or `l10n.yaml`; every other user-facing string is an
   inline literal. Localising just this copy would be inconsistent. Because the strings are
   properties of an enum rather than scattered across five call sites, adopting l10n later is a
   mechanical move of one file.

10. **The auth service is converted wholesale, including call sites with no consumer yet.**
    `signUpWithEmailAndPassword` and `deleteAccount` are converted even though the account
    creation screen (which has no `catch` at all) and the delete-account path are out of scope.
    Rationale: a partially converted service is the failure mode this change exists to remove, and
    the unhandled throw in the sign-up callback is equally unhandled before and after — an
    `AppFailure` reaching an empty `catch`-less callback is not a regression. Converting the
    producer now means the screen only needs a `catch` when it is eventually given error handling.

## Risks / Trade-offs

- **A Firebase code is emitted that the table does not cover** → The generic message is the
  designed behaviour, not a defect, so the failure mode is a less specific message rather than a
  leak. The table is a single switch per source and is trivial to extend. Pinned by a spec
  scenario so a fallback regression is caught.
- **A broad `catch` at the Firebase boundary also catches programming errors** → A `TypeError`
  inside a service would reach the user as the generic message, hiding a bug. Mitigation: keep the
  `debugPrint` of the original error at every conversion site so the cause is never lost, and let
  the `cause` field carry it on the failure.
- **Overriding `toString()` may surprise code that stringifies a failure for a non-UI purpose** →
  Only one call site in the app stringifies a failure, and it improves as a result. `code` and
  `cause` stay available for anything that needs machine-readable detail.
- **Pinning the exact message copy in the spec makes copy changes a spec change** → Deliberate: the
  wording is the observable behaviour, so changing it should go through a delta rather than
  silently. Reviewed as part of this change's approval.
- **Changing the two garden state field types ripples to their screens** → Contained to two
  notifiers and two screens, all already in scope for the text change.
- **Wrapping the datasources changes what the out-of-scope garden list error branch prints** →
  Accepted as an improvement rather than a regression, and recorded here because it is a
  behavioural effect outside the stated scope. If it must be held constant, decision 3 is the one
  to revisit.
- **`openspec/specs/` copy drift on archive** → Archiving writes the `user-facing-errors`
  capability into the main spec set; no other capability changes because none of the existing
  requirements govern message text.

## Migration Plan

No data, schema, or dependency change. No codegen is expected: `NewPlantState` and `EditPlantState`
are hand-written rather than generated, and no `freezed`, `json_serializable`, or `riverpod`
annotation changes, so `build_runner` output is unaffected. Rollout is a single change across the
files listed in the proposal; rollback is reverting them. Verification follows the repository
order in `AGENTS.md` — `fvm flutter analyze` then `fvm flutter test` — holding the documented
baseline constant: the `custom_lint` analyzer-plugin warning, the unused `_SecondaryPhotos`, and
the three pre-existing `test/features/succus/home_screen_test.dart` failures. One existing
assertion changes on purpose: `forgot_password_screen_test.dart:170` currently expects the raw
`Exception: network unavailable` text.

## Open Questions

None.
