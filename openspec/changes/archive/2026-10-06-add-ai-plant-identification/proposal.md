# Proposal

## Why

Adding a plant today means typing a scientific name, a common name, and every care value by hand from
whatever reference the user happens to have open. Most users add a succulent they just bought and do
not know its species, so the form is abandoned rather than completed. A photo already has to be attached
for the plant to be usable, and that photo is enough for a generative model to propose an identity and
sensible care defaults, turning a blank form into a form the user can confirm in seconds.

## What Changes

- Introduce a plant identification capability: from a photo the user has already attached to a new
  plant, the system proposes an identity and care defaults, and presents them in the editable fields
  for the user to accept, change, or ignore before saving.
- Add a provider-agnostic port for identification. Which backend answers an identification request is
  chosen by configuration rather than by the code that calls it, so the AI source can be replaced
  without touching the add-plant flow.
- Ship Firebase AI Logic as the first backend behind that port, alongside a backend that reports
  identification as unavailable so the app remains usable when no AI source is configured.
- Constrain what the model may fill: names, category, suggested watering interval, and light level.
  The last-watered date, moisture level, health status and notes remain the user's to supply.
- Record no provenance. Nothing about the identification is written to the plant; a saved plant is
  indistinguishable from one the user typed in full.
- Extend the recognized failure causes and their wording so identification failures report in the same
  register as every other failure, with no technical detail.

## Capabilities

### New Capabilities

- `plant-identification`: What the system may propose from a photo when adding a plant, how the user
  reviews and overrides it, what the user must still supply, and how the identification source is
  chosen and reached.

### Modified Capabilities

- `user-facing-errors`: The table of recognized data and file failure causes gains the causes an
  identification request can fail for, so those failures are reported with wording that distinguishes
  them rather than falling through to the generic message.

## Impact

- **Dependencies**: adds `firebase_ai`, the Firebase AI Logic Flutter SDK, and `firebase_app_check`,
  which the AI Logic workflow requires in order to keep client requests authorized. Both are pinned by
  the same `firebase_core` major the project already resolves.
- **Configuration**: `AI_PROVIDER` and `AI_MODEL` added to `.env.template` and read in
  `lib/core/constants/environment.dart`. `Environment` currently reads every key with `dotenv.get`,
  which throws on a missing key, so these two must be read with an optional default; a project without
  them still starts and reports identification as unavailable.
- **Firebase project**: enabling App Check and the AI Logic provider is console-side work and is a
  prerequisite for the identification request succeeding against the real backend.
- **New code**: an identification port and its result type, a Firebase AI Logic implementation, an
  unavailable implementation, and the generated provider that selects between them.
- **Changed code**: the add-plant notifier gains identification state and applies proposed values onto
  `NewPlantState`; the add-plant screen and the photo grid gain the trigger, a progress indication, and
  a failure notification; the identification card receives values it did not previously receive from
  anywhere but the keyboard.
- **Errors**: new `AppFailureCode` values and mapping for identification-specific causes.
- **Data**: no change. `Plant`, `FirestorePlant`, both mapper directions, the mock fixtures and the
  Firestore document shape are untouched, and no Firestore rules or indexes are affected.
- **Not affected**: the plant edit flow, the garden list, the scan tab, authentication, and settings.
