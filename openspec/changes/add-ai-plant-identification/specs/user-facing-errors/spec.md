# Spec Delta

## MODIFIED Requirements

### Requirement: Recognized data and file failures are distinguished

When the system recognizes a cause for a data, file, or identification operation failure, it SHALL
report wording that distinguishes that cause from other causes, so the user can tell a connectivity
problem from a missing record from a storage limit from a result the source could not produce.

| Recognized cause                        | Wording presented to the user                  |
| --------------------------------------- | --------------------------------------------- |
| Access refused                          | You don't have access to that.                 |
| Record does not exist                   | That record no longer exists.                  |
| Record already exists                   | That already exists.                           |
| Service unreachable or too slow         | Service is busy. Try again.                    |
| Storage or quota exhausted              | Storage is full. Free up space.                |
| Session must be re-established          | Sign in again to continue.                     |
| Supplied value was not acceptable       | That information isn't valid.                  |
| No identification source is configured  | Plant identification isn't available right now. |
| Submitted photo exceeds what the source accepts | That photo is too large to identify. Choose another. |
| Identification rate limit or quota exhausted | Identification is busy right now. Try again later. |
| Source returned no identification it could use | Couldn't identify that plant. Fill in the details yourself. |

#### Scenario: A save is refused

- **WHEN** a save operation fails because access is refused
- **THEN** the system reports that the user does not have access, and does not report the underlying
  reason

#### Scenario: The service cannot be reached

- **WHEN** an operation fails because the service is unreachable or did not respond in time
- **THEN** the system reports that the service is busy and suggests trying again

#### Scenario: An identification request is made with no source configured

- **WHEN** an identification request is made and no identification source is configured
- **THEN** the system reports that plant identification is not available right now, and does not report
  the underlying reason

#### Scenario: The submitted photo cannot be sent for identification

- **WHEN** an identification request fails because the photo exceeds what the source accepts
- **THEN** the system reports that the photo is too large to identify and suggests choosing another

#### Scenario: The source returns nothing the system can use

- **WHEN** an identification request completes and the source returned no identification the system can
  use
- **THEN** the system reports that it could not identify the plant and suggests filling in the details
