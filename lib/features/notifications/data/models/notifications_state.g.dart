// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationsState _$NotificationsStateFromJson(Map<String, dynamic> json) =>
    _NotificationsState(
      status: $enumDecode(_$NotificationsStatusEnumMap, json['status']),
      token: json['token'] as String,
      notifications: (json['notifications'] as List<dynamic>)
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList(),
      filter:
          $enumDecodeNullable(_$AlertsFilterEnumMap, json['filter']) ??
          AlertsFilter.all,
      readMessageIds:
          (json['readMessageIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const <String>{},
    );

Map<String, dynamic> _$NotificationsStateToJson(_NotificationsState instance) =>
    <String, dynamic>{
      'status': _$NotificationsStatusEnumMap[instance.status]!,
      'token': instance.token,
      'notifications': instance.notifications,
      'filter': _$AlertsFilterEnumMap[instance.filter]!,
      'readMessageIds': instance.readMessageIds.toList(),
    };

const _$NotificationsStatusEnumMap = {
  NotificationsStatus.authorized: 'authorized',
  NotificationsStatus.unauthorized: 'unauthorized',
  NotificationsStatus.unknown: 'unknown',
};

const _$AlertsFilterEnumMap = {
  AlertsFilter.all: 'all',
  AlertsFilter.unread: 'unread',
};
