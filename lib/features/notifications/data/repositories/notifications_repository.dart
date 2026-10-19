
import 'package:succucare_app/core/utils/utils.dart';
import 'package:succucare_app/features/notifications/data/models/models.dart';

abstract interface class NotificationsRepository {
  Future<Result<NotificationsStatus>> initNotifications();
  Future<Result<String>> getToken();
  Future<void> saveToken(String token);
  Stream<Result<AppNotification>> onForeground();
  Stream<Result<AppNotification>> onBackground();
}