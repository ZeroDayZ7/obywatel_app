// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserSession {

@JsonKey(name: 'id') int get id;@JsonKey(name: 'device_name_encrypted') String get deviceName; String get platform;@JsonKey(name: 'created_at') DateTime get createdAt; String get fingerprint; String? get location; bool get isCurrent;
/// Create a copy of UserSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSessionCopyWith<UserSession> get copyWith => _$UserSessionCopyWithImpl<UserSession>(this as UserSession, _$identity);

  /// Serializes this UserSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSession&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.fingerprint, fingerprint) || other.fingerprint == fingerprint)&&(identical(other.location, location) || other.location == location)&&(identical(other.isCurrent, isCurrent) || other.isCurrent == isCurrent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deviceName,platform,createdAt,fingerprint,location,isCurrent);

@override
String toString() {
  return 'UserSession(id: $id, deviceName: $deviceName, platform: $platform, createdAt: $createdAt, fingerprint: $fingerprint, location: $location, isCurrent: $isCurrent)';
}


}

/// @nodoc
abstract mixin class $UserSessionCopyWith<$Res>  {
  factory $UserSessionCopyWith(UserSession value, $Res Function(UserSession) _then) = _$UserSessionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'device_name_encrypted') String deviceName, String platform,@JsonKey(name: 'created_at') DateTime createdAt, String fingerprint, String? location, bool isCurrent
});




}
/// @nodoc
class _$UserSessionCopyWithImpl<$Res>
    implements $UserSessionCopyWith<$Res> {
  _$UserSessionCopyWithImpl(this._self, this._then);

  final UserSession _self;
  final $Res Function(UserSession) _then;

/// Create a copy of UserSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? deviceName = null,Object? platform = null,Object? createdAt = null,Object? fingerprint = null,Object? location = freezed,Object? isCurrent = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,fingerprint: null == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,isCurrent: null == isCurrent ? _self.isCurrent : isCurrent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserSession].
extension UserSessionPatterns on UserSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSession value)  $default,){
final _that = this;
switch (_that) {
case _UserSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSession value)?  $default,){
final _that = this;
switch (_that) {
case _UserSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'device_name_encrypted')  String deviceName,  String platform, @JsonKey(name: 'created_at')  DateTime createdAt,  String fingerprint,  String? location,  bool isCurrent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSession() when $default != null:
return $default(_that.id,_that.deviceName,_that.platform,_that.createdAt,_that.fingerprint,_that.location,_that.isCurrent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'device_name_encrypted')  String deviceName,  String platform, @JsonKey(name: 'created_at')  DateTime createdAt,  String fingerprint,  String? location,  bool isCurrent)  $default,) {final _that = this;
switch (_that) {
case _UserSession():
return $default(_that.id,_that.deviceName,_that.platform,_that.createdAt,_that.fingerprint,_that.location,_that.isCurrent);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'device_name_encrypted')  String deviceName,  String platform, @JsonKey(name: 'created_at')  DateTime createdAt,  String fingerprint,  String? location,  bool isCurrent)?  $default,) {final _that = this;
switch (_that) {
case _UserSession() when $default != null:
return $default(_that.id,_that.deviceName,_that.platform,_that.createdAt,_that.fingerprint,_that.location,_that.isCurrent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserSession implements UserSession {
  const _UserSession({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'device_name_encrypted') required this.deviceName, required this.platform, @JsonKey(name: 'created_at') required this.createdAt, required this.fingerprint, this.location, this.isCurrent = false});
  factory _UserSession.fromJson(Map<String, dynamic> json) => _$UserSessionFromJson(json);

@override@JsonKey(name: 'id') final  int id;
@override@JsonKey(name: 'device_name_encrypted') final  String deviceName;
@override final  String platform;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override final  String fingerprint;
@override final  String? location;
@override@JsonKey() final  bool isCurrent;

/// Create a copy of UserSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSessionCopyWith<_UserSession> get copyWith => __$UserSessionCopyWithImpl<_UserSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSession&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.fingerprint, fingerprint) || other.fingerprint == fingerprint)&&(identical(other.location, location) || other.location == location)&&(identical(other.isCurrent, isCurrent) || other.isCurrent == isCurrent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deviceName,platform,createdAt,fingerprint,location,isCurrent);

@override
String toString() {
  return 'UserSession(id: $id, deviceName: $deviceName, platform: $platform, createdAt: $createdAt, fingerprint: $fingerprint, location: $location, isCurrent: $isCurrent)';
}


}

/// @nodoc
abstract mixin class _$UserSessionCopyWith<$Res> implements $UserSessionCopyWith<$Res> {
  factory _$UserSessionCopyWith(_UserSession value, $Res Function(_UserSession) _then) = __$UserSessionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'device_name_encrypted') String deviceName, String platform,@JsonKey(name: 'created_at') DateTime createdAt, String fingerprint, String? location, bool isCurrent
});




}
/// @nodoc
class __$UserSessionCopyWithImpl<$Res>
    implements _$UserSessionCopyWith<$Res> {
  __$UserSessionCopyWithImpl(this._self, this._then);

  final _UserSession _self;
  final $Res Function(_UserSession) _then;

/// Create a copy of UserSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? deviceName = null,Object? platform = null,Object? createdAt = null,Object? fingerprint = null,Object? location = freezed,Object? isCurrent = null,}) {
  return _then(_UserSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,fingerprint: null == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,isCurrent: null == isCurrent ? _self.isCurrent : isCurrent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
