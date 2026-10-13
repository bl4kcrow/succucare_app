import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:succucare_app/core/utils/utils.dart';
import 'package:succucare_app/features/notifications/data/models/models.dart';
import 'package:succucare_app/features/notifications/data/repositories/repositories.dart';
import 'package:succucare_app/features/notifications/data/services/services.dart';

part 'notifications_repository_impl.g.dart';

@riverpod
NotificationsRepository notificationsRepository(Ref ref) =>
    NotificationsRepositoryImpl(
      notificationsService: FirebaseCloudMessagingService(),
    );

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl({required this.notificationsService});
  final NotificationsService notificationsService;

  @override
  Stream<Result<AppNotification>> onBackground() {
    StreamController<Result<AppNotification>> controller =
        StreamController<Result<AppNotification>>();

    try {
      notificationsService.onBackground().listen((onData) {
        controller.add(Success(onData));
      });
    } catch (error) {
      controller.add(Failure(UnknownError(error.toString())));
    }

    return controller.stream;
  }

  @override
  Stream<Result<AppNotification>> onForeground() {
    StreamController<Result<AppNotification>> controller =
        StreamController<Result<AppNotification>>();

    try {
      notificationsService.onForeground().listen((onData) {
        controller.add(Success(onData));
      });
    } catch (error) {
      controller.add(Failure(UnknownError(error.toString())));
    }

    return controller.stream;
  }

  @override
  Future<Result<NotificationsStatus>> initNotifications() async {
    try {
      return Success(await notificationsService.initNotifications());
    } catch (error) {
      return Failure(UnknownError(error.toString()));
    }
  }
}
