
import 'package:succucare_app/features/notifications/data/models/models.dart';

abstract interface class NotificationsService {
  AppNotification onForeground();
  AppNotification onBackground();
}