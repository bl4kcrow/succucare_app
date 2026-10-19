# Spec Delta

## Purpose

Lets the app request and reflect push-notification permission, receive FCM push messages, show them in a session-scoped in-app inbox on the alerts location, and open that inbox when the user taps a system notification.

## ADDED Requirements

### Requirement: Observable notification permission status
The system SHALL expose the current notification permission status as one of authorized, unauthorized, or unknown, and SHALL update the exposed status when the permission state changes. The status SHALL reflect the device's actual permission without requiring the user to act first.

#### Scenario: Permission previously granted
- **WHEN** the app starts on a device where notification permission was already granted
- **THEN** the exposed status is `authorized` without any prompt being shown

#### Scenario: Permission never granted or denied
- **WHEN** the app starts on a device where notification permission has not been granted
- **THEN** the exposed status is `unauthorized` or `unknown`, and no permission prompt appears until the user requests one

### Requirement: User-initiated permission request
The system SHALL allow the user to request notification permission through an explicit action within the app, and SHALL reconcile the exposed status with the outcome of that request. Declining SHALL NOT restrict any other app functionality.

#### Scenario: User grants permission
- **WHEN** the user triggers the permission request and accepts the system prompt
- **THEN** the exposed status becomes `authorized` and incoming push messages begin being recorded

#### Scenario: User declines permission
- **WHEN** the user triggers the permission request and declines the system prompt
- **THEN** the exposed status becomes `unauthorized` and the app remains fully usable

### Requirement: Foreground message receipt
The system SHALL record every push message received while the app is in the foreground into the notification list, preserving the message's title, body, and receipt time. A message SHALL be recorded at most once.

#### Scenario: Message arrives while app is open
- **WHEN** a push message is delivered while the app is in the foreground
- **THEN** the message appears at the top of the notification list with its title, body, and receipt time

#### Scenario: Duplicate delivery
- **WHEN** the same message (same message identifier) is delivered more than once
- **THEN** the notification list contains it only once

### Requirement: Session-scoped notification inbox
The system SHALL present the recorded notifications at the alerts location as a list ordered newest first, each entry showing title, body, and time. When no notifications have been recorded, the system SHALL show an empty state instead of an empty list. The list SHALL be session-scoped: it resets to empty when the app restarts.

#### Scenario: Multiple recorded notifications
- **WHEN** the user opens the alerts location with recorded notifications
- **THEN** they are listed newest first, each showing title, body, and time

#### Scenario: Nothing recorded yet
- **WHEN** the user opens the alerts location with no recorded notifications
- **THEN** an empty state is shown

#### Scenario: App restart
- **WHEN** the app is restarted after previously recording notifications
- **THEN** the notification list is empty

### Requirement: Notification tap opens the alerts location
When the user taps a system notification, the system SHALL open or resume the app and land the user on the alerts location, and the tapped message SHALL be present in the notification list. Navigation SHALL conform to the existing auth-routing rules: an unauthenticated user is redirected before occupying the guarded alerts location.

#### Scenario: App running in background
- **WHEN** the user taps a system notification while the app is backgrounded
- **THEN** the app comes to the foreground on the alerts location with the tapped message in the list

#### Scenario: App terminated
- **WHEN** the user taps a system notification after the app process was terminated
- **THEN** the app launches on the alerts location with the tapped message in the list

#### Scenario: User not signed in
- **WHEN** the user taps a system notification while unauthenticated
- **THEN** the existing auth redirect applies and the user is taken to the login location instead of the alerts location

### Requirement: Registration token for delivery targeting
The system SHALL obtain a push registration token once permission is authorized and emit it through developer-facing logging so messages can be targeted manually. The system SHALL NOT transmit the token to any destination of its own.

#### Scenario: Permission authorized
- **WHEN** permission becomes `authorized`
- **THEN** a registration token is obtained and appears in developer logs

### Requirement: Notification failures do not block app startup
The system SHALL complete app startup and keep all non-notification functionality available even when notification initialization fails. Any resulting failure SHALL follow the existing user-facing-errors rules if it is surfaced to the user.

#### Scenario: Notification initialization fails
- **WHEN** push service initialization or token acquisition fails at startup
- **THEN** the app starts normally and garden, scan, and settings features remain usable
