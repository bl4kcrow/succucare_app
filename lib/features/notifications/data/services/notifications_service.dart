
import 'package:succucare_app/features/notifications/data/models/models.dart';

abstract interface class NotificationsService {
  Future<NotificationsStatus> initNotifications();
  Future<String> getToken();
  Future<void> saveToken(String token);
  Stream<AppNotification> onForeground();
  Stream<AppNotification> onBackground();
}