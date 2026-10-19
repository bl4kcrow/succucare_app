// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppNotification {

 String get messageId; String get title; String get body; DateTime get sentDate; Map<String, dynamic>? get data; String? get imageUrl;
/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppNotificationCopyWith<AppNotification> get copyWith => _$AppNotificationCopyWithImpl<AppNotification>(this as AppNotification, _$identity);

  /// Serializes this AppNotification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppNotification;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppNotification&&(identical(other.messageId, _this.messageId) || other.messageId == _this.messageId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.sentDate, _this.sentDate) || other.sentDate == _this.sentDate)&&const DeepCollectionEquality().equals(other.data, _this.data)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppNotification;
  return Object.hash(runtimeType,_this.messageId,_this.title,_this.body,_this.sentDate,const DeepCollectionEquality().hash(_this.data),_this.imageUrl);
}

@override
String toString() {
  final _this = this as AppNotification;
  return 'AppNotification(messageId: ${_this.messageId}, title: ${_this.title}, body: ${_this.body}, sentDate: ${_this.sentDate}, data: ${_this.data}, imageUrl: ${_this.imageUrl})';
}


}

/// @nodoc
abstract mixin class $AppNotificationCopyWith<$Res>  {
  factory $AppNotificationCopyWith(AppNotification value, $Res Function(AppNotification) _then) = _$AppNotificationCopyWithImpl;
@useResult
$Res call({
 String messageId, String title, String body, DateTime sentDate, Map<String, dynamic>? data, String? imageUrl
});




}
/// @nodoc
class _$AppNotificationCopyWithImpl<$Res>
    implements $AppNotificationCopyWith<$Res> {
  _$AppNotificationCopyWithImpl(this._self, this._then);

  final AppNotification _self;
  final $Res Function(AppNotification) _then;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? title = null,Object? body = null,Object? sentDate = null,Object? data = freezed,Object? imageUrl = freezed,}) {
  return _then(AppNotification(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,sentDate: null == sentDate ? _self.sentDate : sentDate // ignore: cast_nullable_to_non_nullable
as DateTime,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppNotification].
extension AppNotificationPatterns on AppNotification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppNotification value)  $default,){
final _that = this;
switch (_that) {
case _AppNotification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppNotification value)?  $default,){
final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String messageId,  String title,  String body,  DateTime sentDate,  Map<String, dynamic>? data,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that.messageId,_that.title,_that.body,_that.sentDate,_that.data,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String messageId,  String title,  String body,  DateTime sentDate,  Map<String, dynamic>? data,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _AppNotification():
return $default(_that.messageId,_that.title,_that.body,_that.sentDate,_that.data,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String messageId,  String title,  String body,  DateTime sentDate,  Map<String, dynamic>? data,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that.messageId,_that.title,_that.body,_that.sentDate,_that.data,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppNotification implements AppNotification {
  const _AppNotification({required this.messageId, required this.title, required this.body, required this.sentDate,  Map<String, dynamic>? data, this.imageUrl}): _data = data;
  factory _AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);

@override final  String messageId;
@override final  String title;
@override final  String body;
@override final  DateTime sentDate;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? imageUrl;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppNotificationCopyWith<_AppNotification> get copyWith => __$AppNotificationCopyWithImpl<_AppNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppNotificationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppNotification&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.sentDate, sentDate) || other.sentDate == sentDate)&&const DeepCollectionEquality().equals(other.data, _data)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,messageId,title,body,sentDate,const DeepCollectionEquality().hash(_data),imageUrl);
}

@override
String toString() {
    return 'AppNotification(messageId: $messageId, title: $title, body: $body, sentDate: $sentDate, data: $data, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$AppNotificationCopyWith<$Res> implements $AppNotificationCopyWith<$Res> {
  factory _$AppNotificationCopyWith(_AppNotification value, $Res Function(_AppNotification) _then) = __$AppNotificationCopyWithImpl;
@override @useResult
$Res call({
 String messageId, String title, String body, DateTime sentDate, Map<String, dynamic>? data, String? imageUrl
});




}
/// @nodoc
class __$AppNotificationCopyWithImpl<$Res>
    implements _$AppNotificationCopyWith<$Res> {
  __$AppNotificationCopyWithImpl(this._self, this._then);

  final _AppNotification _self;
  final $Res Function(_AppNotification) _then;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? title = null,Object? body = null,Object? sentDate = null,Object? data = freezed,Object? imageUrl = freezed,}) {
  return _then(_AppNotification(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,sentDate: null == sentDate ? _self.sentDate : sentDate // ignore: cast_nullable_to_non_nullable
as DateTime,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
