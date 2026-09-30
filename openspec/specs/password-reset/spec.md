# password-reset Specification

## Purpose
Lets an unauthenticated user who has lost their password request a password reset email for
their account from the authentication flow, with clear feedback on success and failure.

## Requirements

### Requirement: Password reset is reachable from the login flow

The system SHALL provide an entry point on the login location that opens a password reset
location, and a user SHALL be able to reach the password reset location without an active
session.

#### Scenario: User opens password reset from the login location

- **WHEN** an unauthenticated user is at the login location and activates the password reset
  entry point
- **THEN** the system opens the password reset location

#### Scenario: Password reset location is reachable without a session

- **WHEN** an unauthenticated user is at the password reset location
- **THEN** the system takes no further action and the password reset location remains displayed

### Requirement: Reset request validates the email address

The system SHALL validate the email address entered on the password reset location before
requesting a reset link. An empty or malformed email address SHALL produce immediate feedback
and SHALL NOT trigger a request.

#### Scenario: Email field is left empty

- **WHEN** the user submits the password reset form with an empty email address
- **THEN** the system shows validation feedback and does not request a reset link

#### Scenario: Email address is malformed

- **WHEN** the user submits an email address that is not a valid email format
- **THEN** the system shows validation feedback and does not request a reset link

### Requirement: Successful reset request returns the user to the login flow

When a reset link is successfully requested, the system SHALL return the user to the login
location and SHALL confirm that the reset email was sent.

#### Scenario: Reset email is sent successfully

- **WHEN** the user submits a valid email address and the reset link request succeeds
- **THEN** the system returns the user to the login location and confirms the reset email was
  sent

### Requirement: Reset request failures are communicated and retryable

When a reset link request fails, the system SHALL keep the user at the password reset location,
SHALL communicate that the request failed, and SHALL allow the user to attempt the request
again.

#### Scenario: Reset request fails

- **WHEN** submitting a reset link request fails
- **THEN** the system keeps the user at the password reset location, communicates the failure,
  and allows another attempt

### Requirement: Account existence is not disclosed

The system SHALL NOT reveal whether a submitted email address is registered to an account. A
request for an email address with no associated account SHALL be treated the same as one that
succeeds.

#### Scenario: Email has no associated account

- **WHEN** the user submits a well-formed email address that has no associated account and the
  request otherwise succeeds
- **THEN** the system responds as it would for a registered account and does not indicate that
  the account does not exist
