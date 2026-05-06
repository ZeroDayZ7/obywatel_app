// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_offer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobOffer {

 String get id; String get title; String get company; String get location; String get salary; String get type;
/// Create a copy of JobOffer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobOfferCopyWith<JobOffer> get copyWith => _$JobOfferCopyWithImpl<JobOffer>(this as JobOffer, _$identity);

  /// Serializes this JobOffer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobOffer&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.company, company) || other.company == company)&&(identical(other.location, location) || other.location == location)&&(identical(other.salary, salary) || other.salary == salary)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,company,location,salary,type);

@override
String toString() {
  return 'JobOffer(id: $id, title: $title, company: $company, location: $location, salary: $salary, type: $type)';
}


}

/// @nodoc
abstract mixin class $JobOfferCopyWith<$Res>  {
  factory $JobOfferCopyWith(JobOffer value, $Res Function(JobOffer) _then) = _$JobOfferCopyWithImpl;
@useResult
$Res call({
 String id, String title, String company, String location, String salary, String type
});




}
/// @nodoc
class _$JobOfferCopyWithImpl<$Res>
    implements $JobOfferCopyWith<$Res> {
  _$JobOfferCopyWithImpl(this._self, this._then);

  final JobOffer _self;
  final $Res Function(JobOffer) _then;

/// Create a copy of JobOffer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? company = null,Object? location = null,Object? salary = null,Object? type = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,salary: null == salary ? _self.salary : salary // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [JobOffer].
extension JobOfferPatterns on JobOffer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobOffer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobOffer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobOffer value)  $default,){
final _that = this;
switch (_that) {
case _JobOffer():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobOffer value)?  $default,){
final _that = this;
switch (_that) {
case _JobOffer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String company,  String location,  String salary,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobOffer() when $default != null:
return $default(_that.id,_that.title,_that.company,_that.location,_that.salary,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String company,  String location,  String salary,  String type)  $default,) {final _that = this;
switch (_that) {
case _JobOffer():
return $default(_that.id,_that.title,_that.company,_that.location,_that.salary,_that.type);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String company,  String location,  String salary,  String type)?  $default,) {final _that = this;
switch (_that) {
case _JobOffer() when $default != null:
return $default(_that.id,_that.title,_that.company,_that.location,_that.salary,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobOffer implements JobOffer {
  const _JobOffer({required this.id, required this.title, required this.company, required this.location, required this.salary, required this.type});
  factory _JobOffer.fromJson(Map<String, dynamic> json) => _$JobOfferFromJson(json);

@override final  String id;
@override final  String title;
@override final  String company;
@override final  String location;
@override final  String salary;
@override final  String type;

/// Create a copy of JobOffer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobOfferCopyWith<_JobOffer> get copyWith => __$JobOfferCopyWithImpl<_JobOffer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobOfferToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobOffer&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.company, company) || other.company == company)&&(identical(other.location, location) || other.location == location)&&(identical(other.salary, salary) || other.salary == salary)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,company,location,salary,type);

@override
String toString() {
  return 'JobOffer(id: $id, title: $title, company: $company, location: $location, salary: $salary, type: $type)';
}


}

/// @nodoc
abstract mixin class _$JobOfferCopyWith<$Res> implements $JobOfferCopyWith<$Res> {
  factory _$JobOfferCopyWith(_JobOffer value, $Res Function(_JobOffer) _then) = __$JobOfferCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String company, String location, String salary, String type
});




}
/// @nodoc
class __$JobOfferCopyWithImpl<$Res>
    implements _$JobOfferCopyWith<$Res> {
  __$JobOfferCopyWithImpl(this._self, this._then);

  final _JobOffer _self;
  final $Res Function(_JobOffer) _then;

/// Create a copy of JobOffer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? company = null,Object? location = null,Object? salary = null,Object? type = null,}) {
  return _then(_JobOffer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,salary: null == salary ? _self.salary : salary // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
