# Tasks

All tasks below are complete. This change was implemented before it was recorded, so the
checkboxes are marked done; each states how completion was verified.

## 1. Authentication routing guard

- [x] 1.1 Rewrite `redirect` to classify every location as public or not public, and redirect any non-public location to login when unauthenticated. Verify authenticated access to every guarded location still resolves without a redirect.
- [x] 1.2 Give the splash location its own branch that holds while the auth state is unresolved and navigates away once resolved. Verify a logged-out cold start reaches login and an authenticated cold start reaches the garden with no login screen in between.
- [x] 1.3 Classify locations nested beneath login as public by prefix match, so the account creation location is covered for the first time. Verify an authenticated user at the account creation location is redirected to the garden.
- [x] 1.4 Treat an absent location as non-public so the guard still applies when nothing matched. Verify `flutter analyze` reports no nullable-receiver error on the prefix match.
- [x] 1.5 Emit the unauthenticated state when the auth state source fails, and close the source when it completes, so a source failure no longer leaves the state unresolved. Verify the stream's error path delivers a value to its listener.

## 2. Account settings surface

- [x] 2.1 Add the account settings location rendering the signed-in user's name and email, derived from the auth provider rather than passed in. Verify the screen shows the authenticated user's identity.
- [x] 2.2 Discard cached garden state before ending the session, so no per-user read is attempted after the departing user's identity is gone. Verify a second user signing in afterwards sees none of the first user's plants.
- [x] 2.3 Make the sign-out action unavailable while a sign-out is in progress, and report a failure without ending the session, restoring the action afterwards. Verify a failed sign-out leaves the user signed in and able to retry.
- [x] 2.4 Export the new screen from the auth screens barrel so the router can reach it without a new import. Verify the router resolves the screen by name.

## 3. Shell wiring

- [x] 3.1 Replace the inert app bar action handler with a required callback, leaving the affordance and its placement unchanged. Verify the app bar no longer contains an empty handler.
- [x] 3.2 Navigate to the account settings location from the shell app bar, making the affordance available from every tab. Verify the action opens settings from the garden, plant scan, and alerts tabs.

## 4. Integration verification

- [x] 4.1 Confirm static analysis introduces no new findings beyond the known baseline, which is the legacy analyzer-plugin warning and one unused declaration. Verify `flutter analyze` reports exactly those two.
- [x] 4.2 Confirm the test suite is unaffected, its only failures being the three pre-existing cases in the stale test file that targets a removed module. Verify `flutter test` fails the same three cases and no others.
- [x] 4.3 Walk each guard branch on a device, covering signed-out startup, authenticated startup, sign-in, sign-out from the garden, and sign-out from a non-garden tab. Verify each ends at the expected location and that a second user sees none of the first user's data.
