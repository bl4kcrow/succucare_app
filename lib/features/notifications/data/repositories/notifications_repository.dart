
import 'package:succucare_app/core/utils/utils.dart';
import 'package:succucare_app/features/notifications/data/models/models.dart';

abstract interface class NotificationsRepository {
  Stream<Result<AppNotification>> onForeground();
  Stream<Result<AppNotification>> onBackground();
  Future<Result<NotificationsStatus>> initNotifications();  
}