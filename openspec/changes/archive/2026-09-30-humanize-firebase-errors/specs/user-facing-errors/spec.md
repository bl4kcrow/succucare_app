# Spec Delta

## Purpose

Defines what the application tells a user when an operation fails: never the underlying technical
detail, always wording the user can act on, and always the same wording for the same failure
regardless of where it is reported.

## ADDED Requirements

### Requirement: Technical failure detail is never presented to the user

The system SHALL NOT present raw failure detail to the user. No error code, exception type name,
stack trace, service name, or underlying message produced by a backend service SHALL appear in
anything the user can read. This applies to every surface that reports a failure, including
transient notifications.

#### Scenario: A backend failure is reported

- **WHEN** an operation fails and the system reports the failure to the user
- **THEN** the reported text contains no error code, exception type name, or service identifier

#### Scenario: A failure is converted to text without an explicit mapping

- **WHEN** a failure is rendered and no specific message has been chosen for it
- **THEN** the system does not substitute the raw failure text

### Requirement: Recognized authentication failures name the correction

When the system recognizes which authentication failure occurred, it SHALL report wording that
identifies what the user should change or check, and SHALL NOT identify which part of a credential
was incorrect.

| Recognized cause                  | Wording presented to the user        |
| --------------------------------- | ----------------------------------- |
| Email address is malformed        | That email address isn't valid.     |
| Credentials did not authenticate  | Email or password is incorrect.     |
| Email already has an account      | That email is already registered.   |
| Password rejected as too weak     | Choose a stronger password.         |
| Too many attempts                 | Too many attempts. Try again later.  |
| No network connection             | No connection. Check your network.  |
| Account is disabled               | This account is disabled.           |
| Session must be re-established    | Sign in again to continue.          |

#### Scenario: A password is submitted that does not authenticate

- **WHEN** a user submits an email address and password that do not authenticate
- **THEN** the system reports that the email or password is incorrect

#### Scenario: A sign-up uses an email address that already has an account

- **WHEN** a user attempts to register an email address that already has an account
- **THEN** the system reports that the email address is already registered

#### Scenario: A failure is reported without disclosing which credential was wrong

- **WHEN** an authentication attempt fails
- **THEN** the wording does not state whether the email address, the password, or the account was
  the problem

### Requirement: Recognized data and file failures are distinguished

When the system recognizes a cause for a data or file operation failure, it SHALL report wording
that distinguishes that cause from other causes, so the user can tell a connectivity problem from
a missing record from a storage limit.

| Recognized cause                     | Wording presented to the user            |
| ------------------------------------ | --------------------------------------- |
| Access refused                       | You don't have access to that.           |
| Record does not exist                | That record no longer exists.            |
| Record already exists                | That already exists.                     |
| Service unreachable or too slow      | Service is busy. Try again.              |
| Storage or quota exhausted           | Storage is full. Free up space.          |
| Session must be re-established       | Sign in again to continue.               |
| Supplied value was not acceptable    | That information isn't valid.            |

#### Scenario: A save is refused

- **WHEN** a save operation fails because access is refused
- **THEN** the system reports that the user does not have access, and does not report the underlying
  reason

#### Scenario: The service cannot be reached

- **WHEN** an operation fails because the service is unreachable or did not respond in time
- **THEN** the system reports that the service is busy and suggests trying again

### Requirement: Unrecognized failures are reported identically

Any failure that is not recognized SHALL be reported with exactly one generic message, and the
same generic message SHALL be used for every unrecognized failure. Failures that did not originate
from a recognized backend service are unrecognized.

#### Scenario: A failure has no recognized cause

- **WHEN** an operation fails for a cause the system does not recognize
- **THEN** the system reports that something went wrong and suggests trying again

#### Scenario: A failure did not originate from a backend service

- **WHEN** an operation fails with a failure that did not originate from a recognized backend
  service
- **THEN** the system reports the same generic message used for any other unrecognized failure

### Requirement: The underlying cause remains available for diagnostics

The system SHALL retain the originating failure and its cause for diagnostic output, and SHALL
expose that diagnostic output only through developer-facing logging. The retained cause SHALL NOT
be presented to the user.

#### Scenario: A failure occurs

- **WHEN** an operation fails
- **THEN** the originating failure and its cause are recorded in developer-facing output

#### Scenario: Diagnostic output is inspected

- **WHEN** developer-facing output records a failure
- **THEN** it identifies the cause even though the user-facing message did not

### Requirement: A failure reports the same wording everywhere

The same failure SHALL produce the same user-facing wording at every surface that reports it. Two
surfaces reporting the same underlying failure SHALL NOT differ in wording.

#### Scenario: One failure is reported from two surfaces

- **WHEN** the same underlying failure is reported at two different surfaces
- **THEN** the wording presented at both surfaces is identical

### Requirement: Failure reporting does not alter existing notification styling

Reporting a mapped failure SHALL NOT change the appearance of the notification in which it is
presented, and SHALL NOT introduce a new control such as a retry action.

#### Scenario: A failure is reported in an existing notification

- **WHEN** a mapped failure is reported at a surface that already reports failures
- **THEN** the notification's existing appearance is unchanged and no additional control is added
