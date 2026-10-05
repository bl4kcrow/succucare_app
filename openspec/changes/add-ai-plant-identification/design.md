# Design

## Context

See `proposal.md` for motivation and `specs/` for the required behaviour. The state that shapes the
approach:

- Adding a plant runs `AddPlantScreen` (`lib/features/garden/screens/add_plant_screen.dart`) against
  `addPlantProvider` (`lib/features/garden/providers/add_plant_provider.dart`). The screen owns three
  `TextEditingController`s and mirrors them into the notifier with `addListener`; every card is a
  callback-driven widget writing through a setter on that notifier. There is no `Form`, no
  `FormState`, and no per-field validation — `validate()` is a single boolean producing one generic
  message.
- Photos arrive as `dart:io` `File` objects from `image_picker` inside `PhotoUploadGrid`, whose
  callback is `ValueChanged<File>`. The bytes are never read anywhere in the app, and `pickImage` is
  called with no size arguments, so the original full-resolution file is what would be sent.
- Identification must therefore introduce the app's first read of image bytes.
- The feature is layered datasource → repository → `@riverpod` provider → UI, with thin pass-through
  repositories. Interfaces live beside their provider files and impls share the provider's file.
- `Plant` (`lib/features/garden/models/plant.dart:77`) has no defaults and no `@JsonKey` defaults, and
  `PlantMapper` maps both directions by hand, exhaustively. Any field added to `Plant` forces edits to
  `NewPlantState`, `FirestorePlant`, both mapper directions, and `MockPlantsDatasource`'s four fixtures.
- `AppFailureCode` values carry their own user wording and `mapFirebaseErrorCode` dispatches on
  exception type. Garden screens report failures with a plain floating `SnackBar` coloured
  `AppColors.frenchRaspberry`, and schedule the read in a post-frame callback then `clearError()`.
- `Environment` (`lib/core/constants/environment.dart`) uses `dotenv.get` for all fourteen keys, which
  throws when a key is absent, and `Environment.dev()` is the only entry point actually called.
- `analysis_options.yaml` excludes platform folders, suppresses `invalid_annotation_target`, and does
  not include `flutter_lints` or wire `riverpod_lint`, so the effective rule set is the Dart defaults.
  Generated `.g.dart` files are checked in and must be regenerated with `build_runner`, not edited.

## Goals / Non-Goals

**Goals:**

- A single seam through which the add flow asks for identification, with the backend chosen by
  configuration and swappable without touching the flow.
- A proposal that can only ever write to the fields it is allowed to write, through the notifier
  setters that already exist, so validation, derived fields and reset behaviour keep working unchanged.
- Testability without a network: every test overrides the port provider.
- No growth in the stored plant model.

**Non-Goals:**

- Filling anything beyond the five permitted values. Last-watered date, moisture level and source,
  health status and notes stay manual.
- Recording provenance, confidence, model name or prompt version on the plant.
- Reusing identification on the plant edit flow, or anywhere outside the add flow.
- Filling in the `PlantScanView` stub or routing a scan result anywhere. The Scan tab keeps its
  current placeholder behaviour.
- Downscaling photos at pick time. See decision 7.
- Changing photo upload, garden paging, the storage path convention, or any existing wording.

## Decisions

### 1. A port with an absent-value result object

`PlantIdentificationService` is an abstract interface with one method taking the attached photo and
returning a `PlantIdentification` value whose five fields are all nullable:

```dart
abstract interface class PlantIdentificationService {
  Future<PlantIdentification> identify(PlantPhotoInput photo);
}
```

**Why nullable fields rather than a non-null result plus a validity flag.** "No proposal for this
field" and "propose the empty string" must not be confusable, and the spec requires an unusable value
to be omitted while the others are still presented. Nullable fields make absence the only representation
of omission, so `PlantIdentification` needs no `hasX` accessors and the applier is a sequence of null
checks. **Alternative considered:** a non-null result with an `isRecognized` flag — rejected, because
every consumer then has to interpret the flag alongside the values, and a recognised-but-empty result
becomes a state the code can still misuse.

