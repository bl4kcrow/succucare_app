import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:succucare_app/core/errors/errors.dart';

import 'package:succucare_app/features/notifications/data/mappers/mappers.dart';
import 'package:succucare_app/features/notifications/data/models/models.dart';
import 'package:succucare_app/features/notifications/data/services/services.dart';

class FirebaseCloudMessagingService implements NotificationsService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  @override
  Future<NotificationsStatus> initNotifications() async {
    NotificationsStatus notificationsStatus = NotificationsStatus.unknown;
    final NotificationSettings settings = await messaging.requestPermission(
      provisional: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      await messaging.requestPermission().then((settings) async {
        switch (settings.authorizationStatus) {
          case AuthorizationStatus.authorized:
          case AuthorizationStatus.provisional:
            notificationsStatus = NotificationsStatus.authorized;
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
      notificationsStatus = NotificationsStatus.authorized;
    }

    return notificationsStatus;
  }

  @override
  Future<String> getToken() async {
    final docRef = db.collection('users').doc('$_uid');

    try {
      final snapshot = await docRef.get();

      if (snapshot.exists) {
        return snapshot['notificationsToken'];
      } else {
        final fcmToken = await messaging.getToken();
        if (fcmToken != null) {
          await saveToken(fcmToken);
        }
        return fcmToken ?? '';
      }
    } on AppFailure {
      rethrow;
    } catch (error) {
      debugPrint('Error getting the FCM token: $error');
      throw AppFailure.from(error);
    }
  }

  @override
  Future<void> saveToken(String token) async {
    final docRef = db.collection('users').doc('$_uid');

    try {
      await docRef.set({'notificationsToken': token}, SetOptions(merge: true));
    } catch (error) {
      debugPrint('Error updating the FCM token: $error');
      throw AppFailure.from(error);
    }
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
