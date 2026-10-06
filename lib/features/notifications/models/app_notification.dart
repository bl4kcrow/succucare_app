import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';
 part 'app_notification.g.dart'; 

@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String messageId,
    required String title,
    required String body,
    required DateTime sentDate,
    Map<String,dynamic>? data,
    String? imageUrl,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, Object?> json) =>
      _$AppNotificationFromJson(json);
}