**Why the photo crosses the port as bytes plus a MIME type, not as a `File`.** The port is the seam
that is meant to outlive Firebase; a backend that wants a URI, a Storage path, or a
`CameraController`-owned buffer should not have to accept `dart:io` because the first backend happened
to. `PlantPhotoInput` carries `Uint8List bytes` and `String mimeType`. Reading the file therefore
happens once, in the provider that composes the impls, not inside a backend. **Alternative
considered:** pass `File` and let each backend read it — rejected, because it puts an I/O dependency in
the signature of a port meant to be substitutable by something that may not have a local filesystem.

**Why a dedicated result type instead of reusing `Plant`.** `Plant` has no defaults, so a partial
answer cannot be expressed as one, and mapping a partial answer onto it would mean the notifier had to
distinguish "propose blank" from "do not touch".

### 2. Backend selection is a provider switch on configuration

`@riverpod PlantIdentificationService plantIdentificationService(Ref ref)` reads
`AI_PROVIDER` and returns `FirebaseAiPlantIdentificationService` for `firebase_ai`, or
`UnavailablePlantIdentificationService` for anything else, including an absent value. The model name
comes from `AI_MODEL`, defaulting to `gemini-3.7-flash`.

**Why a switch and not a registry.** There are two implementations and no third is in scope. A
map-based registry adds a lookup indirection and an ordering question for a list of length two. The
switch is one `switch` expression and reads top to bottom; promoting it to a registry later is a local
edit. **Alternative considered:** resolving the backend by a class-name string in `Environment` —
rejected, because it makes a configuration typo a runtime construction failure instead of an
unavailable backend, which is the failure mode the spec explicitly requires to be graceful.

**Why `AI_PROVIDER` is read with an optional default.** `Environment`'s fourteen existing keys use
`dotenv.get`, which throws when absent. That is deliberate for the Firebase keys, which have no
sensible fallback. `AI_PROVIDER` does: absent means unavailable. Using `dotenv.get` for it would make
every existing `.env` in every checkout fail to start the app the moment this lands. The two new keys
therefore get a getter that returns `null` when the key is missing, matching how `Environment` will
eventually need to treat any non-Firebase key.

### 3. The Firebase backend uses a schema-constrained response

`FirebaseAI.googleAI(auth: FirebaseAuth.instance).generativeModel(model: model, generationConfig:
GenerationConfig(responseMimeType: 'application/json', responseSchema: <object schema>))`, with the
photo as `InlineDataPart(mimeType, bytes)` inside `Content.multi([prompt, imagePart])`.

**Why a response schema rather than prompt-and-parse.** A schema makes the five permitted fields the
only fields that can come back, which is what the spec's bounded-proposal requirement needs from the
transport. It also removes hand-written JSON extraction and the failure mode where a model returns
prose around the JSON. **Alternative considered:** a strict instruction to return JSON only, parsed
with `jsonDecode` — rejected, because the parser would then carry the burden of the model wandering,
and a malformed body would surface as a decoding exception rather than a recognised cause.

**Why `googleAI` (Gemini Developer API) rather than the Vertex AI Gemini API.** `googleAI` has a
no-cost tier, which is what makes this usable against the development project without a Blaze plan.
**Alternative considered:** Vertex AI for production governance — deferred, not because it is wrong but
because switching later is the change this seam exists to make cheap.

**Why `gemini-3.7-flash` as the default.** Stable release stage, and a Flash model rather than Pro
because identification from a single photo with a constrained output schema is a small, latency-
sensitive task that runs on every photo the user attaches.

### 4. Reading the bytes, and the size guard, happen before the port is called

The notifier's `identify()` reads `state.selectedImages.first` into a `Uint8List`, checks it against a
maximum accepted size, and fails with the too-large cause before constructing `PlantPhotoInput`.

