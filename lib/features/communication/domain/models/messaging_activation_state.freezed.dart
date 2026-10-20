// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'messaging_activation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessagingActivationState {

 String? get userId; String? get deviceId; String? get status; bool get consentAccepted; String? get termsVersion; String? get currentTermsVersion; bool get requiresTermsAcceptance; String? get termsText; bool get hasLocalActivation; String? get errorMessage; String get keyRegistrationStatus;
/// Create a copy of MessagingActivationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessagingActivationStateCopyWith<MessagingActivationState> get copyWith => _$MessagingActivationStateCopyWithImpl<MessagingActivationState>(this as MessagingActivationState, _$identity);

  /// Serializes this MessagingActivationState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagingActivationState&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.status, status) || other.status == status)&&(identical(other.consentAccepted, consentAccepted) || other.consentAccepted == consentAccepted)&&(identical(other.termsVersion, termsVersion) || other.termsVersion == termsVersion)&&(identical(other.currentTermsVersion, currentTermsVersion) || other.currentTermsVersion == currentTermsVersion)&&(identical(other.requiresTermsAcceptance, requiresTermsAcceptance) || other.requiresTermsAcceptance == requiresTermsAcceptance)&&(identical(other.termsText, termsText) || other.termsText == termsText)&&(identical(other.hasLocalActivation, hasLocalActivation) || other.hasLocalActivation == hasLocalActivation)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.keyRegistrationStatus, keyRegistrationStatus) || other.keyRegistrationStatus == keyRegistrationStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,deviceId,status,consentAccepted,termsVersion,currentTermsVersion,requiresTermsAcceptance,termsText,hasLocalActivation,errorMessage,keyRegistrationStatus);

@override
String toString() {
  return 'MessagingActivationState(userId: $userId, deviceId: $deviceId, status: $status, consentAccepted: $consentAccepted, termsVersion: $termsVersion, currentTermsVersion: $currentTermsVersion, requiresTermsAcceptance: $requiresTermsAcceptance, termsText: $termsText, hasLocalActivation: $hasLocalActivation, errorMessage: $errorMessage, keyRegistrationStatus: $keyRegistrationStatus)';
}


}

