import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:succucare_app/features/notifications/data/models/models.dart';

part 'notifications_state.freezed.dart';
part 'notifications_state.g.dart';  

enum NotificationStatus {
  authorized('Authorized'),
  unauthorized('unauthorized'),
  unknown('Unknown');

  final String label;
  const NotificationStatus(this.label);
}

@freezed
abstract class NotificationsState with _$NotificationsState {
  const factory NotificationsState({
    required NotificationStatus status,
    required List<AppNotification> notifications,
  }) = _NotificationsState;

  factory NotificationsState.fromJson(Map<String, Object?> json) =>
      _$NotificationsStateFromJson(json);
}
