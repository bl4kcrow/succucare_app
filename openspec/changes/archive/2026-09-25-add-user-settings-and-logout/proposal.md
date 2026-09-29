# Proposal

## Why

Authenticated users had no way to reach their account details or end a session. The only
affordance in the shell's top-right corner was a `Settings` icon whose `onPressed` was `() {}`,
and `Routes.settings` had been declared in the route enum but never routed to.

Ending a session was not merely missing UI. The router's `redirect` callback only handled two
narrow cases (splash resolution, and redirecting authenticated users away from login) and
returned `null` for every other location, so no route was actually guarded. Had a sign-out
button been added on its own, tapping it would have cleared the Firebase session while leaving
the user stranded on whatever screen they were on, with no navigation and no way to recover.

## What Changes

- Add a `/settings` route rendering a new `SettingsScreen` that displays the signed-in user's
  name and email and offers a sign-out action.
- Wire the previously inert `Settings` icon in the shell app bar to that route, via a required
  `onSettingsPressed` callback.
- Add a public-route concept to the router and a guard branch that redirects unauthenticated
  users to `/login` from any non-public location, closing the hole that made session-ending
  navigation a no-op.
- Give `/splash` a dedicated branch so it holds while the auth state is still unresolved instead
  of bouncing, eliminating the login-screen flash for returning users.
- Cover nested auth routes via a `/login/` prefix match, which makes the guard apply to
  `/login/create-account` for the first time. The existing equality check against
  `Routes.createAccount.value` never matched, because that enum value (`'create-account'`) omits
  the leading slash that `fullPath` carries.
- Add `onError` and `onDone` handling to the Firebase auth state stream so a stream failure
  degrades to the unauthenticated state (landing on `/login`, where the user can retry) instead
  of leaving the auth state permanently unresolved.
- Invalidate the cached garden provider on sign-out, before the session is torn down, so a
  subsequent sign-in cannot observe the previous user's plants.

Non-goals: no account editing, no avatar upload, no preferences section, no notification or
theme settings, and no `deleteAccount()` exposure despite that method already being implemented.

## Capabilities

### New Capabilities

- `auth-routing`: which locations a user may occupy for each authentication state, how the
  splash transient behaves while auth is unresolved, how nested auth routes are recognised as
  public, and how auth-stream failures degrade.
- `user-settings`: how an authenticated user reaches their account details and ends a session,
  what the settings surface displays, and what happens to cached per-user state on sign-out.

### Modified Capabilities

None. This is the first change recorded in the project, so there are no existing specs whose
requirements change.

## Impact

- **Routing**: `lib/core/routes/app_router.dart` (`redirect` rewritten, `/settings` route added).
  `lib/core/routes/routes.dart` is unchanged — it already declared `Routes.settings`.
- **Auth**: `lib/features/auth/services/firebase_auth_service.dart` (stream error/done handling).
- **New screen**: `lib/features/auth/screens/settings_screen.dart`, exported from
  `lib/features/auth/screens/screens.dart`.
- **Shell**: `lib/features/garden/widgets/garden_app_bar.dart` (new required callback),
  `lib/features/garden/screens/my_garden_screen.dart` (wiring and one import).
- **No new dependencies, no new assets, no new route constants.** The sign-out action reuses the
  existing `Auth.signOut()` call chain, which was already complete end to end.
- **Cross-cutting**: `auth-routing` is not specific to settings. Future work touching deep
  linking, token refresh, or role gating will modify it.
