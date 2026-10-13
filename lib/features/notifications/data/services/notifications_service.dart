
import 'package:succucare_app/features/notifications/data/models/models.dart';

abstract interface class NotificationsService {
  Stream<AppNotification> onForeground();
  Stream<AppNotification> onBackground();
  Future<NotificationsStatus> initNotifications();
}