**Why the guard sits at the notifier rather than in the backend.** Inline file data is base64 in
transit, which inflates the request by roughly a third against the API's total request size cap. That
is a property of the transport, not of Firebase, so a backend that reads from a URI would not have the
constraint — but the check is still worth doing in one place for every backend, and doing it before
reading avoids allocating a multi-megabyte buffer we will only discard. **Alternative considered:**
guard inside the Firebase backend — rejected, because it would make the limit invisible to the other
implementation and to the tests that exercise the notifier.

### 5. Enum decoding is a pure, total, null-returning mapper

A small mapper turns the model's strings into `Category` and `LightLevel` by searching `values` and
returning `null` when nothing matches, and rejects a watering interval that is not a positive whole
number within the range the form accepts. It lives beside the port, not inside the Firebase backend, so
it is unit-testable without `firebase_ai`.

**Why it returns `null` instead of throwing.** `PlantMapper.firestorePlantToPlant` uses
`values.firstWhere((e) => e.name == ...)` with no fallback and throws `StateError` on an unknown
value. That is correct for reading stored data, where an unknown value is a corrupt record. Here an
unknown value is an ordinary model output that the spec requires be silently omitted, so throwing would
turn every out-of-vocabulary answer into a failure the user has to dismiss.

**Why the watering interval is bounded by the form's range.** `MoistureWateringCard` parses the field
to an `int`, and an unbounded model answer would put a value in the field that the user then has to
notice and correct. Omitting it leaves the field as the user left it.

### 6. Identification state lives on the existing add-plant notifier

`NewPlantState` gains an `IdentificationStatus` (`idle`, `inProgress`, `completed`) alongside the
existing `errorMessage`, plus the notifier gains `identify()` and `applyIdentification()`. `identify()`
calls the port through `ref.read(plantIdentificationServiceProvider)`; `applyIdentification()` invokes
the existing setters — `setCommonName`, `setScientificName`, `toggleCategory`, `setWateringIntervalDays`,
`setCurrentIllumination` and `setTargetIllumination` — guarded on non-null.

**Why the existing setters rather than a `copyWith` onto `state.plant`.** `submitPlant` recomputes
`lightingChange` and `searchKeywords` from the state's fields at save time
(`add_plant_provider.dart:202-215`). Routing the proposal through the setters keeps that derivation in
one place, so a proposal cannot produce a plant whose `searchKeywords` or `lightingChange` disagree
with its names or light levels. **Alternative considered:** a new `applyProposal` notifier method that
builds a modified `Plant` and assigns it to `state` — rejected, because it would need to duplicate the
derivation to stay consistent.

**Why `inProgress` is separate from `errorMessage`.** The screen needs to distinguish "not requested",
"requested and waiting", and "requested and failed" to decide whether to show a spinner, and the
existing error channel already means failure. Collapsing them would make the spinner conditional on a
nullable `AppFailure` being null, which is not the same as idle.

**Known consequence, accepted:** `AddPlantNotifier` is `autoDispose`, so a proposal is lost if the user
navigates away from the add screen before saving. This matches the existing behaviour of every other
in-progress edit in that form and is not worth diverging from here.

### 7. Pick-time downscaling is left out

`pickImage` keeps its current arguments, so the app continues uploading whatever
full-resolution file it picked. The identification path is protected by the size guard in decision 4
rather than by making every photo smaller.

**Why.** Adding `maxWidth`/`imageQuality` would silently change every photo uploaded to Storage for
every user, including existing upload behaviour, and would need its own verification against the
garden list rendering. That is a separate change with a different risk profile. **Alternative
considered:** add the image package and downscale only the copy sent for identification — rejected for
now, since it adds a native dependency and a decode step for a case the size guard already handles
defensibly.

### 8. Failures reuse the existing failure model and reporting surface

