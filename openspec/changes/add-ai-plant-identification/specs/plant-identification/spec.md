# Spec Delta

## Purpose

Defines how the system can propose what a newly added plant is, from a photo the user has already
attached, so that the add form starts from something close to correct instead of blank. Covers when a
proposal is offered, which values a proposal may set, what the user must still supply, what happens
when a proposal cannot be produced, and how the source answering those requests is chosen.

## ADDED Requirements

### Requirement: The identification source is chosen by configuration

The system SHALL reach every identification request through a provider-neutral port whose
implementation is selected by configuration. No screen, notifier, or repository that participates in
adding a plant SHALL name or depend on a specific artificial intelligence backend. When the
configuration selects no backend, the system SHALL report that identification is unavailable and SHALL
leave the add form fully usable, so that a user can still add a plant by typing it.

#### Scenario: A configured backend answers an identification request

- **WHEN** the configuration selects an identification backend and the user requests identification
- **THEN** the request is answered through the selected backend and the system does not ask which
  backend to use at runtime

#### Scenario: No backend is configured

- **WHEN** the configuration selects no identification backend and the user requests identification
- **THEN** the system reports that identification is unavailable and the add form remains editable and
  saveable

#### Scenario: The selected backend is changed

- **WHEN** the configured identification backend is changed from one backend to another
- **THEN** the add-plant flow presents and reports the same behaviour it presented before, with no
  change to the code of that flow

#### Scenario: An identification request is made

- **WHEN** any part of the system requests plant identification
- **THEN** the request is made through the port and never by reaching a named backend directly

### Requirement: Identification is offered only against an attached photo

The system SHALL offer identification only when the plant being added already has a photo attached.
When no photo is attached, the system SHALL NOT present an identification action and SHALL NOT make an
identification request. Identification SHALL act on the photo attached to the plant being added, and
SHALL NOT obtain a photo from any other source on the user's behalf.

#### Scenario: A photo is attached and identification is requested

- **WHEN** the plant being added has a photo attached and the user activates the identification action
- **THEN** the system submits that photo for identification and shows that identification is in
  progress

#### Scenario: No photo is attached

- **WHEN** the plant being added has no photo attached
- **THEN** the system presents no identification action and makes no identification request

#### Scenario: The attached photo is unusable as identification input

- **WHEN** a user requests identification and the attached photo cannot be submitted, because it
  exceeds what the source accepts or cannot be read
- **THEN** the system reports that the photo cannot be identified, leaves the form's existing values
  unchanged, and does not make an identification request

### Requirement: A proposal populates the editable fields and nothing else

When the system receives a usable identification result, it SHALL place the proposed values into the
corresponding editable fields of the add form, where they remain ordinary editable values the user may
change or clear. The system SHALL NOT save the plant as part of producing or presenting a proposal, and
SHALL NOT make the proposal difficult to edit by writing it into any field the user cannot edit. A
later successful proposal for the same plant SHALL replace an earlier proposal.

#### Scenario: A proposal is produced

- **WHEN** identification returns usable values
- **THEN** the proposed values appear in their editable fields and the plant has not been saved

#### Scenario: The user changes a proposed value

- **WHEN** the user edits a value the system proposed
- **THEN** the field shows the user's value and it is the value that would be saved

#### Scenario: The user ignores the proposal

- **WHEN** the user leaves a proposed value unchanged or clears it
- **THEN** the system saves whatever the form holds at that point, without restoring the proposed
  value

#### Scenario: Identification is repeated for the same plant

- **WHEN** the user requests identification again for a plant that already holds a proposal
- **THEN** the system shows the newer proposal in place of the earlier one

### Requirement: A proposal covers identity and care defaults only

A proposal SHALL be limited to a common name, a scientific name, a category, a suggested watering
interval in whole days, and a suggested light level. The system SHALL NOT propose a last-watered date,
a moisture level, a moisture source, a health status, or notes, and those values SHALL remain whatever
the user has entered. A proposed category SHALL be one of the categories the form offers, and a
proposed watering interval SHALL be a positive whole number of days within the range the form accepts.
When the source returns a value that cannot be used by the form, the system SHALL omit that value and
SHALL still present the remaining usable ones.

#### Scenario: The source returns a category the form does not offer

- **WHEN** identification returns a category that is not one of the categories the form offers
- **THEN** the system proposes no category and presents the other usable values

#### Scenario: The source returns an unusable watering interval

- **WHEN** identification returns a watering interval that is not a positive whole number of days
  within the range the form accepts
- **THEN** the system proposes no watering interval and presents the other usable values

#### Scenario: The source returns no usable values

- **WHEN** identification completes but returns no value the form can use
- **THEN** the system reports that the plant could not be identified, leaves the form's values
  unchanged, and does not block the user from filling the form in

#### Scenario: A proposal has been applied

- **WHEN** a proposal is in the form
- **THEN** the last-watered date, moisture level, moisture source, health status and notes hold only
  what the user entered

### Requirement: A proposal alone does not make the plant saveable

The values the system does not propose SHALL remain required before a plant can be saved. After a
successful identification, the system SHALL enforce the same requirements it enforces for a plant typed
in full, so that a proposal that covers the proposed values only still leaves the plant unsaveable
until the user supplies the rest.

#### Scenario: The user submits after a proposal without supplying the remaining values

- **WHEN** the user submits the add form after a successful identification without supplying the values
  the system did not propose
- **THEN** the system refuses to save, reports the missing values with the application's established
  wording for incomplete input, and writes no plant

#### Scenario: The user supplies the remaining values

- **WHEN** the user supplies the values the system did not propose and submits the form
- **THEN** the plant is saved with the proposed identity values and the user's remaining values

#### Scenario: The user never requests identification

- **WHEN** the user adds a plant without requesting identification at any point
- **THEN** the add form behaves exactly as it did before this capability existed

### Requirement: Identification is transient and leaves no record of itself

The system SHALL NOT write anything about an identification to stored data, and SHALL NOT record on the
saved plant that a value came from a proposal. A plant saved with proposed values SHALL be
indistinguishable from a plant saved with the same values typed by the user, and no stored field, and
nothing the user can read afterwards, SHALL indicate that identification was used.

#### Scenario: A plant is saved after a proposal was accepted

- **WHEN** a plant is saved and one or more of its values came from a proposal
- **THEN** the stored plant contains no field recording the proposal, and the model used to store
  plants is unchanged by this capability

#### Scenario: The plant is read back afterwards

- **WHEN** the saved plant is read back from stored data
- **THEN** nothing about it indicates that identification was used to compose it

#### Scenario: Identification is not requested

- **WHEN** a plant is added without any identification request
- **THEN** the same stored record is produced as when a proposal was accepted
