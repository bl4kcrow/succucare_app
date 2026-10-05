# plant-editing Specification

## Purpose
Defines the plant edit location as an address that names the plant it edits, rather than one that
depends on the navigating code to supply that plant. Covers how a plant is resolved from the id in
the address, and what the location shows when the id names no record, when the record cannot be
read, and when no id is present at all.

## Requirements

### Requirement: The edit location's address names the plant being edited

The system SHALL identify the plant being edited by an identifier carried in the edit location's own
address. The edit location SHALL be reachable from its address alone, with no value supplied by the
code that navigated to it. Navigation to the edit location from anywhere in the system SHALL encode
the identifier in the address rather than in an in-process value.

#### Scenario: The edit location is opened directly by its address

- **WHEN** a user reaches the edit location by its address, without having navigated there from
  another location
- **THEN** the system opens the edit location for the plant named by that address

#### Scenario: Navigating to the edit location from the garden list

- **WHEN** a user activates a plant in their garden
- **THEN** the system opens the edit location and the address of the opened location names that
  plant

#### Scenario: The edit location is reopened from its own address

- **WHEN** a user is at the edit location and the address is used to open that location again
- **THEN** the system opens the edit location for the same plant, using the address alone and
  without depending on any earlier visit

### Requirement: The plant is resolved from the identifier in the address

The system SHALL resolve the plant named by the address from stored data, and SHALL NOT require the
plant to have been loaded elsewhere first. Once resolved, the edit location SHALL present that
plant's stored values in the editable fields.

#### Scenario: The stored plant is loaded and presented

- **WHEN** a user is at the edit location for a plant that exists
- **THEN** the system presents that plant's stored values in the editable fields

#### Scenario: Resolution is in progress

- **WHEN** a user is at the edit location and the plant has not finished loading
- **THEN** the system shows a progress indication and does not present editable fields

#### Scenario: The plant is not already held by another part of the system

- **WHEN** a user reaches the edit location for a plant
- **THEN** the system reads that plant from stored data rather than requiring it to have been
  fetched by a different screen

### Requirement: An identifier that names no plant does not show an editable form

When the identifier in the address names no stored plant, the system SHALL NOT present an editable
form, SHALL report that the record no longer exists using the application's established wording for
a missing record, and SHALL offer a way back to the garden. The system SHALL NOT offer a retry
action for a record that does not exist.

#### Scenario: The address names a plant that does not exist

- **WHEN** a user is at the edit location for an identifier that matches no stored plant
- **THEN** the system reports that the record no longer exists, presents no editable form, and
  offers a way back to the garden

#### Scenario: The user leaves the unknown plant's location

- **WHEN** a user is at the edit location for an identifier that matches no stored plant and chooses
  the offered way back
- **THEN** the system takes the user to the garden

### Requirement: A failure to read the plant is reported in the application's wording and can be retried

When reading the plant named by the address fails for a reason other than the record being absent,
the system SHALL report the failure using the application's established wording for that cause, and
SHALL NOT present technical detail such as an error code, an exception type name, or a service
name. The system SHALL offer a retry action. If the retry succeeds, the system SHALL present the
plant's stored values in the editable fields; if it fails again, the system SHALL report the failure
again and continue to offer the retry action.

#### Scenario: Reading the plant fails

- **WHEN** reading the plant named by the address fails
- **THEN** the system reports the failure in the application's established wording and the reported
  text contains no error code, exception type name, or service name

#### Scenario: The user retries and the read succeeds

- **WHEN** reading the plant failed, the user chooses the offered retry action, and the retry
  succeeds
- **THEN** the system presents that plant's stored values in the editable fields

#### Scenario: The retry also fails

- **WHEN** the user chooses the offered retry action and the read fails again
- **THEN** the system reports the failure again and continues to offer the retry action

### Requirement: The edit location without an identifier returns the user to the garden

The system SHALL treat the edit location reached without a plant identifier as a request for a
location that identifies nothing, and SHALL send the user to the garden. The system SHALL NOT
present an editable form, a failure report, or a progress indication in that case.

#### Scenario: The edit location is opened with no identifier

- **WHEN** a user reaches the edit location without a plant identifier
- **THEN** the system takes the user to the garden and presents nothing else for that location

### Requirement: A saved edit is what a later visit to the location shows

After an edit is saved from the edit location, the system SHALL present the saved values when the
same location is opened again for the same plant.

#### Scenario: An edit is saved and the location is opened again

- **WHEN** a user saves an edit and later reaches the edit location for the same plant by its
  address
- **THEN** the system presents the saved values in the editable fields

#### Scenario: An unsaved edit is not presented as saved

- **WHEN** a user reaches the edit location for a plant that has no saved changes
- **THEN** the system presents the values last stored for that plant
