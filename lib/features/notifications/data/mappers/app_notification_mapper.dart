import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:succucare_app/features/notifications/data/models/models.dart';

class AppNotificationMapper {
  static AppNotification FirebaseMessageToAppNotification(
    RemoteMessage remoteMessage,
  ) {
    return AppNotification(
      messageId: remoteMessage.messageId ?? '',
      title: remoteMessage.notification?.title ?? '',
      body: remoteMessage.notification?.body ?? '',
      data: remoteMessage.data,
      imageUrl: remoteMessage.notification?.android?.imageUrl,
      sentDate: remoteMessage.sentTime ?? DateTime.now(),
    );
  }
}
