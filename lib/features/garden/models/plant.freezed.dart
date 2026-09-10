// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Moisture {

 MoistureLevel get level; MoistureSource get source; DateTime? get updatedAt;
/// Create a copy of Moisture
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoistureCopyWith<Moisture> get copyWith => _$MoistureCopyWithImpl<Moisture>(this as Moisture, _$identity);

  /// Serializes this Moisture to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Moisture;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Moisture&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Moisture;
  return Object.hash(runtimeType,_this.level,_this.source,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Moisture;
  return 'Moisture(level: ${_this.level}, source: ${_this.source}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $MoistureCopyWith<$Res>  {
  factory $MoistureCopyWith(Moisture value, $Res Function(Moisture) _then) = _$MoistureCopyWithImpl;
@useResult
$Res call({
 MoistureLevel level, MoistureSource source, DateTime? updatedAt
});




}
/// @nodoc
class _$MoistureCopyWithImpl<$Res>
    implements $MoistureCopyWith<$Res> {
  _$MoistureCopyWithImpl(this._self, this._then);

  final Moisture _self;
  final $Res Function(Moisture) _then;

/// Create a copy of Moisture
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? source = null,Object? updatedAt = freezed,}) {
  return _then(Moisture(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as MoistureLevel,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as MoistureSource,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Moisture].
extension MoisturePatterns on Moisture {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Moisture value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Moisture() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Moisture value)  $default,){
final _that = this;
switch (_that) {
case _Moisture():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Moisture value)?  $default,){
final _that = this;
switch (_that) {
case _Moisture() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MoistureLevel level,  MoistureSource source,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Moisture() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MoistureLevel level,  MoistureSource source,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Moisture():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MoistureLevel level,  MoistureSource source,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Moisture() when $default != null:
return $default(_that.level,_that.source,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Moisture implements Moisture {
  const _Moisture({required this.level, required this.source, this.updatedAt});
  factory _Moisture.fromJson(Map<String, dynamic> json) => _$MoistureFromJson(json);

@override final  MoistureLevel level;
@override final  MoistureSource source;
@override final  DateTime? updatedAt;

/// Create a copy of Moisture
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoistureCopyWith<_Moisture> get copyWith => __$MoistureCopyWithImpl<_Moisture>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MoistureToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Moisture&&(identical(other.level, level) || other.level == level)&&(identical(other.source, source) || other.source == source)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,level,source,updatedAt);
}

@override
String toString() {
    return 'Moisture(level: $level, source: $source, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MoistureCopyWith<$Res> implements $MoistureCopyWith<$Res> {
  factory _$MoistureCopyWith(_Moisture value, $Res Function(_Moisture) _then) = __$MoistureCopyWithImpl;
@override @useResult
$Res call({
 MoistureLevel level, MoistureSource source, DateTime? updatedAt
});




}
/// @nodoc
class __$MoistureCopyWithImpl<$Res>
    implements _$MoistureCopyWith<$Res> {
  __$MoistureCopyWithImpl(this._self, this._then);

  final _Moisture _self;
  final $Res Function(_Moisture) _then;

/// Create a copy of Moisture
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? source = null,Object? updatedAt = freezed,}) {
  return _then(_Moisture(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as MoistureLevel,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as MoistureSource,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Illumination {

 LightLevel get current; LightLevel get target; DateTime? get updatedAt;
/// Create a copy of Illumination
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IlluminationCopyWith<Illumination> get copyWith => _$IlluminationCopyWithImpl<Illumination>(this as Illumination, _$identity);

  /// Serializes this Illumination to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Illumination;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Illumination&&(identical(other.current, _this.current) || other.current == _this.current)&&(identical(other.target, _this.target) || other.target == _this.target)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Illumination;
  return Object.hash(runtimeType,_this.current,_this.target,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Illumination;
  return 'Illumination(current: ${_this.current}, target: ${_this.target}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $IlluminationCopyWith<$Res>  {
  factory $IlluminationCopyWith(Illumination value, $Res Function(Illumination) _then) = _$IlluminationCopyWithImpl;
@useResult
$Res call({
 LightLevel current, LightLevel target, DateTime? updatedAt
});




}
/// @nodoc
class _$IlluminationCopyWithImpl<$Res>
    implements $IlluminationCopyWith<$Res> {
  _$IlluminationCopyWithImpl(this._self, this._then);

  final Illumination _self;
  final $Res Function(Illumination) _then;

/// Create a copy of Illumination
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? current = null,Object? target = null,Object? updatedAt = freezed,}) {
  return _then(Illumination(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as LightLevel,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as LightLevel,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Illumination].
extension IlluminationPatterns on Illumination {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Illumination value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Illumination() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Illumination value)  $default,){
final _that = this;
switch (_that) {
case _Illumination():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Illumination value)?  $default,){
final _that = this;
switch (_that) {
case _Illumination() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LightLevel current,  LightLevel target,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Illumination() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LightLevel current,  LightLevel target,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Illumination():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LightLevel current,  LightLevel target,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Illumination() when $default != null:
return $default(_that.current,_that.target,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Illumination implements Illumination {
  const _Illumination({required this.current, required this.target, this.updatedAt});
  factory _Illumination.fromJson(Map<String, dynamic> json) => _$IlluminationFromJson(json);

@override final  LightLevel current;
@override final  LightLevel target;
@override final  DateTime? updatedAt;

/// Create a copy of Illumination
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IlluminationCopyWith<_Illumination> get copyWith => __$IlluminationCopyWithImpl<_Illumination>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IlluminationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Illumination&&(identical(other.current, current) || other.current == current)&&(identical(other.target, target) || other.target == target)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,current,target,updatedAt);
}

@override
String toString() {
    return 'Illumination(current: $current, target: $target, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$IlluminationCopyWith<$Res> implements $IlluminationCopyWith<$Res> {
  factory _$IlluminationCopyWith(_Illumination value, $Res Function(_Illumination) _then) = __$IlluminationCopyWithImpl;
@override @useResult
$Res call({
 LightLevel current, LightLevel target, DateTime? updatedAt
});




}
/// @nodoc
class __$IlluminationCopyWithImpl<$Res>
    implements _$IlluminationCopyWith<$Res> {
  __$IlluminationCopyWithImpl(this._self, this._then);

  final _Illumination _self;
  final $Res Function(_Illumination) _then;

/// Create a copy of Illumination
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? current = null,Object? target = null,Object? updatedAt = freezed,}) {
  return _then(_Illumination(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as LightLevel,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as LightLevel,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Plant {

 String get id; String get commonName; String get scientificName; Category get category; String get primaryPhotoUrl; HealthStatus get healthStatus; bool get lightingChange; bool get needsWater; bool get repotting; Moisture get moisture; Illumination get illumination; DateTime? get lastWateredAt; int get wateringIntervalDays; DateTime? get nextWateringAt; List<String> get searchKeywords; String get notes; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantCopyWith<Plant> get copyWith => _$PlantCopyWithImpl<Plant>(this as Plant, _$identity);

  /// Serializes this Plant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Plant;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Plant&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.commonName, _this.commonName) || other.commonName == _this.commonName)&&(identical(other.scientificName, _this.scientificName) || other.scientificName == _this.scientificName)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.primaryPhotoUrl, _this.primaryPhotoUrl) || other.primaryPhotoUrl == _this.primaryPhotoUrl)&&(identical(other.healthStatus, _this.healthStatus) || other.healthStatus == _this.healthStatus)&&(identical(other.lightingChange, _this.lightingChange) || other.lightingChange == _this.lightingChange)&&(identical(other.needsWater, _this.needsWater) || other.needsWater == _this.needsWater)&&(identical(other.repotting, _this.repotting) || other.repotting == _this.repotting)&&(identical(other.moisture, _this.moisture) || other.moisture == _this.moisture)&&(identical(other.illumination, _this.illumination) || other.illumination == _this.illumination)&&(identical(other.lastWateredAt, _this.lastWateredAt) || other.lastWateredAt == _this.lastWateredAt)&&(identical(other.wateringIntervalDays, _this.wateringIntervalDays) || other.wateringIntervalDays == _this.wateringIntervalDays)&&(identical(other.nextWateringAt, _this.nextWateringAt) || other.nextWateringAt == _this.nextWateringAt)&&const DeepCollectionEquality().equals(other.searchKeywords, _this.searchKeywords)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Plant;
  return Object.hash(runtimeType,_this.id,_this.commonName,_this.scientificName,_this.category,_this.primaryPhotoUrl,_this.healthStatus,_this.lightingChange,_this.needsWater,_this.repotting,_this.moisture,_this.illumination,_this.lastWateredAt,_this.wateringIntervalDays,_this.nextWateringAt,const DeepCollectionEquality().hash(_this.searchKeywords),_this.notes,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Plant;
  return 'Plant(id: ${_this.id}, commonName: ${_this.commonName}, scientificName: ${_this.scientificName}, category: ${_this.category}, primaryPhotoUrl: ${_this.primaryPhotoUrl}, healthStatus: ${_this.healthStatus}, lightingChange: ${_this.lightingChange}, needsWater: ${_this.needsWater}, repotting: ${_this.repotting}, moisture: ${_this.moisture}, illumination: ${_this.illumination}, lastWateredAt: ${_this.lastWateredAt}, wateringIntervalDays: ${_this.wateringIntervalDays}, nextWateringAt: ${_this.nextWateringAt}, searchKeywords: ${_this.searchKeywords}, notes: ${_this.notes}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $PlantCopyWith<$Res>  {
  factory $PlantCopyWith(Plant value, $Res Function(Plant) _then) = _$PlantCopyWithImpl;
@useResult
$Res call({
 String id, String commonName, String scientificName, Category category, String primaryPhotoUrl, HealthStatus healthStatus, bool lightingChange, bool needsWater, bool repotting, Moisture moisture, Illumination illumination, DateTime? lastWateredAt, int wateringIntervalDays, DateTime? nextWateringAt, List<String> searchKeywords, String notes, DateTime? createdAt, DateTime? updatedAt
});


$MoistureCopyWith<$Res> get moisture;$IlluminationCopyWith<$Res> get illumination;

}
/// @nodoc
class _$PlantCopyWithImpl<$Res>
    implements $PlantCopyWith<$Res> {
  _$PlantCopyWithImpl(this._self, this._then);

  final Plant _self;
  final $Res Function(Plant) _then;

/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? commonName = null,Object? scientificName = null,Object? category = null,Object? primaryPhotoUrl = null,Object? healthStatus = null,Object? lightingChange = null,Object? needsWater = null,Object? repotting = null,Object? moisture = null,Object? illumination = null,Object? lastWateredAt = freezed,Object? wateringIntervalDays = null,Object? nextWateringAt = freezed,Object? searchKeywords = null,Object? notes = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(Plant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,commonName: null == commonName ? _self.commonName : commonName // ignore: cast_nullable_to_non_nullable
as String,scientificName: null == scientificName ? _self.scientificName : scientificName // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,primaryPhotoUrl: null == primaryPhotoUrl ? _self.primaryPhotoUrl : primaryPhotoUrl // ignore: cast_nullable_to_non_nullable
as String,healthStatus: null == healthStatus ? _self.healthStatus : healthStatus // ignore: cast_nullable_to_non_nullable
as HealthStatus,lightingChange: null == lightingChange ? _self.lightingChange : lightingChange // ignore: cast_nullable_to_non_nullable
as bool,needsWater: null == needsWater ? _self.needsWater : needsWater // ignore: cast_nullable_to_non_nullable
as bool,repotting: null == repotting ? _self.repotting : repotting // ignore: cast_nullable_to_non_nullable
as bool,moisture: null == moisture ? _self.moisture : moisture // ignore: cast_nullable_to_non_nullable
as Moisture,illumination: null == illumination ? _self.illumination : illumination // ignore: cast_nullable_to_non_nullable
as Illumination,lastWateredAt: freezed == lastWateredAt ? _self.lastWateredAt : lastWateredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,wateringIntervalDays: null == wateringIntervalDays ? _self.wateringIntervalDays : wateringIntervalDays // ignore: cast_nullable_to_non_nullable
as int,nextWateringAt: freezed == nextWateringAt ? _self.nextWateringAt : nextWateringAt // ignore: cast_nullable_to_non_nullable
as DateTime?,searchKeywords: null == searchKeywords ? _self.searchKeywords : searchKeywords // ignore: cast_nullable_to_non_nullable
as List<String>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoistureCopyWith<$Res> get moisture {
  
  return $MoistureCopyWith<$Res>(_self.moisture, (value) {
    return _then(_self.copyWith(moisture: value));
  });
}/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IlluminationCopyWith<$Res> get illumination {
  
  return $IlluminationCopyWith<$Res>(_self.illumination, (value) {
    return _then(_self.copyWith(illumination: value));
  });
}
}


/// Adds pattern-matching-related methods to [Plant].
extension PlantPatterns on Plant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Plant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Plant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Plant value)  $default,){
final _that = this;
switch (_that) {
case _Plant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Plant value)?  $default,){
final _that = this;
switch (_that) {
case _Plant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String commonName,  String scientificName,  Category category,  String primaryPhotoUrl,  HealthStatus healthStatus,  bool lightingChange,  bool needsWater,  bool repotting,  Moisture moisture,  Illumination illumination,  DateTime? lastWateredAt,  int wateringIntervalDays,  DateTime? nextWateringAt,  List<String> searchKeywords,  String notes,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Plant() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String commonName,  String scientificName,  Category category,  String primaryPhotoUrl,  HealthStatus healthStatus,  bool lightingChange,  bool needsWater,  bool repotting,  Moisture moisture,  Illumination illumination,  DateTime? lastWateredAt,  int wateringIntervalDays,  DateTime? nextWateringAt,  List<String> searchKeywords,  String notes,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Plant():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String commonName,  String scientificName,  Category category,  String primaryPhotoUrl,  HealthStatus healthStatus,  bool lightingChange,  bool needsWater,  bool repotting,  Moisture moisture,  Illumination illumination,  DateTime? lastWateredAt,  int wateringIntervalDays,  DateTime? nextWateringAt,  List<String> searchKeywords,  String notes,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Plant() when $default != null:
return $default(_that.id,_that.commonName,_that.scientificName,_that.category,_that.primaryPhotoUrl,_that.healthStatus,_that.lightingChange,_that.needsWater,_that.repotting,_that.moisture,_that.illumination,_that.lastWateredAt,_that.wateringIntervalDays,_that.nextWateringAt,_that.searchKeywords,_that.notes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Plant implements Plant {
  const _Plant({required this.id, required this.commonName, required this.scientificName, required this.category, required this.primaryPhotoUrl, required this.healthStatus, required this.lightingChange, required this.needsWater, required this.repotting, required this.moisture, required this.illumination, this.lastWateredAt, required this.wateringIntervalDays, this.nextWateringAt, required  List<String> searchKeywords, required this.notes, this.createdAt, this.updatedAt}): _searchKeywords = searchKeywords;
  factory _Plant.fromJson(Map<String, dynamic> json) => _$PlantFromJson(json);

@override final  String id;
@override final  String commonName;
@override final  String scientificName;
@override final  Category category;
@override final  String primaryPhotoUrl;
@override final  HealthStatus healthStatus;
@override final  bool lightingChange;
@override final  bool needsWater;
@override final  bool repotting;
@override final  Moisture moisture;
@override final  Illumination illumination;
@override final  DateTime? lastWateredAt;
@override final  int wateringIntervalDays;
@override final  DateTime? nextWateringAt;
 final  List<String> _searchKeywords;
@override List<String> get searchKeywords {
  if (_searchKeywords is EqualUnmodifiableListView) return _searchKeywords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchKeywords);
}

@override final  String notes;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlantCopyWith<_Plant> get copyWith => __$PlantCopyWithImpl<_Plant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlantToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Plant&&(identical(other.id, id) || other.id == id)&&(identical(other.commonName, commonName) || other.commonName == commonName)&&(identical(other.scientificName, scientificName) || other.scientificName == scientificName)&&(identical(other.category, category) || other.category == category)&&(identical(other.primaryPhotoUrl, primaryPhotoUrl) || other.primaryPhotoUrl == primaryPhotoUrl)&&(identical(other.healthStatus, healthStatus) || other.healthStatus == healthStatus)&&(identical(other.lightingChange, lightingChange) || other.lightingChange == lightingChange)&&(identical(other.needsWater, needsWater) || other.needsWater == needsWater)&&(identical(other.repotting, repotting) || other.repotting == repotting)&&(identical(other.moisture, moisture) || other.moisture == moisture)&&(identical(other.illumination, illumination) || other.illumination == illumination)&&(identical(other.lastWateredAt, lastWateredAt) || other.lastWateredAt == lastWateredAt)&&(identical(other.wateringIntervalDays, wateringIntervalDays) || other.wateringIntervalDays == wateringIntervalDays)&&(identical(other.nextWateringAt, nextWateringAt) || other.nextWateringAt == nextWateringAt)&&const DeepCollectionEquality().equals(other.searchKeywords, _searchKeywords)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,commonName,scientificName,category,primaryPhotoUrl,healthStatus,lightingChange,needsWater,repotting,moisture,illumination,lastWateredAt,wateringIntervalDays,nextWateringAt,const DeepCollectionEquality().hash(_searchKeywords),notes,createdAt,updatedAt);
}

@override
String toString() {
    return 'Plant(id: $id, commonName: $commonName, scientificName: $scientificName, category: $category, primaryPhotoUrl: $primaryPhotoUrl, healthStatus: $healthStatus, lightingChange: $lightingChange, needsWater: $needsWater, repotting: $repotting, moisture: $moisture, illumination: $illumination, lastWateredAt: $lastWateredAt, wateringIntervalDays: $wateringIntervalDays, nextWateringAt: $nextWateringAt, searchKeywords: $searchKeywords, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PlantCopyWith<$Res> implements $PlantCopyWith<$Res> {
  factory _$PlantCopyWith(_Plant value, $Res Function(_Plant) _then) = __$PlantCopyWithImpl;
@override @useResult
$Res call({
 String id, String commonName, String scientificName, Category category, String primaryPhotoUrl, HealthStatus healthStatus, bool lightingChange, bool needsWater, bool repotting, Moisture moisture, Illumination illumination, DateTime? lastWateredAt, int wateringIntervalDays, DateTime? nextWateringAt, List<String> searchKeywords, String notes, DateTime? createdAt, DateTime? updatedAt
});


@override $MoistureCopyWith<$Res> get moisture;@override $IlluminationCopyWith<$Res> get illumination;

}
/// @nodoc
class __$PlantCopyWithImpl<$Res>
    implements _$PlantCopyWith<$Res> {
  __$PlantCopyWithImpl(this._self, this._then);

  final _Plant _self;
  final $Res Function(_Plant) _then;

/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? commonName = null,Object? scientificName = null,Object? category = null,Object? primaryPhotoUrl = null,Object? healthStatus = null,Object? lightingChange = null,Object? needsWater = null,Object? repotting = null,Object? moisture = null,Object? illumination = null,Object? lastWateredAt = freezed,Object? wateringIntervalDays = null,Object? nextWateringAt = freezed,Object? searchKeywords = null,Object? notes = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Plant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,commonName: null == commonName ? _self.commonName : commonName // ignore: cast_nullable_to_non_nullable
as String,scientificName: null == scientificName ? _self.scientificName : scientificName // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,primaryPhotoUrl: null == primaryPhotoUrl ? _self.primaryPhotoUrl : primaryPhotoUrl // ignore: cast_nullable_to_non_nullable
as String,healthStatus: null == healthStatus ? _self.healthStatus : healthStatus // ignore: cast_nullable_to_non_nullable
as HealthStatus,lightingChange: null == lightingChange ? _self.lightingChange : lightingChange // ignore: cast_nullable_to_non_nullable
as bool,needsWater: null == needsWater ? _self.needsWater : needsWater // ignore: cast_nullable_to_non_nullable
as bool,repotting: null == repotting ? _self.repotting : repotting // ignore: cast_nullable_to_non_nullable
as bool,moisture: null == moisture ? _self.moisture : moisture // ignore: cast_nullable_to_non_nullable
as Moisture,illumination: null == illumination ? _self.illumination : illumination // ignore: cast_nullable_to_non_nullable
as Illumination,lastWateredAt: freezed == lastWateredAt ? _self.lastWateredAt : lastWateredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,wateringIntervalDays: null == wateringIntervalDays ? _self.wateringIntervalDays : wateringIntervalDays // ignore: cast_nullable_to_non_nullable
as int,nextWateringAt: freezed == nextWateringAt ? _self.nextWateringAt : nextWateringAt // ignore: cast_nullable_to_non_nullable
as DateTime?,searchKeywords: null == searchKeywords ? _self._searchKeywords : searchKeywords // ignore: cast_nullable_to_non_nullable
as List<String>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoistureCopyWith<$Res> get moisture {
  
  return $MoistureCopyWith<$Res>(_self.moisture, (value) {
    return _then(_self.copyWith(moisture: value));
  });
}/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IlluminationCopyWith<$Res> get illumination {
  
  return $IlluminationCopyWith<$Res>(_self.illumination, (value) {
    return _then(_self.copyWith(illumination: value));
  });
}
}

// dart format on
