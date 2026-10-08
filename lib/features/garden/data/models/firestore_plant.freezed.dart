// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firestore_plant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FirestoreMoisture {

 String get level; String get source;@TimestampConverter() DateTime get updatedAt;
/// Create a copy of FirestoreMoisture
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FirestoreMoistureCopyWith<FirestoreMoisture> get copyWith => _$FirestoreMoistureCopyWithImpl<FirestoreMoisture>(this as FirestoreMoisture, _$identity);

  /// Serializes this FirestoreMoisture to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FirestoreMoisture;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FirestoreMoisture&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FirestoreMoisture;
  return Object.hash(runtimeType,_this.level,_this.source,_this.updatedAt);
}

@override
String toString() {
  final _this = this as FirestoreMoisture;
  return 'FirestoreMoisture(level: ${_this.level}, source: ${_this.source}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $FirestoreMoistureCopyWith<$Res>  {
  factory $FirestoreMoistureCopyWith(FirestoreMoisture value, $Res Function(FirestoreMoisture) _then) = _$FirestoreMoistureCopyWithImpl;
@useResult
$Res call({
 String level, String source,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class _$FirestoreMoistureCopyWithImpl<$Res>
    implements $FirestoreMoistureCopyWith<$Res> {
  _$FirestoreMoistureCopyWithImpl(this._self, this._then);

  final FirestoreMoisture _self;
  final $Res Function(FirestoreMoisture) _then;

/// Create a copy of FirestoreMoisture
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? source = null,Object? updatedAt = null,}) {
  return _then(FirestoreMoisture(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FirestoreMoisture].
extension FirestoreMoisturePatterns on FirestoreMoisture {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FirestoreMoisture value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FirestoreMoisture() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FirestoreMoisture value)  $default,){
final _that = this;
switch (_that) {
case _FirestoreMoisture():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FirestoreMoisture value)?  $default,){
final _that = this;
switch (_that) {
case _FirestoreMoisture() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String level,  String source, @TimestampConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FirestoreMoisture() when $default != null:
return $default(_that.level,_that.source,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String level,  String source, @TimestampConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FirestoreMoisture():
return $default(_that.level,_that.source,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String level,  String source, @TimestampConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FirestoreMoisture() when $default != null:
return $default(_that.level,_that.source,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FirestoreMoisture implements FirestoreMoisture {
  const _FirestoreMoisture({required this.level, required this.source, @TimestampConverter() required this.updatedAt});
  factory _FirestoreMoisture.fromJson(Map<String, dynamic> json) => _$FirestoreMoistureFromJson(json);

@override final  String level;
@override final  String source;
@override@TimestampConverter() final  DateTime updatedAt;

/// Create a copy of FirestoreMoisture
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FirestoreMoistureCopyWith<_FirestoreMoisture> get copyWith => __$FirestoreMoistureCopyWithImpl<_FirestoreMoisture>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FirestoreMoistureToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FirestoreMoisture&&(identical(other.level, level) || other.level == level)&&(identical(other.source, source) || other.source == source)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,level,source,updatedAt);
}

@override
String toString() {
    return 'FirestoreMoisture(level: $level, source: $source, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FirestoreMoistureCopyWith<$Res> implements $FirestoreMoistureCopyWith<$Res> {
  factory _$FirestoreMoistureCopyWith(_FirestoreMoisture value, $Res Function(_FirestoreMoisture) _then) = __$FirestoreMoistureCopyWithImpl;
@override @useResult
$Res call({
 String level, String source,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class __$FirestoreMoistureCopyWithImpl<$Res>
    implements _$FirestoreMoistureCopyWith<$Res> {
  __$FirestoreMoistureCopyWithImpl(this._self, this._then);

  final _FirestoreMoisture _self;
  final $Res Function(_FirestoreMoisture) _then;

/// Create a copy of FirestoreMoisture
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? source = null,Object? updatedAt = null,}) {
  return _then(_FirestoreMoisture(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$FirestoreIllumination {

 String get current; String get target;@TimestampConverter() DateTime get updatedAt;
/// Create a copy of FirestoreIllumination
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FirestoreIlluminationCopyWith<FirestoreIllumination> get copyWith => _$FirestoreIlluminationCopyWithImpl<FirestoreIllumination>(this as FirestoreIllumination, _$identity);

  /// Serializes this FirestoreIllumination to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FirestoreIllumination;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FirestoreIllumination&&(identical(other.current, _this.current) || other.current == _this.current)&&(identical(other.target, _this.target) || other.target == _this.target)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FirestoreIllumination;
  return Object.hash(runtimeType,_this.current,_this.target,_this.updatedAt);
}

@override
String toString() {
  final _this = this as FirestoreIllumination;
  return 'FirestoreIllumination(current: ${_this.current}, target: ${_this.target}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $FirestoreIlluminationCopyWith<$Res>  {
  factory $FirestoreIlluminationCopyWith(FirestoreIllumination value, $Res Function(FirestoreIllumination) _then) = _$FirestoreIlluminationCopyWithImpl;
@useResult
$Res call({
 String current, String target,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class _$FirestoreIlluminationCopyWithImpl<$Res>
    implements $FirestoreIlluminationCopyWith<$Res> {
  _$FirestoreIlluminationCopyWithImpl(this._self, this._then);

  final FirestoreIllumination _self;
  final $Res Function(FirestoreIllumination) _then;

/// Create a copy of FirestoreIllumination
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? current = null,Object? target = null,Object? updatedAt = null,}) {
  return _then(FirestoreIllumination(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FirestoreIllumination].
extension FirestoreIlluminationPatterns on FirestoreIllumination {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FirestoreIllumination value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FirestoreIllumination() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FirestoreIllumination value)  $default,){
final _that = this;
switch (_that) {
case _FirestoreIllumination():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FirestoreIllumination value)?  $default,){
final _that = this;
switch (_that) {
case _FirestoreIllumination() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String current,  String target, @TimestampConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FirestoreIllumination() when $default != null:
return $default(_that.current,_that.target,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String current,  String target, @TimestampConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FirestoreIllumination():
return $default(_that.current,_that.target,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String current,  String target, @TimestampConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FirestoreIllumination() when $default != null:
return $default(_that.current,_that.target,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FirestoreIllumination implements FirestoreIllumination {
  const _FirestoreIllumination({required this.current, required this.target, @TimestampConverter() required this.updatedAt});
  factory _FirestoreIllumination.fromJson(Map<String, dynamic> json) => _$FirestoreIlluminationFromJson(json);

@override final  String current;
@override final  String target;
@override@TimestampConverter() final  DateTime updatedAt;

/// Create a copy of FirestoreIllumination
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FirestoreIlluminationCopyWith<_FirestoreIllumination> get copyWith => __$FirestoreIlluminationCopyWithImpl<_FirestoreIllumination>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FirestoreIlluminationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FirestoreIllumination&&(identical(other.current, current) || other.current == current)&&(identical(other.target, target) || other.target == target)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,current,target,updatedAt);
}

@override
String toString() {
    return 'FirestoreIllumination(current: $current, target: $target, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FirestoreIlluminationCopyWith<$Res> implements $FirestoreIlluminationCopyWith<$Res> {
  factory _$FirestoreIlluminationCopyWith(_FirestoreIllumination value, $Res Function(_FirestoreIllumination) _then) = __$FirestoreIlluminationCopyWithImpl;
@override @useResult
$Res call({
 String current, String target,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class __$FirestoreIlluminationCopyWithImpl<$Res>
    implements _$FirestoreIlluminationCopyWith<$Res> {
  __$FirestoreIlluminationCopyWithImpl(this._self, this._then);

  final _FirestoreIllumination _self;
  final $Res Function(_FirestoreIllumination) _then;

/// Create a copy of FirestoreIllumination
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? current = null,Object? target = null,Object? updatedAt = null,}) {
  return _then(_FirestoreIllumination(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$FirestorePlant {

 String get id; String get commonName; String get scientificName; String get category; String get primaryPhotoUrl; String get healthStatus; bool get lightingChange; bool get needsWater; bool get repotting; FirestoreMoisture get moisture; FirestoreIllumination get illumination;@TimestampConverter() DateTime? get lastWateredAt; int get wateringIntervalDays;@TimestampConverter() DateTime? get nextWateringAt; List<String> get searchKeywords; String get notes;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt;
/// Create a copy of FirestorePlant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FirestorePlantCopyWith<FirestorePlant> get copyWith => _$FirestorePlantCopyWithImpl<FirestorePlant>(this as FirestorePlant, _$identity);

  /// Serializes this FirestorePlant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FirestorePlant;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FirestorePlant&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.commonName, _this.commonName) || other.commonName == _this.commonName)&&(identical(other.scientificName, _this.scientificName) || other.scientificName == _this.scientificName)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.primaryPhotoUrl, _this.primaryPhotoUrl) || other.primaryPhotoUrl == _this.primaryPhotoUrl)&&(identical(other.healthStatus, _this.healthStatus) || other.healthStatus == _this.healthStatus)&&(identical(other.lightingChange, _this.lightingChange) || other.lightingChange == _this.lightingChange)&&(identical(other.needsWater, _this.needsWater) || other.needsWater == _this.needsWater)&&(identical(other.repotting, _this.repotting) || other.repotting == _this.repotting)&&(identical(other.moisture, _this.moisture) || other.moisture == _this.moisture)&&(identical(other.illumination, _this.illumination) || other.illumination == _this.illumination)&&(identical(other.lastWateredAt, _this.lastWateredAt) || other.lastWateredAt == _this.lastWateredAt)&&(identical(other.wateringIntervalDays, _this.wateringIntervalDays) || other.wateringIntervalDays == _this.wateringIntervalDays)&&(identical(other.nextWateringAt, _this.nextWateringAt) || other.nextWateringAt == _this.nextWateringAt)&&const DeepCollectionEquality().equals(other.searchKeywords, _this.searchKeywords)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FirestorePlant;
  return Object.hash(runtimeType,_this.id,_this.commonName,_this.scientificName,_this.category,_this.primaryPhotoUrl,_this.healthStatus,_this.lightingChange,_this.needsWater,_this.repotting,_this.moisture,_this.illumination,_this.lastWateredAt,_this.wateringIntervalDays,_this.nextWateringAt,const DeepCollectionEquality().hash(_this.searchKeywords),_this.notes,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as FirestorePlant;
  return 'FirestorePlant(id: ${_this.id}, commonName: ${_this.commonName}, scientificName: ${_this.scientificName}, category: ${_this.category}, primaryPhotoUrl: ${_this.primaryPhotoUrl}, healthStatus: ${_this.healthStatus}, lightingChange: ${_this.lightingChange}, needsWater: ${_this.needsWater}, repotting: ${_this.repotting}, moisture: ${_this.moisture}, illumination: ${_this.illumination}, lastWateredAt: ${_this.lastWateredAt}, wateringIntervalDays: ${_this.wateringIntervalDays}, nextWateringAt: ${_this.nextWateringAt}, searchKeywords: ${_this.searchKeywords}, notes: ${_this.notes}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $FirestorePlantCopyWith<$Res>  {
  factory $FirestorePlantCopyWith(FirestorePlant value, $Res Function(FirestorePlant) _then) = _$FirestorePlantCopyWithImpl;
@useResult
$Res call({
 String id, String commonName, String scientificName, String category, String primaryPhotoUrl, String healthStatus, bool lightingChange, bool needsWater, bool repotting, FirestoreMoisture moisture, FirestoreIllumination illumination,@TimestampConverter() DateTime? lastWateredAt, int wateringIntervalDays,@TimestampConverter() DateTime? nextWateringAt, List<String> searchKeywords, String notes,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});


$FirestoreMoistureCopyWith<$Res> get moisture;$FirestoreIlluminationCopyWith<$Res> get illumination;

}
/// @nodoc
class _$FirestorePlantCopyWithImpl<$Res>
    implements $FirestorePlantCopyWith<$Res> {
  _$FirestorePlantCopyWithImpl(this._self, this._then);

  final FirestorePlant _self;
  final $Res Function(FirestorePlant) _then;

/// Create a copy of FirestorePlant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? commonName = null,Object? scientificName = null,Object? category = null,Object? primaryPhotoUrl = null,Object? healthStatus = null,Object? lightingChange = null,Object? needsWater = null,Object? repotting = null,Object? moisture = null,Object? illumination = null,Object? lastWateredAt = freezed,Object? wateringIntervalDays = null,Object? nextWateringAt = freezed,Object? searchKeywords = null,Object? notes = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(FirestorePlant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,commonName: null == commonName ? _self.commonName : commonName // ignore: cast_nullable_to_non_nullable
as String,scientificName: null == scientificName ? _self.scientificName : scientificName // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,primaryPhotoUrl: null == primaryPhotoUrl ? _self.primaryPhotoUrl : primaryPhotoUrl // ignore: cast_nullable_to_non_nullable
as String,healthStatus: null == healthStatus ? _self.healthStatus : healthStatus // ignore: cast_nullable_to_non_nullable
as String,lightingChange: null == lightingChange ? _self.lightingChange : lightingChange // ignore: cast_nullable_to_non_nullable
as bool,needsWater: null == needsWater ? _self.needsWater : needsWater // ignore: cast_nullable_to_non_nullable
as bool,repotting: null == repotting ? _self.repotting : repotting // ignore: cast_nullable_to_non_nullable
as bool,moisture: null == moisture ? _self.moisture : moisture // ignore: cast_nullable_to_non_nullable
as FirestoreMoisture,illumination: null == illumination ? _self.illumination : illumination // ignore: cast_nullable_to_non_nullable
as FirestoreIllumination,lastWateredAt: freezed == lastWateredAt ? _self.lastWateredAt : lastWateredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,wateringIntervalDays: null == wateringIntervalDays ? _self.wateringIntervalDays : wateringIntervalDays // ignore: cast_nullable_to_non_nullable
as int,nextWateringAt: freezed == nextWateringAt ? _self.nextWateringAt : nextWateringAt // ignore: cast_nullable_to_non_nullable
as DateTime?,searchKeywords: null == searchKeywords ? _self.searchKeywords : searchKeywords // ignore: cast_nullable_to_non_nullable
as List<String>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of FirestorePlant
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FirestoreMoistureCopyWith<$Res> get moisture {
  
  return $FirestoreMoistureCopyWith<$Res>(_self.moisture, (value) {
    return _then(_self.copyWith(moisture: value));
  });
}/// Create a copy of FirestorePlant
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FirestoreIlluminationCopyWith<$Res> get illumination {
  
  return $FirestoreIlluminationCopyWith<$Res>(_self.illumination, (value) {
    return _then(_self.copyWith(illumination: value));
  });
}
}


/// Adds pattern-matching-related methods to [FirestorePlant].
extension FirestorePlantPatterns on FirestorePlant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FirestorePlant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FirestorePlant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FirestorePlant value)  $default,){
final _that = this;
switch (_that) {
case _FirestorePlant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FirestorePlant value)?  $default,){
final _that = this;
switch (_that) {
case _FirestorePlant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String commonName,  String scientificName,  String category,  String primaryPhotoUrl,  String healthStatus,  bool lightingChange,  bool needsWater,  bool repotting,  FirestoreMoisture moisture,  FirestoreIllumination illumination, @TimestampConverter()  DateTime? lastWateredAt,  int wateringIntervalDays, @TimestampConverter()  DateTime? nextWateringAt,  List<String> searchKeywords,  String notes, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FirestorePlant() when $default != null:
return $default(_that.id,_that.commonName,_that.scientificName,_that.category,_that.primaryPhotoUrl,_that.healthStatus,_that.lightingChange,_that.needsWater,_that.repotting,_that.moisture,_that.illumination,_that.lastWateredAt,_that.wateringIntervalDays,_that.nextWateringAt,_that.searchKeywords,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String commonName,  String scientificName,  String category,  String primaryPhotoUrl,  String healthStatus,  bool lightingChange,  bool needsWater,  bool repotting,  FirestoreMoisture moisture,  FirestoreIllumination illumination, @TimestampConverter()  DateTime? lastWateredAt,  int wateringIntervalDays, @TimestampConverter()  DateTime? nextWateringAt,  List<String> searchKeywords,  String notes, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FirestorePlant():
return $default(_that.id,_that.commonName,_that.scientificName,_that.category,_that.primaryPhotoUrl,_that.healthStatus,_that.lightingChange,_that.needsWater,_that.repotting,_that.moisture,_that.illumination,_that.lastWateredAt,_that.wateringIntervalDays,_that.nextWateringAt,_that.searchKeywords,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String commonName,  String scientificName,  String category,  String primaryPhotoUrl,  String healthStatus,  bool lightingChange,  bool needsWater,  bool repotting,  FirestoreMoisture moisture,  FirestoreIllumination illumination, @TimestampConverter()  DateTime? lastWateredAt,  int wateringIntervalDays, @TimestampConverter()  DateTime? nextWateringAt,  List<String> searchKeywords,  String notes, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FirestorePlant() when $default != null:
return $default(_that.id,_that.commonName,_that.scientificName,_that.category,_that.primaryPhotoUrl,_that.healthStatus,_that.lightingChange,_that.needsWater,_that.repotting,_that.moisture,_that.illumination,_that.lastWateredAt,_that.wateringIntervalDays,_that.nextWateringAt,_that.searchKeywords,_that.notes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _FirestorePlant implements FirestorePlant {
  const _FirestorePlant({required this.id, required this.commonName, required this.scientificName, required this.category, required this.primaryPhotoUrl, required this.healthStatus, required this.lightingChange, required this.needsWater, required this.repotting, required this.moisture, required this.illumination, @TimestampConverter() this.lastWateredAt, required this.wateringIntervalDays, @TimestampConverter() this.nextWateringAt, required  List<String> searchKeywords, required this.notes, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt}): _searchKeywords = searchKeywords;
  factory _FirestorePlant.fromJson(Map<String, dynamic> json) => _$FirestorePlantFromJson(json);

@override final  String id;
@override final  String commonName;
@override final  String scientificName;
@override final  String category;
@override final  String primaryPhotoUrl;
@override final  String healthStatus;
@override final  bool lightingChange;
@override final  bool needsWater;
@override final  bool repotting;
@override final  FirestoreMoisture moisture;
@override final  FirestoreIllumination illumination;
@override@TimestampConverter() final  DateTime? lastWateredAt;
@override final  int wateringIntervalDays;
@override@TimestampConverter() final  DateTime? nextWateringAt;
 final  List<String> _searchKeywords;
@override List<String> get searchKeywords {
  if (_searchKeywords is EqualUnmodifiableListView) return _searchKeywords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchKeywords);
}

@override final  String notes;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;

/// Create a copy of FirestorePlant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FirestorePlantCopyWith<_FirestorePlant> get copyWith => __$FirestorePlantCopyWithImpl<_FirestorePlant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FirestorePlantToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FirestorePlant&&(identical(other.id, id) || other.id == id)&&(identical(other.commonName, commonName) || other.commonName == commonName)&&(identical(other.scientificName, scientificName) || other.scientificName == scientificName)&&(identical(other.category, category) || other.category == category)&&(identical(other.primaryPhotoUrl, primaryPhotoUrl) || other.primaryPhotoUrl == primaryPhotoUrl)&&(identical(other.healthStatus, healthStatus) || other.healthStatus == healthStatus)&&(identical(other.lightingChange, lightingChange) || other.lightingChange == lightingChange)&&(identical(other.needsWater, needsWater) || other.needsWater == needsWater)&&(identical(other.repotting, repotting) || other.repotting == repotting)&&(identical(other.moisture, moisture) || other.moisture == moisture)&&(identical(other.illumination, illumination) || other.illumination == illumination)&&(identical(other.lastWateredAt, lastWateredAt) || other.lastWateredAt == lastWateredAt)&&(identical(other.wateringIntervalDays, wateringIntervalDays) || other.wateringIntervalDays == wateringIntervalDays)&&(identical(other.nextWateringAt, nextWateringAt) || other.nextWateringAt == nextWateringAt)&&const DeepCollectionEquality().equals(other.searchKeywords, _searchKeywords)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,commonName,scientificName,category,primaryPhotoUrl,healthStatus,lightingChange,needsWater,repotting,moisture,illumination,lastWateredAt,wateringIntervalDays,nextWateringAt,const DeepCollectionEquality().hash(_searchKeywords),notes,createdAt,updatedAt);
}

@override
String toString() {
    return 'FirestorePlant(id: $id, commonName: $commonName, scientificName: $scientificName, category: $category, primaryPhotoUrl: $primaryPhotoUrl, healthStatus: $healthStatus, lightingChange: $lightingChange, needsWater: $needsWater, repotting: $repotting, moisture: $moisture, illumination: $illumination, lastWateredAt: $lastWateredAt, wateringIntervalDays: $wateringIntervalDays, nextWateringAt: $nextWateringAt, searchKeywords: $searchKeywords, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FirestorePlantCopyWith<$Res> implements $FirestorePlantCopyWith<$Res> {
  factory _$FirestorePlantCopyWith(_FirestorePlant value, $Res Function(_FirestorePlant) _then) = __$FirestorePlantCopyWithImpl;
@override @useResult
$Res call({
 String id, String commonName, String scientificName, String category, String primaryPhotoUrl, String healthStatus, bool lightingChange, bool needsWater, bool repotting, FirestoreMoisture moisture, FirestoreIllumination illumination,@TimestampConverter() DateTime? lastWateredAt, int wateringIntervalDays,@TimestampConverter() DateTime? nextWateringAt, List<String> searchKeywords, String notes,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});


@override $FirestoreMoistureCopyWith<$Res> get moisture;@override $FirestoreIlluminationCopyWith<$Res> get illumination;

}
/// @nodoc
class __$FirestorePlantCopyWithImpl<$Res>
    implements _$FirestorePlantCopyWith<$Res> {
  __$FirestorePlantCopyWithImpl(this._self, this._then);

  final _FirestorePlant _self;
  final $Res Function(_FirestorePlant) _then;

/// Create a copy of FirestorePlant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? commonName = null,Object? scientificName = null,Object? category = null,Object? primaryPhotoUrl = null,Object? healthStatus = null,Object? lightingChange = null,Object? needsWater = null,Object? repotting = null,Object? moisture = null,Object? illumination = null,Object? lastWateredAt = freezed,Object? wateringIntervalDays = null,Object? nextWateringAt = freezed,Object? searchKeywords = null,Object? notes = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_FirestorePlant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,commonName: null == commonName ? _self.commonName : commonName // ignore: cast_nullable_to_non_nullable
as String,scientificName: null == scientificName ? _self.scientificName : scientificName // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,primaryPhotoUrl: null == primaryPhotoUrl ? _self.primaryPhotoUrl : primaryPhotoUrl // ignore: cast_nullable_to_non_nullable
as String,healthStatus: null == healthStatus ? _self.healthStatus : healthStatus // ignore: cast_nullable_to_non_nullable
as String,lightingChange: null == lightingChange ? _self.lightingChange : lightingChange // ignore: cast_nullable_to_non_nullable
as bool,needsWater: null == needsWater ? _self.needsWater : needsWater // ignore: cast_nullable_to_non_nullable
as bool,repotting: null == repotting ? _self.repotting : repotting // ignore: cast_nullable_to_non_nullable
as bool,moisture: null == moisture ? _self.moisture : moisture // ignore: cast_nullable_to_non_nullable
as FirestoreMoisture,illumination: null == illumination ? _self.illumination : illumination // ignore: cast_nullable_to_non_nullable
as FirestoreIllumination,lastWateredAt: freezed == lastWateredAt ? _self.lastWateredAt : lastWateredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,wateringIntervalDays: null == wateringIntervalDays ? _self.wateringIntervalDays : wateringIntervalDays // ignore: cast_nullable_to_non_nullable
as int,nextWateringAt: freezed == nextWateringAt ? _self.nextWateringAt : nextWateringAt // ignore: cast_nullable_to_non_nullable
as DateTime?,searchKeywords: null == searchKeywords ? _self._searchKeywords : searchKeywords // ignore: cast_nullable_to_non_nullable
as List<String>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of FirestorePlant
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FirestoreMoistureCopyWith<$Res> get moisture {
  
  return $FirestoreMoistureCopyWith<$Res>(_self.moisture, (value) {
    return _then(_self.copyWith(moisture: value));
  });
}/// Create a copy of FirestorePlant
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FirestoreIlluminationCopyWith<$Res> get illumination {
  
  return $FirestoreIlluminationCopyWith<$Res>(_self.illumination, (value) {
    return _then(_self.copyWith(illumination: value));
  });
}
}

// dart format on
