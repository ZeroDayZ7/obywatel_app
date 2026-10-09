// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'messaging_activation_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessagingActivationDto {

@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'status') String get status;@JsonKey(name: 'consent_accepted') bool get consentAccepted;@JsonKey(name: 'terms_version') String get termsVersion;@JsonKey(name: 'current_terms_version') String get currentTermsVersion;@JsonKey(name: 'requires_terms_acceptance') bool get requiresTermsAcceptance;@JsonKey(name: 'device_id') String? get deviceId;@JsonKey(name: 'activated_at') DateTime? get activatedAt;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of MessagingActivationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessagingActivationDtoCopyWith<MessagingActivationDto> get copyWith => _$MessagingActivationDtoCopyWithImpl<MessagingActivationDto>(this as MessagingActivationDto, _$identity);

  /// Serializes this MessagingActivationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagingActivationDto&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.status, status) || other.status == status)&&(identical(other.consentAccepted, consentAccepted) || other.consentAccepted == consentAccepted)&&(identical(other.termsVersion, termsVersion) || other.termsVersion == termsVersion)&&(identical(other.currentTermsVersion, currentTermsVersion) || other.currentTermsVersion == currentTermsVersion)&&(identical(other.requiresTermsAcceptance, requiresTermsAcceptance) || other.requiresTermsAcceptance == requiresTermsAcceptance)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.activatedAt, activatedAt) || other.activatedAt == activatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,status,consentAccepted,termsVersion,currentTermsVersion,requiresTermsAcceptance,deviceId,activatedAt,createdAt,updatedAt);

