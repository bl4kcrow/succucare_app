# Design

## Context

See `proposal.md` - Why for motivation, and `specs/auth-routing/spec.md` /
`specs/user-settings/spec.md` for the requirements this design satisfies. Only the state and
constraints that shaped the approach are described here.

The shell's application bar already carried a `Settings` affordance whose handler was an empty
closure, and `Routes.settings` was already declared in the route enum but unrouted. So the route
constant, the visual slot, and the sign-out call chain all pre-existed; the gap was the wiring,
the destination, and the routing rule that would make session-ending navigation observable.

The sign-out call chain (`Auth.signOut` → repository → Firebase service) was already complete
and correct, which bounded the work to presentation and routing rather than service work.

The router's `redirect` was structured as a set of special cases keyed on exact `fullPath`
equality, terminating in an unconditional `return null`. Two consequences shaped the design:
there was no notion of a *guarded* location, so nothing redirected on the way out; and the
special-case style meant coverage depended on enumerating locations individually, which is how the
nested account-creation route came to be silently uncovered.

## Goals / Non-Goals

**Goals**

- Make authentication state the single input to every routing decision, so that ending a session
  produces the same outcome regardless of which screen initiated it.
- Make the guard's coverage a property of the router's structure rather than of a hand-maintained
  list, so new locations are guarded by default.
- Keep the presentation layer free of auth-routing logic, so no screen can implement a
  divergent version of the rule.

**Non-Goals (design-level boundaries)**

- Not a general settings framework. The location is a single screen with one destructive action;
  no navigation, no sections, no preference persistence.
- Not a redesign of auth state ownership. The router continues to observe auth through a
  `Listenable` it creates itself; that arrangement is untouched. See Open Questions.
- Not a fix for the pre-existing subscription and stream-controller leaks. They are recorded
  under Risks rather than addressed here, because touching them changes teardown behavior in a
  way this change does not require.

## Decisions

### Deny-by-default guard rather than an enumerated protected-route list

`redirect` classifies every location as public or not public, and redirects any non-public
location to login when unauthenticated.

**Alternative considered:** enumerate protected routes and redirect on a membership test. This
inverts the failure mode — a newly added location would default to *unguarded* and fail open,
which is precisely the bug that made the previous implementation unsafe to build on. The
allowlist is small and stable (three entries), so its maintenance cost is low, while the cost of
silently forgetting an entry is a user stranded on a screen they can no longer use.

### Splash given its own branch, ahead of the public-route test

Splash is modelled as a transient rather than a destination: it holds while auth is unresolved
and navigates away unconditionally once resolved.

**Alternative considered:** a blanket "hold while unresolved" as the first rule in `redirect`,
letting the public-route branch handle the outcome. This is the more elegant shape and it is
wrong: with splash classified as public, the resolved-unauthenticated case returns `null` and
leaves the user on the splash indicator permanently, with no route forward. The original code
avoided this only because splash returned an explicit login redirect. Isolating splash preserves
that escape while removing the login-screen flash for returning users.

### Public classification by prefix match rather than by correcting the enum value

A location is public if it equals splash, equals login, or begins with `login` followed by a path
separator.

**Alternative considered:** fixing `Routes.createAccount`'s value to carry a leading slash. That
enum value is used as a child route's declared path, where a leading slash is interpreted as
absolute and would move the location out from under its parent, changing the URL. Correcting it
would trade a guard bug for a navigation regression. Matching on the occupied location instead
makes coverage independent of how each route declares its own path, which is what allowed the
nested route to be missed in the first place.

### One redirect authority; screens never navigate on auth grounds

The settings screen ends the session and performs no navigation. The resulting location is
derived entirely from the resulting auth state.

**Alternative considered:** the screen navigating to login after sign-out. It is fewer moving
parts locally, but it produces a second, divergent copy of the routing rule — and it does not
help the cases that motivated the change, such as a session ending from token expiry or from
another tab. One authority also means the guard's coverage is a single readable block.

### Garden cache discarded before the session is torn down

The settings screen discards cached garden state, then ends the session.

