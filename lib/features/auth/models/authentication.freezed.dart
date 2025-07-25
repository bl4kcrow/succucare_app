// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authentication.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Authentication {

 AppUser get user; AuthenticationState get authenticationState; String get token;
/// Create a copy of Authentication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationCopyWith<Authentication> get copyWith => _$AuthenticationCopyWithImpl<Authentication>(this as Authentication, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Authentication&&(identical(other.user, user) || other.user == user)&&(identical(other.authenticationState, authenticationState) || other.authenticationState == authenticationState)&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,user,authenticationState,token);

@override
String toString() {
  return 'Authentication(user: $user, authenticationState: $authenticationState, token: $token)';
}


}

/// @nodoc
abstract mixin class $AuthenticationCopyWith<$Res>  {
  factory $AuthenticationCopyWith(Authentication value, $Res Function(Authentication) _then) = _$AuthenticationCopyWithImpl;
@useResult
$Res call({
 AppUser user, AuthenticationState authenticationState, String token
});


$AppUserCopyWith<$Res> get user;

}
/// @nodoc
class _$AuthenticationCopyWithImpl<$Res>
    implements $AuthenticationCopyWith<$Res> {
  _$AuthenticationCopyWithImpl(this._self, this._then);

  final Authentication _self;
  final $Res Function(Authentication) _then;

/// Create a copy of Authentication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? authenticationState = null,Object? token = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppUser,authenticationState: null == authenticationState ? _self.authenticationState : authenticationState // ignore: cast_nullable_to_non_nullable
as AuthenticationState,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of Authentication
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUserCopyWith<$Res> get user {
  
  return $AppUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc


class _Authentication implements Authentication {
   _Authentication({required this.user, required this.authenticationState, required this.token});
  

@override final  AppUser user;
@override final  AuthenticationState authenticationState;
@override final  String token;

/// Create a copy of Authentication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticationCopyWith<_Authentication> get copyWith => __$AuthenticationCopyWithImpl<_Authentication>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Authentication&&(identical(other.user, user) || other.user == user)&&(identical(other.authenticationState, authenticationState) || other.authenticationState == authenticationState)&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,user,authenticationState,token);

@override
String toString() {
  return 'Authentication(user: $user, authenticationState: $authenticationState, token: $token)';
}


}

/// @nodoc
abstract mixin class _$AuthenticationCopyWith<$Res> implements $AuthenticationCopyWith<$Res> {
  factory _$AuthenticationCopyWith(_Authentication value, $Res Function(_Authentication) _then) = __$AuthenticationCopyWithImpl;
@override @useResult
$Res call({
 AppUser user, AuthenticationState authenticationState, String token
});


@override $AppUserCopyWith<$Res> get user;

}
/// @nodoc
class __$AuthenticationCopyWithImpl<$Res>
    implements _$AuthenticationCopyWith<$Res> {
  __$AuthenticationCopyWithImpl(this._self, this._then);

  final _Authentication _self;
  final $Res Function(_Authentication) _then;

/// Create a copy of Authentication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? authenticationState = null,Object? token = null,}) {
  return _then(_Authentication(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppUser,authenticationState: null == authenticationState ? _self.authenticationState : authenticationState // ignore: cast_nullable_to_non_nullable
as AuthenticationState,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of Authentication
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUserCopyWith<$Res> get user {
  
  return $AppUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