/// @nodoc
abstract mixin class $MessagingActivationStateCopyWith<$Res>  {
  factory $MessagingActivationStateCopyWith(MessagingActivationState value, $Res Function(MessagingActivationState) _then) = _$MessagingActivationStateCopyWithImpl;
@useResult
$Res call({
 String? userId, String? deviceId, String? status, bool consentAccepted, String? termsVersion, String? currentTermsVersion, bool requiresTermsAcceptance, String? termsText, bool hasLocalActivation, String? errorMessage, String keyRegistrationStatus
});




}
/// @nodoc
class _$MessagingActivationStateCopyWithImpl<$Res>
    implements $MessagingActivationStateCopyWith<$Res> {
  _$MessagingActivationStateCopyWithImpl(this._self, this._then);

  final MessagingActivationState _self;
  final $Res Function(MessagingActivationState) _then;

/// Create a copy of MessagingActivationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = freezed,Object? deviceId = freezed,Object? status = freezed,Object? consentAccepted = null,Object? termsVersion = freezed,Object? currentTermsVersion = freezed,Object? requiresTermsAcceptance = null,Object? termsText = freezed,Object? hasLocalActivation = null,Object? errorMessage = freezed,Object? keyRegistrationStatus = null,}) {
  return _then(_self.copyWith(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,consentAccepted: null == consentAccepted ? _self.consentAccepted : consentAccepted // ignore: cast_nullable_to_non_nullable
as bool,termsVersion: freezed == termsVersion ? _self.termsVersion : termsVersion // ignore: cast_nullable_to_non_nullable
as String?,currentTermsVersion: freezed == currentTermsVersion ? _self.currentTermsVersion : currentTermsVersion // ignore: cast_nullable_to_non_nullable
as String?,requiresTermsAcceptance: null == requiresTermsAcceptance ? _self.requiresTermsAcceptance : requiresTermsAcceptance // ignore: cast_nullable_to_non_nullable
as bool,termsText: freezed == termsText ? _self.termsText : termsText // ignore: cast_nullable_to_non_nullable
as String?,hasLocalActivation: null == hasLocalActivation ? _self.hasLocalActivation : hasLocalActivation // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,keyRegistrationStatus: null == keyRegistrationStatus ? _self.keyRegistrationStatus : keyRegistrationStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MessagingActivationState].
extension MessagingActivationStatePatterns on MessagingActivationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessagingActivationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessagingActivationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessagingActivationState value)  $default,){
final _that = this;
switch (_that) {
case _MessagingActivationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessagingActivationState value)?  $default,){
final _that = this;
switch (_that) {
case _MessagingActivationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? userId,  String? deviceId,  String? status,  bool consentAccepted,  String? termsVersion,  String? currentTermsVersion,  bool requiresTermsAcceptance,  String? termsText,  bool hasLocalActivation,  String? errorMessage,  String keyRegistrationStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessagingActivationState() when $default != null:
return $default(_that.userId,_that.deviceId,_that.status,_that.consentAccepted,_that.termsVersion,_that.currentTermsVersion,_that.requiresTermsAcceptance,_that.termsText,_that.hasLocalActivation,_that.errorMessage,_that.keyRegistrationStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? userId,  String? deviceId,  String? status,  bool consentAccepted,  String? termsVersion,  String? currentTermsVersion,  bool requiresTermsAcceptance,  String? termsText,  bool hasLocalActivation,  String? errorMessage,  String keyRegistrationStatus)  $default,) {final _that = this;
switch (_that) {
case _MessagingActivationState():
return $default(_that.userId,_that.deviceId,_that.status,_that.consentAccepted,_that.termsVersion,_that.currentTermsVersion,_that.requiresTermsAcceptance,_that.termsText,_that.hasLocalActivation,_that.errorMessage,_that.keyRegistrationStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? userId,  String? deviceId,  String? status,  bool consentAccepted,  String? termsVersion,  String? currentTermsVersion,  bool requiresTermsAcceptance,  String? termsText,  bool hasLocalActivation,  String? errorMessage,  String keyRegistrationStatus)?  $default,) {final _that = this;
switch (_that) {
case _MessagingActivationState() when $default != null:
return $default(_that.userId,_that.deviceId,_that.status,_that.consentAccepted,_that.termsVersion,_that.currentTermsVersion,_that.requiresTermsAcceptance,_that.termsText,_that.hasLocalActivation,_that.errorMessage,_that.keyRegistrationStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessagingActivationState extends MessagingActivationState {
  const _MessagingActivationState({this.userId, this.deviceId, this.status, this.consentAccepted = false, this.termsVersion, this.currentTermsVersion, this.requiresTermsAcceptance = false, this.termsText, this.hasLocalActivation = false, this.errorMessage, this.keyRegistrationStatus = 'not_started'}): super._();
  factory _MessagingActivationState.fromJson(Map<String, dynamic> json) => _$MessagingActivationStateFromJson(json);

@override final  String? userId;
@override final  String? deviceId;
@override final  String? status;
@override@JsonKey() final  bool consentAccepted;
@override final  String? termsVersion;
@override final  String? currentTermsVersion;
@override@JsonKey() final  bool requiresTermsAcceptance;
@override final  String? termsText;
@override@JsonKey() final  bool hasLocalActivation;
@override final  String? errorMessage;
@override@JsonKey() final  String keyRegistrationStatus;

/// Create a copy of MessagingActivationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessagingActivationStateCopyWith<_MessagingActivationState> get copyWith => __$MessagingActivationStateCopyWithImpl<_MessagingActivationState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessagingActivationStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessagingActivationState&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.status, status) || other.status == status)&&(identical(other.consentAccepted, consentAccepted) || other.consentAccepted == consentAccepted)&&(identical(other.termsVersion, termsVersion) || other.termsVersion == termsVersion)&&(identical(other.currentTermsVersion, currentTermsVersion) || other.currentTermsVersion == currentTermsVersion)&&(identical(other.requiresTermsAcceptance, requiresTermsAcceptance) || other.requiresTermsAcceptance == requiresTermsAcceptance)&&(identical(other.termsText, termsText) || other.termsText == termsText)&&(identical(other.hasLocalActivation, hasLocalActivation) || other.hasLocalActivation == hasLocalActivation)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.keyRegistrationStatus, keyRegistrationStatus) || other.keyRegistrationStatus == keyRegistrationStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,deviceId,status,consentAccepted,termsVersion,currentTermsVersion,requiresTermsAcceptance,termsText,hasLocalActivation,errorMessage,keyRegistrationStatus);

@override
String toString() {
  return 'MessagingActivationState(userId: $userId, deviceId: $deviceId, status: $status, consentAccepted: $consentAccepted, termsVersion: $termsVersion, currentTermsVersion: $currentTermsVersion, requiresTermsAcceptance: $requiresTermsAcceptance, termsText: $termsText, hasLocalActivation: $hasLocalActivation, errorMessage: $errorMessage, keyRegistrationStatus: $keyRegistrationStatus)';
}


}

/// @nodoc
abstract mixin class _$MessagingActivationStateCopyWith<$Res> implements $MessagingActivationStateCopyWith<$Res> {
  factory _$MessagingActivationStateCopyWith(_MessagingActivationState value, $Res Function(_MessagingActivationState) _then) = __$MessagingActivationStateCopyWithImpl;
@override @useResult
$Res call({
 String? userId, String? deviceId, String? status, bool consentAccepted, String? termsVersion, String? currentTermsVersion, bool requiresTermsAcceptance, String? termsText, bool hasLocalActivation, String? errorMessage, String keyRegistrationStatus
});




}
/// @nodoc
class __$MessagingActivationStateCopyWithImpl<$Res>
    implements _$MessagingActivationStateCopyWith<$Res> {
  __$MessagingActivationStateCopyWithImpl(this._self, this._then);

  final _MessagingActivationState _self;
  final $Res Function(_MessagingActivationState) _then;

/// Create a copy of MessagingActivationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = freezed,Object? deviceId = freezed,Object? status = freezed,Object? consentAccepted = null,Object? termsVersion = freezed,Object? currentTermsVersion = freezed,Object? requiresTermsAcceptance = null,Object? termsText = freezed,Object? hasLocalActivation = null,Object? errorMessage = freezed,Object? keyRegistrationStatus = null,}) {
  return _then(_MessagingActivationState(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,consentAccepted: null == consentAccepted ? _self.consentAccepted : consentAccepted // ignore: cast_nullable_to_non_nullable
as bool,termsVersion: freezed == termsVersion ? _self.termsVersion : termsVersion // ignore: cast_nullable_to_non_nullable
as String?,currentTermsVersion: freezed == currentTermsVersion ? _self.currentTermsVersion : currentTermsVersion // ignore: cast_nullable_to_non_nullable
as String?,requiresTermsAcceptance: null == requiresTermsAcceptance ? _self.requiresTermsAcceptance : requiresTermsAcceptance // ignore: cast_nullable_to_non_nullable
as bool,termsText: freezed == termsText ? _self.termsText : termsText // ignore: cast_nullable_to_non_nullable
as String?,hasLocalActivation: null == hasLocalActivation ? _self.hasLocalActivation : hasLocalActivation // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,keyRegistrationStatus: null == keyRegistrationStatus ? _self.keyRegistrationStatus : keyRegistrationStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
