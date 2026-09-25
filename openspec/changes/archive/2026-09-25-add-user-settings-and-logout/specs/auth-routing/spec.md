# Spec Delta

## Purpose

Defines which locations a user may occupy for each authentication state, how the app behaves
while the authentication state is still being resolved at startup, and how an authentication
state failure degrades.

## ADDED Requirements

### Requirement: Unauthenticated users are excluded from guarded locations

The system SHALL redirect an unauthenticated user to the login location whenever the current
location is not public. This SHALL apply to every guarded location, including the garden, plant
scan, alerts, add plant, edit plant, and account settings locations.

#### Scenario: Unauthenticated user opens a guarded location directly

- **WHEN** an unauthenticated user is at any guarded location
- **THEN** the system redirects to the login location

#### Scenario: Session ends while a guarded location is displayed

- **WHEN** an authenticated user's session ends while they are viewing a guarded location
- **THEN** the system redirects to the login location without requiring any action from the user

#### Scenario: Guarded location is never displayed to an unauthenticated user

- **WHEN** a redirect to the login location occurs
- **THEN** the guarded location's content is not constructed or displayed

### Requirement: Public locations remain reachable without authentication

The system SHALL treat the splash, login, and account creation locations as public. An
unauthenticated user SHALL be able to remain at any public location.

#### Scenario: Unauthenticated user remains on the login location

- **WHEN** an unauthenticated user is at the login location
- **THEN** the system takes no further action and the login location remains displayed

#### Scenario: Unauthenticated user opens account creation

- **WHEN** an unauthenticated user navigates to the account creation location
- **THEN** the system takes no further action and the account creation location remains displayed

### Requirement: Authenticated users are excluded from authentication locations

The system SHALL redirect an authenticated user to the garden location when they occupy the
splash, login, or account creation location.

#### Scenario: Authentication succeeds while the user is signing in

- **WHEN** a user's session becomes established while they are at the login location
- **THEN** the system redirects to the garden location

#### Scenario: Authenticated user opens account creation

- **WHEN** an authenticated user is at the account creation location
- **THEN** the system redirects to the garden location

### Requirement: Authentication locations nested beneath another route are public

The system SHALL classify any location nested beneath the login location as public. Public
classification SHALL be determined by the location the user actually occupies, not by comparing
that location against a route's declared path segment in isolation.

#### Scenario: Nested authentication location is correctly classified

- **WHEN** a user occupies a location nested beneath the login location
- **THEN** the system classifies it as public and applies the authenticated-user redirect rule

### Requirement: Splash holds until the authentication state resolves

The system SHALL keep the user at the splash location while the authentication state is
unresolved, and SHALL navigate away from splash once it resolves. Splash SHALL always be left
once the state resolves, whether the user turns out to be authenticated or not.

#### Scenario: Authentication state is still resolving

- **WHEN** the authentication state is unresolved and the user is at the splash location
- **THEN** the system remains at the splash location

#### Scenario: Resolved state indicates an established session

- **WHEN** the authentication state resolves to authenticated and the user is at the splash location
- **THEN** the system navigates to the garden location

#### Scenario: Resolved state indicates no session

- **WHEN** the authentication state resolves to unauthenticated and the user is at the splash location
- **THEN** the system navigates to the login location

#### Scenario: Returning user is not shown an authentication screen during startup

- **WHEN** an already-authenticated user starts the app
- **THEN** the system proceeds from splash to the garden location without displaying the login
  location in between

### Requirement: Authentication state failures degrade to unauthenticated

The system SHALL treat a failure of the authentication state source as an unauthenticated state
rather than leaving the state unresolved. The system SHALL NOT depend on the authentication
state source emitting a value in order to make progress.

#### Scenario: Authentication state source reports an error

- **WHEN** the authentication state source fails
- **THEN** the system treats the user as unauthenticated and navigates to the login location

#### Scenario: User can retry after a state source failure

- **WHEN** the user is at the login location after an authentication state source failure
- **THEN** the user is able to attempt authentication again
