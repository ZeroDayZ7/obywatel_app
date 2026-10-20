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

 MessagingActivationDto? get status; MessagingTermsDto? get terms; String? get errorMessage; String get keyRegistrationStatus;
/// Create a copy of MessagingActivationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessagingActivationStateCopyWith<MessagingActivationState> get copyWith => _$MessagingActivationStateCopyWithImpl<MessagingActivationState>(this as MessagingActivationState, _$identity);

  /// Serializes this MessagingActivationState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagingActivationState&&(identical(other.status, status) || other.status == status)&&(identical(other.terms, terms) || other.terms == terms)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.keyRegistrationStatus, keyRegistrationStatus) || other.keyRegistrationStatus == keyRegistrationStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,terms,errorMessage,keyRegistrationStatus);

@override
String toString() {
  return 'MessagingActivationState(status: $status, terms: $terms, errorMessage: $errorMessage, keyRegistrationStatus: $keyRegistrationStatus)';
}


}

/// @nodoc
abstract mixin class $MessagingActivationStateCopyWith<$Res>  {
  factory $MessagingActivationStateCopyWith(MessagingActivationState value, $Res Function(MessagingActivationState) _then) = _$MessagingActivationStateCopyWithImpl;
@useResult
$Res call({
 MessagingActivationDto? status, MessagingTermsDto? terms, String? errorMessage, String keyRegistrationStatus
});


$MessagingActivationDtoCopyWith<$Res>? get status;$MessagingTermsDtoCopyWith<$Res>? get terms;

}
/// @nodoc
class _$MessagingActivationStateCopyWithImpl<$Res>
    implements $MessagingActivationStateCopyWith<$Res> {
  _$MessagingActivationStateCopyWithImpl(this._self, this._then);

  final MessagingActivationState _self;
  final $Res Function(MessagingActivationState) _then;

/// Create a copy of MessagingActivationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = freezed,Object? terms = freezed,Object? errorMessage = freezed,Object? keyRegistrationStatus = null,}) {
  return _then(_self.copyWith(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MessagingActivationDto?,terms: freezed == terms ? _self.terms : terms // ignore: cast_nullable_to_non_nullable
as MessagingTermsDto?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,keyRegistrationStatus: null == keyRegistrationStatus ? _self.keyRegistrationStatus : keyRegistrationStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of MessagingActivationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessagingActivationDtoCopyWith<$Res>? get status {
    if (_self.status == null) {
    return null;
  }

  return $MessagingActivationDtoCopyWith<$Res>(_self.status!, (value) {
    return _then(_self.copyWith(status: value));
  });
}/// Create a copy of MessagingActivationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessagingTermsDtoCopyWith<$Res>? get terms {
    if (_self.terms == null) {
    return null;
  }

  return $MessagingTermsDtoCopyWith<$Res>(_self.terms!, (value) {
    return _then(_self.copyWith(terms: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MessagingActivationDto? status,  MessagingTermsDto? terms,  String? errorMessage,  String keyRegistrationStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessagingActivationState() when $default != null:
return $default(_that.status,_that.terms,_that.errorMessage,_that.keyRegistrationStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MessagingActivationDto? status,  MessagingTermsDto? terms,  String? errorMessage,  String keyRegistrationStatus)  $default,) {final _that = this;
switch (_that) {
case _MessagingActivationState():
return $default(_that.status,_that.terms,_that.errorMessage,_that.keyRegistrationStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MessagingActivationDto? status,  MessagingTermsDto? terms,  String? errorMessage,  String keyRegistrationStatus)?  $default,) {final _that = this;
switch (_that) {
case _MessagingActivationState() when $default != null:
return $default(_that.status,_that.terms,_that.errorMessage,_that.keyRegistrationStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessagingActivationState extends MessagingActivationState {
  const _MessagingActivationState({this.status, this.terms, this.errorMessage, this.keyRegistrationStatus = 'not_started'}): super._();
  factory _MessagingActivationState.fromJson(Map<String, dynamic> json) => _$MessagingActivationStateFromJson(json);

@override final  MessagingActivationDto? status;
@override final  MessagingTermsDto? terms;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessagingActivationState&&(identical(other.status, status) || other.status == status)&&(identical(other.terms, terms) || other.terms == terms)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.keyRegistrationStatus, keyRegistrationStatus) || other.keyRegistrationStatus == keyRegistrationStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,terms,errorMessage,keyRegistrationStatus);

@override
String toString() {
  return 'MessagingActivationState(status: $status, terms: $terms, errorMessage: $errorMessage, keyRegistrationStatus: $keyRegistrationStatus)';
}


}

/// @nodoc
abstract mixin class _$MessagingActivationStateCopyWith<$Res> implements $MessagingActivationStateCopyWith<$Res> {
  factory _$MessagingActivationStateCopyWith(_MessagingActivationState value, $Res Function(_MessagingActivationState) _then) = __$MessagingActivationStateCopyWithImpl;
@override @useResult
$Res call({
 MessagingActivationDto? status, MessagingTermsDto? terms, String? errorMessage, String keyRegistrationStatus
});


@override $MessagingActivationDtoCopyWith<$Res>? get status;@override $MessagingTermsDtoCopyWith<$Res>? get terms;

}
/// @nodoc
class __$MessagingActivationStateCopyWithImpl<$Res>
    implements _$MessagingActivationStateCopyWith<$Res> {
  __$MessagingActivationStateCopyWithImpl(this._self, this._then);

  final _MessagingActivationState _self;
  final $Res Function(_MessagingActivationState) _then;

/// Create a copy of MessagingActivationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? terms = freezed,Object? errorMessage = freezed,Object? keyRegistrationStatus = null,}) {
  return _then(_MessagingActivationState(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MessagingActivationDto?,terms: freezed == terms ? _self.terms : terms // ignore: cast_nullable_to_non_nullable
as MessagingTermsDto?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,keyRegistrationStatus: null == keyRegistrationStatus ? _self.keyRegistrationStatus : keyRegistrationStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of MessagingActivationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessagingActivationDtoCopyWith<$Res>? get status {
    if (_self.status == null) {
    return null;
  }

  return $MessagingActivationDtoCopyWith<$Res>(_self.status!, (value) {
    return _then(_self.copyWith(status: value));
  });
}/// Create a copy of MessagingActivationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessagingTermsDtoCopyWith<$Res>? get terms {
    if (_self.terms == null) {
    return null;
  }

  return $MessagingTermsDtoCopyWith<$Res>(_self.terms!, (value) {
    return _then(_self.copyWith(terms: value));
  });
}
}

// dart format on
