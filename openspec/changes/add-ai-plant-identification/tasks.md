# Tasks

## 1. Dependencies and configuration

- [x] 1.1 Add `firebase_ai` and `firebase_app_check` to `pubspec.yaml` and verify `fvm flutter pub get`
  resolves them against the existing `firebase_core` major without conflict
- [x] 1.2 Add `AI_PROVIDER` and `AI_MODEL` to `.env.template` and verify the template still lists all
  sixteen keys
- [x] 1.3 Add optional-default getters for `AI_PROVIDER` and `AI_MODEL` to
  `lib/core/constants/environment.dart` that return `null` when the key is absent, and verify the app
  still starts with an unmodified `.env` by running `fvm flutter analyze` and confirming no existing
  `dotenv.get` call was changed
- [x] 1.4 Record the console-side prerequisites for this feature: AI Logic enabled on the dev project
  and App Check registered with a debug provider, as a note in the change directory, and verify the
  note names both steps

## 2. Identification port and result types

- [x] 2.1 Define `PlantIdentificationService`, `PlantIdentification` (five nullable fields) and
  `PlantPhotoInput` (bytes plus MIME type) in a new file under `lib/features/garden/services/`, export
  them from `lib/features/garden/services/services.dart`, and verify `fvm flutter analyze` reports no
  errors
- [x] 2.2 Add a pure mapper from model strings to `Category` and `LightLevel` that returns `null` when
  nothing matches and rejects a watering interval that is not a positive whole number within the range
  the form accepts, and verify a unit test in
  `test/features/garden/plant_identification_mapper_test.dart` covers a match, an out-of-vocabulary
  category, a null result, a zero and a negative interval, and an interval above the ceiling
- [x] 2.3 Add a MIME-type resolver that derives the type from the file extension and falls back to
  `image/jpeg`, and verify a unit test covers `jpg`, `png`, `heic` and an unknown extension

## 3. Firebase AI Logic implementation

- [x] 3.1 Build the object response schema for the five permitted fields with the enum-constrained
  category and light level as string enumerations, and verify it is constructed in one place behind the
  model's construction
- [x] 3.2 Compose the identification prompt naming the five fields, instructing the model to omit a
  field it is not confident about rather than guess, and instructing it to return only values the form
  can store
- [x] 3.3 Implement the backend against the port: construct the model from `AI_MODEL` with the schema
  generation config, send the photo as an `InlineDataPart` inside `Content.multi`, read the response,
  and map it through the pure mapper
- [x] 3.4 Verify with a fake model handle that a well-formed response yields a `PlantIdentification`
  with all five values, that a response omitting fields yields nulls for them, and that a response
  whose values are all out of vocabulary yields an empty `PlantIdentification` rather than an error

## 4. Backend selection and the unavailable backend

- [x] 4.1 Implement `UnavailablePlantIdentificationService`, which fails with the identification
  unavailable cause and never performs any work, and verify a unit test asserts that failure and that it
  does not throw
- [x] 4.2 Add the `@riverpod` selection provider that returns the Firebase implementation for
  `AI_PROVIDER=firebase_ai` and the unavailable implementation for every other value including an
  absent one, run `fvm dart run build_runner build --delete-conflicting-outputs`, and verify the
  generated file is committed and that overriding the provider in a `ProviderContainer` replaces the
  backend
- [x] 4.3 Verify with a provider test that no file outside the Firebase implementation imports
  `package:firebase_ai`, so the add-plant flow cannot depend on a named backend

## 5. Identification failure causes and wording

- [x] 5.1 Add the four new `AppFailureCode` values with the wording from the `user-facing-errors` delta:
  no source configured, photo too large to identify, rate limit or quota exhausted, and no usable
  identification returned
- [x] 5.2 Map the AI SDK's exception type and the relevant rate, quota and permission codes inside
  `FirebaseAiPlantIdentificationService`, so that only that file imports `package:firebase_ai` and
  `mapFirebaseErrorCode` stays backend-agnostic, and verify a test drives each row through the real
  service with a fake model handle
- [x] 5.3 Convert unmapped throws from the backend with `AppFailure.from` and `debugPrint` the cause
  before each throw, matching the existing garden datasources, and verify a test asserts the retained
  cause is present in developer output and absent from the user-facing message
- [x] 5.4 Verify each new code's wording is unique against the existing sixteen and that
  `test/core/errors/app_failure_test.dart` still passes

## 6. Identification state on the add-plant flow

- [x] 6.1 Add an `IdentificationStatus` and an identification request to `NewPlantState`, including the
  `copyWith` and `clearIdentification` handling needed to reset it, and verify a state-level test covers
  each transition and that `reset()` returns the state to idle
- [x] 6.2 Implement `identify()` on the add-plant notifier: read `state.selectedImages.first`, return
  early when no photo is attached, read the bytes and fail with the too-large cause before exceeding
  the guard, set the in-progress status, call the port through the provider, apply the result, and
  `debugPrint` on failure — and verify a notifier test with a fake backend asserts the early return
  makes no call, the oversize failure makes no call, and a successful result is applied
- [x] 6.3 Implement `applyIdentification()` by invoking the existing setters for each non-null value,
  guarded, and verify a test asserts that a result with nulls leaves those fields untouched, that a
  result with values changes them, and that `searchKeywords` and `lightingChange` are recomputed
  consistently with the proposed names and light levels
- [x] 6.4 Verify a second successful identification replaces the first, that a failure leaves existing
  field values unchanged, and that `submitPlant` behaviour and its validation are unchanged

## 7. Identification in the add-plant screen

- [x] 7.1 Add the identification action to `PhotoUploadGrid`, shown only when a photo is attached and
  disabled while a request is in progress, and verify a widget test finds the action with a photo and
  finds none without one
- [x] 7.2 Add a progress indication while a request is in progress and verify a widget test with a
  slow fake backend finds it and that the action is not tappable
- [x] 7.3 Report each identification failure through the screen's existing post-frame-callback
  `SnackBar` path using the failure's own wording with no new control and no styling change, and
  verify a widget test asserts the wording for the unavailable cause, the too-large cause, the rate
  limit cause and the no-usable-result cause
- [x] 7.4 Verify the identification card presents proposed names and category in its ordinary editable
  fields, that a value the user edits after a proposal is the value shown, that clearing a proposed
  value stays cleared, and that the last-watered date, moisture, health status and notes hold only what
  the user entered
- [x] 7.5 Verify submitting after a proposal without the un-proposed values still refuses to save with
  the existing incomplete-input wording and writes nothing, that supplying them saves with the
  proposed identity, and that adding a plant without ever requesting identification behaves as before

## 8. Integration checks

- [x] 8.1 Run `fvm flutter analyze` and verify the only findings are the pre-existing
  `custom_lint` analyzer-plugin warning and any other baseline finding recorded in `AGENTS.md`
- [x] 8.2 Run `fvm flutter test` and verify the only failures are the three pre-existing failures in
  `test/features/succus/home_screen_test.dart`, which `AGENTS.md` records as a non-green baseline
- [ ] 8.3 On a device with the dev project, verify end to end that a photo attached to a new plant
  yields a proposal in the editable fields, that saving produces a stored plant identical to one typed
  by hand with no identification field present, and that an oversized photo reports the too-large
  wording
- [ ] 8.4 Verify with `AI_PROVIDER` unset that the app starts, the identification action reports that
  identification is unavailable, and a plant can still be added entirely by hand