**Alternative considered:** discarding afterwards. The garden data source resolves the owning user
from the current session on every read and has no guard for its absence, so discarding after sign-out
would rebuild the still-mounted provider against a null-user path, fail, and surface a permission
error to the user as a spurious failure of a successful sign-out. Discarding first removes the
state while it is still unambiguous, and the provider's own lifecycle plus the redirect take it
from there.

### Authentication source failure treated as unauthenticated

A failure of the auth state source emits the unauthenticated state rather than leaving it
unresolved.

**Alternative considered:** propagating the error to the consumer, and separately, leaving it
unhandled. Both leave the state unresolved, and with splash now holding on an unresolved state
that is a permanent spinner with no recovery. Failing toward unauthenticated reproduces the
pre-change behavior exactly: the user reaches login and can retry. The alternative of a dedicated
error surface was rejected as disproportionate for a failure that is already rare and not
actionable by the user.

### `goNamed` rather than `pushNamed` for the settings location

**Alternative considered:** `pushNamed`, which would have placed the location above the shell and
given a back arrow and working system-back. Rejected in favour of `goNamed`, which replaces the
location. The accepted cost is that the settings location has no in-app exit and system-back from
it leaves the application rather than returning to the garden. This is a deliberate tradeoff, not
an oversight; it is a single-token change if the in-app exit is later wanted.

### Navigation injected into the shell application bar as a callback

The application bar takes a required callback and navigates nowhere itself.

**Alternative considered:** navigating inside the bar. The callback form matches the convention
already used by the search field and plant card, keeps the widget free of routing and import
concerns, and leaves it directly constructible in a test. It also keeps `GardenAppBar` free of any
knowledge of *which* location it opens.

## Risks / Trade-offs

- **Allowlist forgetting** — a genuinely public location added later would be redirected to login
  for authenticated users. → Mitigation: the public set is defined in one contiguous expression
  immediately above the guard; and any new public location will be an authentication concern, so
  it is likely to be added while this code is already in view.
- **Splash becomes a hard dependency on the auth source emitting** — previously a broken source
  still let the user reach login and retry. → Mitigation: the source is now wrapped for error, and
  is established before the app starts. A source that neither emits nor errors would still stall
  splash; a timeout was considered and rejected as over-engineering for a failure mode not
  observed in practice.
- **Settings now depends on the garden feature** to discard its cache. → Mitigation: recorded as
  an open question below rather than treated as settled.
- **The router rebuilds and re-subscribes without cancelling its previous auth subscription**,
  leaking one listener per rebuild. This is pre-existing and unchanged, but the guard now makes
  router rebuilds more consequential. → Mitigation: none in this change; noted so it is not
  mistaken for a regression introduced here.
- **No automated coverage of the guard.** Its branches are behavioral and would benefit from
  tests, but the only existing test file targets a removed module and the current provider setup
  offers no usable harness. → Mitigation: the manual verification pass in `tasks.md` exercises
  each branch.
- **The unauthenticated user is represented as a populated placeholder rather than an absence**,
  so "signed out" and "signed in without a display name" are not distinguishable by inspecting
  the stored identity. → Mitigation: the guard keeps account settings unreachable while signed
  out, so no screen has to make that distinction. This will need revisiting if a display name ever
  becomes optional.

## Migration Plan

Additive and self-contained; no data migration, no Firestore or Storage writes, no index or
security-rule change, no new dependency or asset, and no new route constant. The only behavioral
change to existing flows is that several previously reachable locations now redirect for
unauthenticated users, and that returning users no longer see a login screen during startup.

Deployment is a normal release. Rollback is a single revert of the change; because nothing
persisted was written by this feature, rollback needs no data repair. The one asymmetry to
retain on revert is that reverting restores the unguarded redirect, which is safe only while the
settings location is also reverted out of existence in the same commit.

## Open Questions

- **How should per-user cached state be discarded as more of it appears?** The settings screen
  currently names the garden provider specifically, so the coupling between an auth surface and
  the garden feature is explicit but will grow as alerts, scan history, and similar per-user
  state are added. A session-end concern that owns the whole set would remove the growing import,
  but it is not worth introducing for one provider. This can be decided when the second
  per-user cache exists, without changing any requirement in this change.
- **Should account settings grow into a general settings surface?** Not decided here. Nothing in
  the requirements assumes it, so it can be answered later without altering them.
