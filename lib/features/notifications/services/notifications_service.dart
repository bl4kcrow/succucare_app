
import 'package:succucare_app/features/notifications/models/models.dart';

abstract interface class NotificationsService {
  AppNotification onForeground();
  AppNotification onBackground();
}