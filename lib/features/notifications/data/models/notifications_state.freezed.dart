// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationsState {

 NotificationsStatus get status; String get token; List<AppNotification> get notifications; AlertsFilter get filter; Set<String> get readMessageIds;
/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationsStateCopyWith<NotificationsState> get copyWith => _$NotificationsStateCopyWithImpl<NotificationsState>(this as NotificationsState, _$identity);

  /// Serializes this NotificationsState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NotificationsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.token, _this.token) || other.token == _this.token)&&const DeepCollectionEquality().equals(other.notifications, _this.notifications)&&(identical(other.filter, _this.filter) || other.filter == _this.filter)&&const DeepCollectionEquality().equals(other.readMessageIds, _this.readMessageIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NotificationsState;
  return Object.hash(runtimeType,_this.status,_this.token,const DeepCollectionEquality().hash(_this.notifications),_this.filter,const DeepCollectionEquality().hash(_this.readMessageIds));
}

@override
String toString() {
  final _this = this as NotificationsState;
  return 'NotificationsState(status: ${_this.status}, token: ${_this.token}, notifications: ${_this.notifications}, filter: ${_this.filter}, readMessageIds: ${_this.readMessageIds})';
}


}

/// @nodoc
abstract mixin class $NotificationsStateCopyWith<$Res>  {
  factory $NotificationsStateCopyWith(NotificationsState value, $Res Function(NotificationsState) _then) = _$NotificationsStateCopyWithImpl;
@useResult
$Res call({
 NotificationsStatus status, String token, List<AppNotification> notifications, AlertsFilter filter, Set<String> readMessageIds
});




}
/// @nodoc
class _$NotificationsStateCopyWithImpl<$Res>
    implements $NotificationsStateCopyWith<$Res> {
  _$NotificationsStateCopyWithImpl(this._self, this._then);

  final NotificationsState _self;
  final $Res Function(NotificationsState) _then;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? token = null,Object? notifications = null,Object? filter = null,Object? readMessageIds = null,}) {
  return _then(NotificationsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NotificationsStatus,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,notifications: null == notifications ? _self.notifications : notifications // ignore: cast_nullable_to_non_nullable
as List<AppNotification>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as AlertsFilter,readMessageIds: null == readMessageIds ? _self.readMessageIds : readMessageIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationsState].
extension NotificationsStatePatterns on NotificationsState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationsState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationsState value)  $default,){
final _that = this;
switch (_that) {
case _NotificationsState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationsState value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationsState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NotificationsStatus status,  String token,  List<AppNotification> notifications,  AlertsFilter filter,  Set<String> readMessageIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationsState() when $default != null:
return $default(_that.status,_that.token,_that.notifications,_that.filter,_that.readMessageIds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NotificationsStatus status,  String token,  List<AppNotification> notifications,  AlertsFilter filter,  Set<String> readMessageIds)  $default,) {final _that = this;
switch (_that) {
case _NotificationsState():
return $default(_that.status,_that.token,_that.notifications,_that.filter,_that.readMessageIds);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NotificationsStatus status,  String token,  List<AppNotification> notifications,  AlertsFilter filter,  Set<String> readMessageIds)?  $default,) {final _that = this;
switch (_that) {
case _NotificationsState() when $default != null:
return $default(_that.status,_that.token,_that.notifications,_that.filter,_that.readMessageIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationsState extends NotificationsState {
  const _NotificationsState({required this.status, required this.token, required  List<AppNotification> notifications, this.filter = AlertsFilter.all,  Set<String> readMessageIds = const <String>{}}): _notifications = notifications,_readMessageIds = readMessageIds,super._();
  factory _NotificationsState.fromJson(Map<String, dynamic> json) => _$NotificationsStateFromJson(json);

@override final  NotificationsStatus status;
@override final  String token;
 final  List<AppNotification> _notifications;
@override List<AppNotification> get notifications {
  if (_notifications is EqualUnmodifiableListView) return _notifications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notifications);
}

@override@JsonKey() final  AlertsFilter filter;
 final  Set<String> _readMessageIds;
@override@JsonKey() Set<String> get readMessageIds {
  if (_readMessageIds is EqualUnmodifiableSetView) return _readMessageIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_readMessageIds);
}


/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationsStateCopyWith<_NotificationsState> get copyWith => __$NotificationsStateCopyWithImpl<_NotificationsState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationsStateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationsState&&(identical(other.status, status) || other.status == status)&&(identical(other.token, token) || other.token == token)&&const DeepCollectionEquality().equals(other.notifications, _notifications)&&(identical(other.filter, filter) || other.filter == filter)&&const DeepCollectionEquality().equals(other.readMessageIds, _readMessageIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status,token,const DeepCollectionEquality().hash(_notifications),filter,const DeepCollectionEquality().hash(_readMessageIds));
}

@override
String toString() {
    return 'NotificationsState(status: $status, token: $token, notifications: $notifications, filter: $filter, readMessageIds: $readMessageIds)';
}


}

/// @nodoc
abstract mixin class _$NotificationsStateCopyWith<$Res> implements $NotificationsStateCopyWith<$Res> {
  factory _$NotificationsStateCopyWith(_NotificationsState value, $Res Function(_NotificationsState) _then) = __$NotificationsStateCopyWithImpl;
@override @useResult
$Res call({
 NotificationsStatus status, String token, List<AppNotification> notifications, AlertsFilter filter, Set<String> readMessageIds
});




}
/// @nodoc
class __$NotificationsStateCopyWithImpl<$Res>
    implements _$NotificationsStateCopyWith<$Res> {
  __$NotificationsStateCopyWithImpl(this._self, this._then);

  final _NotificationsState _self;
  final $Res Function(_NotificationsState) _then;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? token = null,Object? notifications = null,Object? filter = null,Object? readMessageIds = null,}) {
  return _then(_NotificationsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NotificationsStatus,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,notifications: null == notifications ? _self._notifications : notifications // ignore: cast_nullable_to_non_nullable
as List<AppNotification>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as AlertsFilter,readMessageIds: null == readMessageIds ? _self._readMessageIds : readMessageIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
