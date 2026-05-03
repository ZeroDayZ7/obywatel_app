// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthRecord {

 String get id; String get title; DateTime get date; HealthRecordType get type; String get status; String? get description; String? get doctorName;
/// Create a copy of HealthRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthRecordCopyWith<HealthRecord> get copyWith => _$HealthRecordCopyWithImpl<HealthRecord>(this as HealthRecord, _$identity);

  /// Serializes this HealthRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.description, description) || other.description == description)&&(identical(other.doctorName, doctorName) || other.doctorName == doctorName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,date,type,status,description,doctorName);

@override
String toString() {
  return 'HealthRecord(id: $id, title: $title, date: $date, type: $type, status: $status, description: $description, doctorName: $doctorName)';
}


}

/// @nodoc
abstract mixin class $HealthRecordCopyWith<$Res>  {
  factory $HealthRecordCopyWith(HealthRecord value, $Res Function(HealthRecord) _then) = _$HealthRecordCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime date, HealthRecordType type, String status, String? description, String? doctorName
});




}
/// @nodoc
class _$HealthRecordCopyWithImpl<$Res>
    implements $HealthRecordCopyWith<$Res> {
  _$HealthRecordCopyWithImpl(this._self, this._then);

  final HealthRecord _self;
  final $Res Function(HealthRecord) _then;

/// Create a copy of HealthRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? date = null,Object? type = null,Object? status = null,Object? description = freezed,Object? doctorName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as HealthRecordType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,doctorName: freezed == doctorName ? _self.doctorName : doctorName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthRecord].
extension HealthRecordPatterns on HealthRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthRecord value)  $default,){
final _that = this;
switch (_that) {
case _HealthRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthRecord value)?  $default,){
final _that = this;
switch (_that) {
case _HealthRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime date,  HealthRecordType type,  String status,  String? description,  String? doctorName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthRecord() when $default != null:
return $default(_that.id,_that.title,_that.date,_that.type,_that.status,_that.description,_that.doctorName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime date,  HealthRecordType type,  String status,  String? description,  String? doctorName)  $default,) {final _that = this;
switch (_that) {
case _HealthRecord():
return $default(_that.id,_that.title,_that.date,_that.type,_that.status,_that.description,_that.doctorName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime date,  HealthRecordType type,  String status,  String? description,  String? doctorName)?  $default,) {final _that = this;
switch (_that) {
case _HealthRecord() when $default != null:
return $default(_that.id,_that.title,_that.date,_that.type,_that.status,_that.description,_that.doctorName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthRecord implements HealthRecord {
  const _HealthRecord({required this.id, required this.title, required this.date, required this.type, required this.status, this.description, this.doctorName});
  factory _HealthRecord.fromJson(Map<String, dynamic> json) => _$HealthRecordFromJson(json);

@override final  String id;
@override final  String title;
@override final  DateTime date;
@override final  HealthRecordType type;
@override final  String status;
@override final  String? description;
@override final  String? doctorName;

/// Create a copy of HealthRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthRecordCopyWith<_HealthRecord> get copyWith => __$HealthRecordCopyWithImpl<_HealthRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.description, description) || other.description == description)&&(identical(other.doctorName, doctorName) || other.doctorName == doctorName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,date,type,status,description,doctorName);

@override
String toString() {
  return 'HealthRecord(id: $id, title: $title, date: $date, type: $type, status: $status, description: $description, doctorName: $doctorName)';
}


}

/// @nodoc
abstract mixin class _$HealthRecordCopyWith<$Res> implements $HealthRecordCopyWith<$Res> {
  factory _$HealthRecordCopyWith(_HealthRecord value, $Res Function(_HealthRecord) _then) = __$HealthRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime date, HealthRecordType type, String status, String? description, String? doctorName
});




}
/// @nodoc
class __$HealthRecordCopyWithImpl<$Res>
    implements _$HealthRecordCopyWith<$Res> {
  __$HealthRecordCopyWithImpl(this._self, this._then);

  final _HealthRecord _self;
  final $Res Function(_HealthRecord) _then;

/// Create a copy of HealthRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? date = null,Object? type = null,Object? status = null,Object? description = freezed,Object? doctorName = freezed,}) {
  return _then(_HealthRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as HealthRecordType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,doctorName: freezed == doctorName ? _self.doctorName : doctorName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
