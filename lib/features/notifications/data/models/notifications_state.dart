import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:succucare_app/features/notifications/data/models/models.dart';

part 'notifications_state.freezed.dart';
part 'notifications_state.g.dart';  

enum NotificationsStatus {
  authorized('Authorized'),
  unauthorized('unauthorized'),
  unknown('Unknown');

  final String label;
  const NotificationsStatus(this.label);
}

/// Which subset of the alerts inbox the Alerts view is currently showing.
enum AlertsFilter {
  all('all'),
  unread('unread');

  final String value;
  const AlertsFilter(this.value);
}

@freezed
abstract class NotificationsState with _$NotificationsState {
  const NotificationsState._();

  const factory NotificationsState({
    required NotificationsStatus status,
    required String token,
    required List<AppNotification> notifications,
    @Default(AlertsFilter.all) AlertsFilter filter,
    @Default(<String>{}) Set<String> readMessageIds,
  }) = _NotificationsState;

  factory NotificationsState.fromJson(Map<String, Object?> json) =>
      _$NotificationsStateFromJson(json);

  /// Whether the notification identified by [messageId] is still unread.
  bool isUnread(String messageId) => !readMessageIds.contains(messageId);

  /// Number of notifications that have not been marked as read yet.
  int get unreadCount =>
      notifications.where((notification) => isUnread(notification.messageId)).length;

  /// Notifications matching the selected [filter], preserving newest-first order.
  List<AppNotification> get visibleNotifications => switch (filter) {
    AlertsFilter.all => notifications,
    AlertsFilter.unread =>
      notifications.where((notification) => isUnread(notification.messageId)).toList(),
  };
}
