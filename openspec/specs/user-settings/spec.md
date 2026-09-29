# user-settings Specification

## Purpose
Defines how an authenticated user reaches their own account details, what that surface
displays, and what happens to their session and cached per-user data when they sign out.

## Requirements

### Requirement: Account settings are reachable from every garden tab

The system SHALL present an account affordance in the application bar of the authenticated
application shell. The affordance SHALL be available from every tab of that shell and SHALL open
the account settings location.

#### Scenario: User opens account settings from the garden tab

- **WHEN** an authenticated user activates the account affordance while viewing their garden
- **THEN** the system opens the account settings location

#### Scenario: User opens account settings from a non-garden tab

- **WHEN** an authenticated user activates the account affordance from the plant scan or alerts
  tab
- **THEN** the system opens the account settings location

### Requirement: Account settings display the current user's identity

The system SHALL display the signed-in user's display name and email address on the account
settings location. The displayed values SHALL reflect the currently authenticated user.

#### Scenario: Authenticated user views their account details

- **WHEN** an authenticated user opens the account settings location
- **THEN** the system displays that user's name and email address

#### Scenario: Account details are unavailable without a session

- **WHEN** a user without an established session attempts to reach the account settings location
- **THEN** the system redirects to the login location and does not display account details

### Requirement: Signing out ends the session

The system SHALL provide an action on the account settings location that ends the user's
session. Completing it SHALL terminate the session and return the user to the login location.
The resulting location SHALL be determined by the resulting authentication state, and SHALL be the
same regardless of which screen the user initiated the sign-out from.

#### Scenario: User signs out

- **WHEN** an authenticated user activates the sign-out action and the session ends successfully
- **THEN** the system returns the user to the login location

#### Scenario: User signs out from a non-garden screen

- **WHEN** a session ends while the user is viewing a location other than the garden
- **THEN** the system returns the user to the login location

### Requirement: Sign-out cannot be repeated while in progress

The system SHALL prevent the sign-out action from being activated again while a sign-out is
already in progress, and SHALL communicate that a sign-out is in progress.

#### Scenario: Sign-out is in progress

- **WHEN** a sign-out has been started and has not yet completed
- **THEN** the sign-out action is unavailable and the user is informed that sign-out is in
  progress

### Requirement: Cached per-user data is discarded when a session ends

The system SHALL discard data cached for the departing user as part of ending a session, so that
data belonging to a previous user is never presented to a subsequent user. Discarding SHALL
complete before the session is torn down, so that no per-user data is read after the departing
user's identity is no longer available.

#### Scenario: A different user signs in afterwards

- **WHEN** user A signs out and user B subsequently signs in
- **THEN** user B sees only user B's data and no part of user A's data

#### Scenario: Departing user's data is not read after sign-out

- **WHEN** a session ends and cached per-user data is discarded
- **THEN** no per-user data belonging to the departing user is fetched or displayed

### Requirement: Sign-out failure is reported and leaves the session intact

The system SHALL report a failure to end a session, SHALL leave the user signed in when the
session could not be ended, and SHALL make the sign-out action available again.

#### Scenario: Sign-out fails

- **WHEN** a user activates the sign-out action and ending the session fails
- **THEN** the system reports the failure, the user remains signed in, and the sign-out action
  becomes available again