@override
String toString() {
  return 'MessagingActivationDto(userId: $userId, status: $status, consentAccepted: $consentAccepted, termsVersion: $termsVersion, currentTermsVersion: $currentTermsVersion, requiresTermsAcceptance: $requiresTermsAcceptance, deviceId: $deviceId, activatedAt: $activatedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MessagingActivationDtoCopyWith<$Res>  {
  factory $MessagingActivationDtoCopyWith(MessagingActivationDto value, $Res Function(MessagingActivationDto) _then) = _$MessagingActivationDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'status') String status,@JsonKey(name: 'consent_accepted') bool consentAccepted,@JsonKey(name: 'terms_version') String termsVersion,@JsonKey(name: 'current_terms_version') String currentTermsVersion,@JsonKey(name: 'requires_terms_acceptance') bool requiresTermsAcceptance,@JsonKey(name: 'device_id') String? deviceId,@JsonKey(name: 'activated_at') DateTime? activatedAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$MessagingActivationDtoCopyWithImpl<$Res>
    implements $MessagingActivationDtoCopyWith<$Res> {
  _$MessagingActivationDtoCopyWithImpl(this._self, this._then);

  final MessagingActivationDto _self;
  final $Res Function(MessagingActivationDto) _then;

/// Create a copy of MessagingActivationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? status = null,Object? consentAccepted = null,Object? termsVersion = null,Object? currentTermsVersion = null,Object? requiresTermsAcceptance = null,Object? deviceId = freezed,Object? activatedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,consentAccepted: null == consentAccepted ? _self.consentAccepted : consentAccepted // ignore: cast_nullable_to_non_nullable
as bool,termsVersion: null == termsVersion ? _self.termsVersion : termsVersion // ignore: cast_nullable_to_non_nullable
as String,currentTermsVersion: null == currentTermsVersion ? _self.currentTermsVersion : currentTermsVersion // ignore: cast_nullable_to_non_nullable
as String,requiresTermsAcceptance: null == requiresTermsAcceptance ? _self.requiresTermsAcceptance : requiresTermsAcceptance // ignore: cast_nullable_to_non_nullable
as bool,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,activatedAt: freezed == activatedAt ? _self.activatedAt : activatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MessagingActivationDto].
extension MessagingActivationDtoPatterns on MessagingActivationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessagingActivationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessagingActivationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessagingActivationDto value)  $default,){
final _that = this;
switch (_that) {
case _MessagingActivationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessagingActivationDto value)?  $default,){
final _that = this;
switch (_that) {
case _MessagingActivationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'status')  String status, @JsonKey(name: 'consent_accepted')  bool consentAccepted, @JsonKey(name: 'terms_version')  String termsVersion, @JsonKey(name: 'current_terms_version')  String currentTermsVersion, @JsonKey(name: 'requires_terms_acceptance')  bool requiresTermsAcceptance, @JsonKey(name: 'device_id')  String? deviceId, @JsonKey(name: 'activated_at')  DateTime? activatedAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessagingActivationDto() when $default != null:
return $default(_that.userId,_that.status,_that.consentAccepted,_that.termsVersion,_that.currentTermsVersion,_that.requiresTermsAcceptance,_that.deviceId,_that.activatedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'status')  String status, @JsonKey(name: 'consent_accepted')  bool consentAccepted, @JsonKey(name: 'terms_version')  String termsVersion, @JsonKey(name: 'current_terms_version')  String currentTermsVersion, @JsonKey(name: 'requires_terms_acceptance')  bool requiresTermsAcceptance, @JsonKey(name: 'device_id')  String? deviceId, @JsonKey(name: 'activated_at')  DateTime? activatedAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MessagingActivationDto():
return $default(_that.userId,_that.status,_that.consentAccepted,_that.termsVersion,_that.currentTermsVersion,_that.requiresTermsAcceptance,_that.deviceId,_that.activatedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'status')  String status, @JsonKey(name: 'consent_accepted')  bool consentAccepted, @JsonKey(name: 'terms_version')  String termsVersion, @JsonKey(name: 'current_terms_version')  String currentTermsVersion, @JsonKey(name: 'requires_terms_acceptance')  bool requiresTermsAcceptance, @JsonKey(name: 'device_id')  String? deviceId, @JsonKey(name: 'activated_at')  DateTime? activatedAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MessagingActivationDto() when $default != null:
return $default(_that.userId,_that.status,_that.consentAccepted,_that.termsVersion,_that.currentTermsVersion,_that.requiresTermsAcceptance,_that.deviceId,_that.activatedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessagingActivationDto implements MessagingActivationDto {
  const _MessagingActivationDto({@JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'status') required this.status, @JsonKey(name: 'consent_accepted') this.consentAccepted = false, @JsonKey(name: 'terms_version') this.termsVersion = '', @JsonKey(name: 'current_terms_version') this.currentTermsVersion = '', @JsonKey(name: 'requires_terms_acceptance') this.requiresTermsAcceptance = false, @JsonKey(name: 'device_id') this.deviceId, @JsonKey(name: 'activated_at') this.activatedAt, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _MessagingActivationDto.fromJson(Map<String, dynamic> json) => _$MessagingActivationDtoFromJson(json);

@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'status') final  String status;
@override@JsonKey(name: 'consent_accepted') final  bool consentAccepted;
@override@JsonKey(name: 'terms_version') final  String termsVersion;
@override@JsonKey(name: 'current_terms_version') final  String currentTermsVersion;
@override@JsonKey(name: 'requires_terms_acceptance') final  bool requiresTermsAcceptance;
@override@JsonKey(name: 'device_id') final  String? deviceId;
@override@JsonKey(name: 'activated_at') final  DateTime? activatedAt;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of MessagingActivationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessagingActivationDtoCopyWith<_MessagingActivationDto> get copyWith => __$MessagingActivationDtoCopyWithImpl<_MessagingActivationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessagingActivationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessagingActivationDto&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.status, status) || other.status == status)&&(identical(other.consentAccepted, consentAccepted) || other.consentAccepted == consentAccepted)&&(identical(other.termsVersion, termsVersion) || other.termsVersion == termsVersion)&&(identical(other.currentTermsVersion, currentTermsVersion) || other.currentTermsVersion == currentTermsVersion)&&(identical(other.requiresTermsAcceptance, requiresTermsAcceptance) || other.requiresTermsAcceptance == requiresTermsAcceptance)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.activatedAt, activatedAt) || other.activatedAt == activatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,status,consentAccepted,termsVersion,currentTermsVersion,requiresTermsAcceptance,deviceId,activatedAt,createdAt,updatedAt);

