import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:succucare_app/core/utils/result.dart';
import 'package:succucare_app/features/notifications/data/models/models.dart';
import 'package:succucare_app/features/notifications/data/repositories/repositories.dart';

part 'alerts_provider.g.dart';

@riverpod
class AlertsNotifier extends _$AlertsNotifier {
  @override
  Future<NotificationsState> build() async {
    NotificationsStatus initialStatus = NotificationsStatus.unknown;
    final notificationsRepository = ref.watch(notificationsRepositoryProvider);
    final notificationsStatus = await notificationsRepository
        .initNotifications();

    switch (notificationsStatus) {
      case Success<NotificationsStatus>():
        initialStatus = notificationsStatus.data;
      case Failure<NotificationsStatus>():
        initialStatus = NotificationsStatus.unknown;
    }

    return NotificationsState(status: initialStatus, notifications: []);
  }

  void configureMessageHandlers() {
    final notificationsRepository = ref.watch(notificationsRepositoryProvider);
    notificationsRepository.onBackground().listen((messageResult) {
      switch (messageResult) {
        case Success<AppNotification>():
          final appNotification = messageResult.data;
          state = AsyncData(
            state.requireValue.copyWith(
              notifications: [
                appNotification,
                ...state.requireValue.notifications,
              ],
            ),
          );
          debugPrint('FCM Message onBackground: ${appNotification.title}');
        case Failure<AppNotification>():
          break;
      }
    });

    notificationsRepository.onForeground().listen((messageResult) {
      switch (messageResult) {
        case Success<AppNotification>():
          final appNotification = messageResult.data;
          state = AsyncData(
            state.requireValue.copyWith(
              notifications: [
                appNotification,
                ...state.requireValue.notifications,
              ],
            ),
          );
          debugPrint('FCM Message onForeground: ${appNotification.title}');
        case Failure<AppNotification>():
          break;
      }
    });
  }

  /// Selects which subset of the inbox the view should display.
  void setFilter(AlertsFilter filter) {
    final current = state.asData?.value;
    if (current == null) return;

    state = AsyncData(current.copyWith(filter: filter));
  }

  /// Marks the notification identified by [messageId] as read.
  void markAsRead(String messageId) {
    final current = state.asData?.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        readMessageIds: {...current.readMessageIds, messageId},
      ),
    );
  }

  /// Marks every notification currently in the inbox as read.
  void markAllAsRead() {
    final current = state.asData?.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        readMessageIds: {
          ...current.readMessageIds,
          for (final notification in current.notifications) notification.messageId,
        },
      ),
    );
  }

  /// Removes the notification identified by [messageId] from the inbox.
  void dismiss(String messageId) {
    final current = state.asData?.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        notifications: current.notifications
            .where((notification) => notification.messageId != messageId)
            .toList(),
        readMessageIds: current.readMessageIds
            .where((id) => id != messageId)
            .toSet(),
      ),
    );
  }

  /// Removes every notification that has already been marked as read.
  void clearRead() {
    final current = state.asData?.value;
    if (current == null) return;

    final unread = current.notifications
        .where((notification) => current.isUnread(notification.messageId))
        .toList();

    state = AsyncData(
      current.copyWith(
        notifications: unread,
        readMessageIds: current.readMessageIds
            .where((id) => unread.any((notification) => notification.messageId == id))
            .toSet(),
      ),
    );
  }

  /// Records a watering action for the notification identified by [messageId].
  ///
  /// There is no backend watering endpoint for alerts yet, so - mirroring the
  /// Stitch design - recording a watering marks the alert as read.
  void registerWatering(String messageId) => markAsRead(messageId);
}
