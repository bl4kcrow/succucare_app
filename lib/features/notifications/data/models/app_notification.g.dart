// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      messageId: json['messageId'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      sentDate: DateTime.parse(json['sentDate'] as String),
      data: json['data'] as Map<String, dynamic>?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'title': instance.title,
      'body': instance.body,
      'sentDate': instance.sentDate.toIso8601String(),
      'data': instance.data,
      'imageUrl': instance.imageUrl,
    };
