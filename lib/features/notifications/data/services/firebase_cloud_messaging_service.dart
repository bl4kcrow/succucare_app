import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'package:succucare_app/features/notifications/data/mappers/mappers.dart';
import 'package:succucare_app/features/notifications/data/models/models.dart';
import 'package:succucare_app/features/notifications/data/services/services.dart';

class FirebaseCloudMessagingService implements NotificationsService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  Future<NotificationsStatus> initNotifications() async {
    NotificationsStatus notificationsStatus = NotificationsStatus.unknown;
    final NotificationSettings settings = await messaging.requestPermission(
      provisional: true,
    );

    String? firebaseMessagingToken;

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      await messaging.requestPermission().then((settings) async {
        switch (settings.authorizationStatus) {
          case AuthorizationStatus.authorized:
          case AuthorizationStatus.provisional:
            notificationsStatus = NotificationsStatus.authorized;
            firebaseMessagingToken = await messaging.getToken();
            break;
          case AuthorizationStatus.denied:
          case AuthorizationStatus.deniedPermanently:
            notificationsStatus = NotificationsStatus.unauthorized;
            break;
          case AuthorizationStatus.notDetermined:
            notificationsStatus = NotificationsStatus.unknown;
        }
      });
    } else {
      firebaseMessagingToken = await messaging.getToken();
    }

    debugPrint('FCM Token: $firebaseMessagingToken');

    return notificationsStatus;
  }

  @override
  Stream<AppNotification> onBackground() {
    StreamController<AppNotification> controller =
        StreamController<AppNotification>();

    FirebaseMessaging.onMessageOpenedApp.listen(
      (remoteMessage) {
        final AppNotification appNotification =
            AppNotificationMapper.FirebaseMessageToAppNotification(
              remoteMessage,
            );
        controller.add(appNotification);
      },
      onError: (Object error, StackTrace stackTrace) {
        controller.close();
      },
      onDone: controller.close,
    );

    return controller.stream;
  }

  @override
  Stream<AppNotification> onForeground() {
    StreamController<AppNotification> controller =
        StreamController<AppNotification>();

    FirebaseMessaging.onMessage.listen(
      (remoteMessage) {
        final AppNotification appNotification =
            AppNotificationMapper.FirebaseMessageToAppNotification(
              remoteMessage,
            );
        controller.add(appNotification);
      },
      onError: (Object error, StackTrace stackTrace) {
        controller.close();
      },
      onDone: controller.close,
    );

    return controller.stream;
  }
}
