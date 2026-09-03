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
mixin _$Plant {

 String get id; String get name; String get scientificName; String get imageUrl; PlantHealthStatus get healthStatus; PlantCareMetric get careMetric; double get careLevel; Set<PlantCategory> get categories;
/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantCopyWith<Plant> get copyWith => _$PlantCopyWithImpl<Plant>(this as Plant, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Plant;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Plant&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.scientificName, _this.scientificName) || other.scientificName == _this.scientificName)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.healthStatus, _this.healthStatus) || other.healthStatus == _this.healthStatus)&&(identical(other.careMetric, _this.careMetric) || other.careMetric == _this.careMetric)&&(identical(other.careLevel, _this.careLevel) || other.careLevel == _this.careLevel)&&const DeepCollectionEquality().equals(other.categories, _this.categories));
}


@override
int get hashCode {
  final _this = this as Plant;
  return Object.hash(runtimeType,_this.id,_this.name,_this.scientificName,_this.imageUrl,_this.healthStatus,_this.careMetric,_this.careLevel,const DeepCollectionEquality().hash(_this.categories));
}

@override
String toString() {
  final _this = this as Plant;
  return 'Plant(id: ${_this.id}, name: ${_this.name}, scientificName: ${_this.scientificName}, imageUrl: ${_this.imageUrl}, healthStatus: ${_this.healthStatus}, careMetric: ${_this.careMetric}, careLevel: ${_this.careLevel}, categories: ${_this.categories})';
}


}

/// @nodoc
abstract mixin class $PlantCopyWith<$Res>  {
  factory $PlantCopyWith(Plant value, $Res Function(Plant) _then) = _$PlantCopyWithImpl;
@useResult
$Res call({
 String id, String name, String scientificName, String imageUrl, PlantHealthStatus healthStatus, PlantCareMetric careMetric, double careLevel, Set<PlantCategory> categories
});




}
/// @nodoc
class _$PlantCopyWithImpl<$Res>
    implements $PlantCopyWith<$Res> {
  _$PlantCopyWithImpl(this._self, this._then);

  final Plant _self;
  final $Res Function(Plant) _then;

/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? scientificName = null,Object? imageUrl = null,Object? healthStatus = null,Object? careMetric = null,Object? careLevel = null,Object? categories = null,}) {
  return _then(Plant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,scientificName: null == scientificName ? _self.scientificName : scientificName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,healthStatus: null == healthStatus ? _self.healthStatus : healthStatus // ignore: cast_nullable_to_non_nullable
as PlantHealthStatus,careMetric: null == careMetric ? _self.careMetric : careMetric // ignore: cast_nullable_to_non_nullable
as PlantCareMetric,careLevel: null == careLevel ? _self.careLevel : careLevel // ignore: cast_nullable_to_non_nullable
as double,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as Set<PlantCategory>,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String scientificName,  String imageUrl,  PlantHealthStatus healthStatus,  PlantCareMetric careMetric,  double careLevel,  Set<PlantCategory> categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Plant() when $default != null:
return $default(_that.id,_that.name,_that.scientificName,_that.imageUrl,_that.healthStatus,_that.careMetric,_that.careLevel,_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String scientificName,  String imageUrl,  PlantHealthStatus healthStatus,  PlantCareMetric careMetric,  double careLevel,  Set<PlantCategory> categories)  $default,) {final _that = this;
switch (_that) {
case _Plant():
return $default(_that.id,_that.name,_that.scientificName,_that.imageUrl,_that.healthStatus,_that.careMetric,_that.careLevel,_that.categories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String scientificName,  String imageUrl,  PlantHealthStatus healthStatus,  PlantCareMetric careMetric,  double careLevel,  Set<PlantCategory> categories)?  $default,) {final _that = this;
switch (_that) {
case _Plant() when $default != null:
return $default(_that.id,_that.name,_that.scientificName,_that.imageUrl,_that.healthStatus,_that.careMetric,_that.careLevel,_that.categories);case _:
  return null;

}
}

}

/// @nodoc


class _Plant implements Plant {
  const _Plant({required this.id, required this.name, required this.scientificName, required this.imageUrl, required this.healthStatus, required this.careMetric, required this.careLevel, required  Set<PlantCategory> categories}): _categories = categories;
  

@override final  String id;
@override final  String name;
@override final  String scientificName;
@override final  String imageUrl;
@override final  PlantHealthStatus healthStatus;
@override final  PlantCareMetric careMetric;
@override final  double careLevel;
 final  Set<PlantCategory> _categories;
@override Set<PlantCategory> get categories {
  if (_categories is EqualUnmodifiableSetView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_categories);
}


/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlantCopyWith<_Plant> get copyWith => __$PlantCopyWithImpl<_Plant>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Plant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.scientificName, scientificName) || other.scientificName == scientificName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.healthStatus, healthStatus) || other.healthStatus == healthStatus)&&(identical(other.careMetric, careMetric) || other.careMetric == careMetric)&&(identical(other.careLevel, careLevel) || other.careLevel == careLevel)&&const DeepCollectionEquality().equals(other.categories, _categories));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,scientificName,imageUrl,healthStatus,careMetric,careLevel,const DeepCollectionEquality().hash(_categories));
}

@override
String toString() {
    return 'Plant(id: $id, name: $name, scientificName: $scientificName, imageUrl: $imageUrl, healthStatus: $healthStatus, careMetric: $careMetric, careLevel: $careLevel, categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$PlantCopyWith<$Res> implements $PlantCopyWith<$Res> {
  factory _$PlantCopyWith(_Plant value, $Res Function(_Plant) _then) = __$PlantCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String scientificName, String imageUrl, PlantHealthStatus healthStatus, PlantCareMetric careMetric, double careLevel, Set<PlantCategory> categories
});




}
/// @nodoc
class __$PlantCopyWithImpl<$Res>
    implements _$PlantCopyWith<$Res> {
  __$PlantCopyWithImpl(this._self, this._then);

  final _Plant _self;
  final $Res Function(_Plant) _then;

/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? scientificName = null,Object? imageUrl = null,Object? healthStatus = null,Object? careMetric = null,Object? careLevel = null,Object? categories = null,}) {
  return _then(_Plant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,scientificName: null == scientificName ? _self.scientificName : scientificName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,healthStatus: null == healthStatus ? _self.healthStatus : healthStatus // ignore: cast_nullable_to_non_nullable
as PlantHealthStatus,careMetric: null == careMetric ? _self.careMetric : careMetric // ignore: cast_nullable_to_non_nullable
as PlantCareMetric,careLevel: null == careLevel ? _self.careLevel : careLevel // ignore: cast_nullable_to_non_nullable
as double,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as Set<PlantCategory>,
  ));
}


}

// dart format on