Four new `AppFailureCode` values carry their own user wording, matching how the other sixteen do.
The AI SDK's exception type and its rate, quota and permission codes are translated inside
`FirebaseAiPlantIdentificationService`; unmapped throws inside the backend become
`AppFailure.from(error)`. Each throw site `debugPrint`s before throwing, as the garden datasources
already do. Reporting stays the plain floating `SnackBar` in the add-plant screen's existing
post-frame-callback path, with no new control and no styling change.

**Why the AI SDK mapping is not in `mapFirebaseErrorCode`.** That mapper is the shared, backend-agnostic
translation used by the auth and storage datasources, and it cannot name `FirebaseAIException` without
importing `package:firebase_ai`. Putting the branch there would leak a named backend into shared code and
break the boundary the add-plant flow depends on. The translation is therefore private to the one file
that is allowed to import the SDK, and it produces the same `AppFailure` codes the mapper would have.

**Why the wording table rather than reusing existing codes.** "Storage is full. Free up space." for a
rate limit, or "That information isn't valid." for a photo that is simply too large, would be wrong
enough to send the user looking in the wrong place. The `user-facing-errors` delta extends the one
table that already governs this, so the wording stays in a single place.

## Risks / Trade-offs

- **App Check enforcement blocks identification in the running app.** The AI Logic workflow enforces
  App Check, and the plugin is added with a debug provider configured for local development. A device
  build without the debug provider registered will get every request rejected, and the user will see
  "Service is busy. Try again." → Mitigation: console-side enablement is tracked as a prerequisite in
  `tasks.md`, and the failure maps to an already-recognised cause so the app degrades to a working
  manual form rather than breaking.
- **The free-tier quota is per Firebase project and shared with anything else using it.** Rapid
  repeated identification by several users will exhaust it → Mitigation: the rate-limit cause has its
  own wording suggesting a later retry, distinct from the generic busy message.
- **A mis-specified proposal can be silently wrong and the user may not notice.** Category has only
  three values and the model may map an unusual succulent onto the nearest one; scientific names can be
  hallucinated → Mitigation: the spec requires every proposal land in an ordinary editable field the
  user must pass through before saving, and the save button remains the user's explicit action. This is
  inherent to the feature and accepted rather than eliminated.
- **No local emulator exists for the AI backend, so the Firebase impl cannot be exercised
  automatically.** → Mitigation: the port plus a fake covers the notifier, screen and every observable
  behaviour; the Firebase impl is covered by a fake model handle for its parsing and mapping, plus a
  unit test per pure function it owns. A live call stays a manual check.
- **`Application` JSON schema support varies by model.** A model that rejects `responseSchema` would
  fail at request time → Mitigation: the schema is built in one place behind the model's construction,
  and the model name is configuration, so the mitigation is a configuration change rather than a code
  change.
- **Reading a full-resolution image into memory for every request.** A very large photo allocates a
  large buffer on a mobile device → Mitigation: the size guard rejects oversized input before the
  request, though the read itself already happened; acceptable because `pickImage` currently produces
  device-camera-sized files, and the pick-time fix is decision 7's follow-up if it becomes a problem.
- **`Plant` stays default-free, which makes any future field addition costly.** → Mitigation: none
  taken; this change was designed to add no field precisely to avoid paying that cost. Recorded here
  because it will be paid by the next change that does add one.

## Migration Plan

No stored data migrates and no stored shape changes, so there is nothing to roll back in the data.
Rollback is removing the trigger from the photo grid and dropping the two new dependencies; the
add-plant flow returns to its current behaviour because nothing else consumes the identification
state. Because `AI_PROVIDER` is optional, an existing checkout with an unmodified `.env` starts
normally after this lands and reports identification as unavailable until the key is set.

Order matters in one respect: the `firebase_app_check` dependency and its debug-provider wiring should
land with, or before, the first run against a real backend, so a request is not rejected on first use.

## Open Questions

None. The remaining unknowns — whether `gemini-3.7-flash` accepts an application-JSON response schema,
and what the free-tier rate limit is in practice — are answerable by running the feature, and neither
would change the specs, the approach, or the task breakdown, because the model name and the request
configuration are both already behind the seam.
