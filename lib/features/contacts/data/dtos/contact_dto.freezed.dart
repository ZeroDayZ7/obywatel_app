// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactDto {

@JsonKey(name: 'ID') String get id;@JsonKey(name: 'OwnerID') String get ownerId;@JsonKey(name: 'ContactID') String get contactId;@JsonKey(name: 'Status') String get status;@JsonKey(name: 'Version') int get version;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of ContactDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactDtoCopyWith<ContactDto> get copyWith => _$ContactDtoCopyWithImpl<ContactDto>(this as ContactDto, _$identity);

  /// Serializes this ContactDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactDto&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.status, status) || other.status == status)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,contactId,status,version,createdAt,updatedAt);

@override
String toString() {
  return 'ContactDto(id: $id, ownerId: $ownerId, contactId: $contactId, status: $status, version: $version, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ContactDtoCopyWith<$Res>  {
  factory $ContactDtoCopyWith(ContactDto value, $Res Function(ContactDto) _then) = _$ContactDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ID') String id,@JsonKey(name: 'OwnerID') String ownerId,@JsonKey(name: 'ContactID') String contactId,@JsonKey(name: 'Status') String status,@JsonKey(name: 'Version') int version,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$ContactDtoCopyWithImpl<$Res>
    implements $ContactDtoCopyWith<$Res> {
  _$ContactDtoCopyWithImpl(this._self, this._then);

  final ContactDto _self;
  final $Res Function(ContactDto) _then;

/// Create a copy of ContactDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = null,Object? contactId = null,Object? status = null,Object? version = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,contactId: null == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactDto].
extension ContactDtoPatterns on ContactDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactDto value)  $default,){
final _that = this;
switch (_that) {
case _ContactDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactDto value)?  $default,){
final _that = this;
switch (_that) {
case _ContactDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID')  String id, @JsonKey(name: 'OwnerID')  String ownerId, @JsonKey(name: 'ContactID')  String contactId, @JsonKey(name: 'Status')  String status, @JsonKey(name: 'Version')  int version, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactDto() when $default != null:
return $default(_that.id,_that.ownerId,_that.contactId,_that.status,_that.version,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ID')  String id, @JsonKey(name: 'OwnerID')  String ownerId, @JsonKey(name: 'ContactID')  String contactId, @JsonKey(name: 'Status')  String status, @JsonKey(name: 'Version')  int version, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ContactDto():
return $default(_that.id,_that.ownerId,_that.contactId,_that.status,_that.version,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ID')  String id, @JsonKey(name: 'OwnerID')  String ownerId, @JsonKey(name: 'ContactID')  String contactId, @JsonKey(name: 'Status')  String status, @JsonKey(name: 'Version')  int version, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ContactDto() when $default != null:
return $default(_that.id,_that.ownerId,_that.contactId,_that.status,_that.version,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContactDto implements ContactDto {
  const _ContactDto({@JsonKey(name: 'ID') required this.id, @JsonKey(name: 'OwnerID') required this.ownerId, @JsonKey(name: 'ContactID') required this.contactId, @JsonKey(name: 'Status') required this.status, @JsonKey(name: 'Version') required this.version, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _ContactDto.fromJson(Map<String, dynamic> json) => _$ContactDtoFromJson(json);

@override@JsonKey(name: 'ID') final  String id;
@override@JsonKey(name: 'OwnerID') final  String ownerId;
@override@JsonKey(name: 'ContactID') final  String contactId;
@override@JsonKey(name: 'Status') final  String status;
@override@JsonKey(name: 'Version') final  int version;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of ContactDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactDtoCopyWith<_ContactDto> get copyWith => __$ContactDtoCopyWithImpl<_ContactDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactDto&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.status, status) || other.status == status)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,contactId,status,version,createdAt,updatedAt);

@override
String toString() {
  return 'ContactDto(id: $id, ownerId: $ownerId, contactId: $contactId, status: $status, version: $version, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ContactDtoCopyWith<$Res> implements $ContactDtoCopyWith<$Res> {
  factory _$ContactDtoCopyWith(_ContactDto value, $Res Function(_ContactDto) _then) = __$ContactDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ID') String id,@JsonKey(name: 'OwnerID') String ownerId,@JsonKey(name: 'ContactID') String contactId,@JsonKey(name: 'Status') String status,@JsonKey(name: 'Version') int version,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$ContactDtoCopyWithImpl<$Res>
    implements _$ContactDtoCopyWith<$Res> {
  __$ContactDtoCopyWithImpl(this._self, this._then);

  final _ContactDto _self;
  final $Res Function(_ContactDto) _then;

/// Create a copy of ContactDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? contactId = null,Object? status = null,Object? version = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ContactDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,contactId: null == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
