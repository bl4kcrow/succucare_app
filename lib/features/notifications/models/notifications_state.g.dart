// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationsState _$NotificationsStateFromJson(Map<String, dynamic> json) =>
    _NotificationsState(
      status: $enumDecode(_$NotificationStatusEnumMap, json['status']),
      notifications: (json['notifications'] as List<dynamic>)
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NotificationsStateToJson(_NotificationsState instance) =>
    <String, dynamic>{
      'status': _$NotificationStatusEnumMap[instance.status]!,
      'notifications': instance.notifications,
    };

const _$NotificationStatusEnumMap = {
  NotificationStatus.authorized: 'authorized',
  NotificationStatus.unauthorized: 'unauthorized',
  NotificationStatus.unknown: 'unknown',
};