@override
String toString() {
  return 'MessagingActivationDto(userId: $userId, status: $status, consentAccepted: $consentAccepted, termsVersion: $termsVersion, currentTermsVersion: $currentTermsVersion, requiresTermsAcceptance: $requiresTermsAcceptance, deviceId: $deviceId, activatedAt: $activatedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MessagingActivationDtoCopyWith<$Res> implements $MessagingActivationDtoCopyWith<$Res> {
  factory _$MessagingActivationDtoCopyWith(_MessagingActivationDto value, $Res Function(_MessagingActivationDto) _then) = __$MessagingActivationDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'status') String status,@JsonKey(name: 'consent_accepted') bool consentAccepted,@JsonKey(name: 'terms_version') String termsVersion,@JsonKey(name: 'current_terms_version') String currentTermsVersion,@JsonKey(name: 'requires_terms_acceptance') bool requiresTermsAcceptance,@JsonKey(name: 'device_id') String? deviceId,@JsonKey(name: 'activated_at') DateTime? activatedAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$MessagingActivationDtoCopyWithImpl<$Res>
    implements _$MessagingActivationDtoCopyWith<$Res> {
  __$MessagingActivationDtoCopyWithImpl(this._self, this._then);

  final _MessagingActivationDto _self;
  final $Res Function(_MessagingActivationDto) _then;

/// Create a copy of MessagingActivationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? status = null,Object? consentAccepted = null,Object? termsVersion = null,Object? currentTermsVersion = null,Object? requiresTermsAcceptance = null,Object? deviceId = freezed,Object? activatedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_MessagingActivationDto(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,consentAccepted: null == consentAccepted ? _self.consentAccepted : consentAccepted // ignore: cast_nullable_to_non_nullable
as bool,termsVersion: null == termsVersion ? _self.termsVersion : termsVersion // ignore: cast_nullable_to_non_nullable
as String,currentTermsVersion: null == currentTermsVersion ? _self.currentTermsVersion : currentTermsVersion // ignore: cast_nullable_to_non_nullable
as String,requiresTermsAcceptance: null == requiresTermsAcceptance ? _self.requiresTermsAcceptance : requiresTermsAcceptance // ignore: cast_nullable_to_non_nullable
as bool,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,activatedAt: freezed == activatedAt ? _self.activatedAt : activatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$MessagingTermsDto {

 String get version; String get text;@JsonKey(name: 'published_at') DateTime? get publishedAt;
/// Create a copy of MessagingTermsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessagingTermsDtoCopyWith<MessagingTermsDto> get copyWith => _$MessagingTermsDtoCopyWithImpl<MessagingTermsDto>(this as MessagingTermsDto, _$identity);

  /// Serializes this MessagingTermsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagingTermsDto&&(identical(other.version, version) || other.version == version)&&(identical(other.text, text) || other.text == text)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,text,publishedAt);

@override
String toString() {
  return 'MessagingTermsDto(version: $version, text: $text, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class $MessagingTermsDtoCopyWith<$Res>  {
  factory $MessagingTermsDtoCopyWith(MessagingTermsDto value, $Res Function(MessagingTermsDto) _then) = _$MessagingTermsDtoCopyWithImpl;
@useResult
$Res call({
 String version, String text,@JsonKey(name: 'published_at') DateTime? publishedAt
});




}
/// @nodoc
class _$MessagingTermsDtoCopyWithImpl<$Res>
    implements $MessagingTermsDtoCopyWith<$Res> {
  _$MessagingTermsDtoCopyWithImpl(this._self, this._then);

  final MessagingTermsDto _self;
  final $Res Function(MessagingTermsDto) _then;

/// Create a copy of MessagingTermsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? text = null,Object? publishedAt = freezed,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MessagingTermsDto].
extension MessagingTermsDtoPatterns on MessagingTermsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessagingTermsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessagingTermsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessagingTermsDto value)  $default,){
final _that = this;
switch (_that) {
case _MessagingTermsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessagingTermsDto value)?  $default,){
final _that = this;
switch (_that) {
case _MessagingTermsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  String text, @JsonKey(name: 'published_at')  DateTime? publishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessagingTermsDto() when $default != null:
return $default(_that.version,_that.text,_that.publishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  String text, @JsonKey(name: 'published_at')  DateTime? publishedAt)  $default,) {final _that = this;
switch (_that) {
case _MessagingTermsDto():
return $default(_that.version,_that.text,_that.publishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  String text, @JsonKey(name: 'published_at')  DateTime? publishedAt)?  $default,) {final _that = this;
switch (_that) {
case _MessagingTermsDto() when $default != null:
return $default(_that.version,_that.text,_that.publishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessagingTermsDto implements MessagingTermsDto {
  const _MessagingTermsDto({required this.version, required this.text, @JsonKey(name: 'published_at') this.publishedAt});
  factory _MessagingTermsDto.fromJson(Map<String, dynamic> json) => _$MessagingTermsDtoFromJson(json);

@override final  String version;
@override final  String text;
@override@JsonKey(name: 'published_at') final  DateTime? publishedAt;

/// Create a copy of MessagingTermsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessagingTermsDtoCopyWith<_MessagingTermsDto> get copyWith => __$MessagingTermsDtoCopyWithImpl<_MessagingTermsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessagingTermsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessagingTermsDto&&(identical(other.version, version) || other.version == version)&&(identical(other.text, text) || other.text == text)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,text,publishedAt);

@override
String toString() {
  return 'MessagingTermsDto(version: $version, text: $text, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class _$MessagingTermsDtoCopyWith<$Res> implements $MessagingTermsDtoCopyWith<$Res> {
  factory _$MessagingTermsDtoCopyWith(_MessagingTermsDto value, $Res Function(_MessagingTermsDto) _then) = __$MessagingTermsDtoCopyWithImpl;
@override @useResult
$Res call({
 String version, String text,@JsonKey(name: 'published_at') DateTime? publishedAt
});




}
/// @nodoc
class __$MessagingTermsDtoCopyWithImpl<$Res>
    implements _$MessagingTermsDtoCopyWith<$Res> {
  __$MessagingTermsDtoCopyWithImpl(this._self, this._then);

  final _MessagingTermsDto _self;
  final $Res Function(_MessagingTermsDto) _then;

/// Create a copy of MessagingTermsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? text = null,Object? publishedAt = freezed,}) {
  return _then(_MessagingTermsDto(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
