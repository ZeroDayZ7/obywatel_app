// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_capabilities_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceCapabilitiesState {

 bool get hasVibration; bool get hasAmplitudeControl; bool get hasCustomVibrations; bool get initialized;
/// Create a copy of DeviceCapabilitiesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceCapabilitiesStateCopyWith<DeviceCapabilitiesState> get copyWith => _$DeviceCapabilitiesStateCopyWithImpl<DeviceCapabilitiesState>(this as DeviceCapabilitiesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceCapabilitiesState&&(identical(other.hasVibration, hasVibration) || other.hasVibration == hasVibration)&&(identical(other.hasAmplitudeControl, hasAmplitudeControl) || other.hasAmplitudeControl == hasAmplitudeControl)&&(identical(other.hasCustomVibrations, hasCustomVibrations) || other.hasCustomVibrations == hasCustomVibrations)&&(identical(other.initialized, initialized) || other.initialized == initialized));
}


@override
int get hashCode => Object.hash(runtimeType,hasVibration,hasAmplitudeControl,hasCustomVibrations,initialized);

@override
String toString() {
  return 'DeviceCapabilitiesState(hasVibration: $hasVibration, hasAmplitudeControl: $hasAmplitudeControl, hasCustomVibrations: $hasCustomVibrations, initialized: $initialized)';
}


}

/// @nodoc
abstract mixin class $DeviceCapabilitiesStateCopyWith<$Res>  {
  factory $DeviceCapabilitiesStateCopyWith(DeviceCapabilitiesState value, $Res Function(DeviceCapabilitiesState) _then) = _$DeviceCapabilitiesStateCopyWithImpl;
@useResult
$Res call({
 bool hasVibration, bool hasAmplitudeControl, bool hasCustomVibrations, bool initialized
});




}
/// @nodoc
class _$DeviceCapabilitiesStateCopyWithImpl<$Res>
    implements $DeviceCapabilitiesStateCopyWith<$Res> {
  _$DeviceCapabilitiesStateCopyWithImpl(this._self, this._then);

  final DeviceCapabilitiesState _self;
  final $Res Function(DeviceCapabilitiesState) _then;

/// Create a copy of DeviceCapabilitiesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasVibration = null,Object? hasAmplitudeControl = null,Object? hasCustomVibrations = null,Object? initialized = null,}) {
  return _then(_self.copyWith(
hasVibration: null == hasVibration ? _self.hasVibration : hasVibration // ignore: cast_nullable_to_non_nullable
as bool,hasAmplitudeControl: null == hasAmplitudeControl ? _self.hasAmplitudeControl : hasAmplitudeControl // ignore: cast_nullable_to_non_nullable
as bool,hasCustomVibrations: null == hasCustomVibrations ? _self.hasCustomVibrations : hasCustomVibrations // ignore: cast_nullable_to_non_nullable
as bool,initialized: null == initialized ? _self.initialized : initialized // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceCapabilitiesState].
extension DeviceCapabilitiesStatePatterns on DeviceCapabilitiesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceCapabilitiesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceCapabilitiesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceCapabilitiesState value)  $default,){
final _that = this;
switch (_that) {
case _DeviceCapabilitiesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceCapabilitiesState value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceCapabilitiesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool hasVibration,  bool hasAmplitudeControl,  bool hasCustomVibrations,  bool initialized)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceCapabilitiesState() when $default != null:
return $default(_that.hasVibration,_that.hasAmplitudeControl,_that.hasCustomVibrations,_that.initialized);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool hasVibration,  bool hasAmplitudeControl,  bool hasCustomVibrations,  bool initialized)  $default,) {final _that = this;
switch (_that) {
case _DeviceCapabilitiesState():
return $default(_that.hasVibration,_that.hasAmplitudeControl,_that.hasCustomVibrations,_that.initialized);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool hasVibration,  bool hasAmplitudeControl,  bool hasCustomVibrations,  bool initialized)?  $default,) {final _that = this;
switch (_that) {
case _DeviceCapabilitiesState() when $default != null:
return $default(_that.hasVibration,_that.hasAmplitudeControl,_that.hasCustomVibrations,_that.initialized);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceCapabilitiesState extends DeviceCapabilitiesState {
  const _DeviceCapabilitiesState({this.hasVibration = false, this.hasAmplitudeControl = false, this.hasCustomVibrations = false, this.initialized = false}): super._();
  

@override@JsonKey() final  bool hasVibration;
@override@JsonKey() final  bool hasAmplitudeControl;
@override@JsonKey() final  bool hasCustomVibrations;
@override@JsonKey() final  bool initialized;

/// Create a copy of DeviceCapabilitiesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceCapabilitiesStateCopyWith<_DeviceCapabilitiesState> get copyWith => __$DeviceCapabilitiesStateCopyWithImpl<_DeviceCapabilitiesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceCapabilitiesState&&(identical(other.hasVibration, hasVibration) || other.hasVibration == hasVibration)&&(identical(other.hasAmplitudeControl, hasAmplitudeControl) || other.hasAmplitudeControl == hasAmplitudeControl)&&(identical(other.hasCustomVibrations, hasCustomVibrations) || other.hasCustomVibrations == hasCustomVibrations)&&(identical(other.initialized, initialized) || other.initialized == initialized));
}


@override
int get hashCode => Object.hash(runtimeType,hasVibration,hasAmplitudeControl,hasCustomVibrations,initialized);

@override
String toString() {
  return 'DeviceCapabilitiesState(hasVibration: $hasVibration, hasAmplitudeControl: $hasAmplitudeControl, hasCustomVibrations: $hasCustomVibrations, initialized: $initialized)';
}


}

/// @nodoc
abstract mixin class _$DeviceCapabilitiesStateCopyWith<$Res> implements $DeviceCapabilitiesStateCopyWith<$Res> {
  factory _$DeviceCapabilitiesStateCopyWith(_DeviceCapabilitiesState value, $Res Function(_DeviceCapabilitiesState) _then) = __$DeviceCapabilitiesStateCopyWithImpl;
@override @useResult
$Res call({
 bool hasVibration, bool hasAmplitudeControl, bool hasCustomVibrations, bool initialized
});




}
/// @nodoc
class __$DeviceCapabilitiesStateCopyWithImpl<$Res>
    implements _$DeviceCapabilitiesStateCopyWith<$Res> {
  __$DeviceCapabilitiesStateCopyWithImpl(this._self, this._then);

  final _DeviceCapabilitiesState _self;
  final $Res Function(_DeviceCapabilitiesState) _then;

/// Create a copy of DeviceCapabilitiesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasVibration = null,Object? hasAmplitudeControl = null,Object? hasCustomVibrations = null,Object? initialized = null,}) {
  return _then(_DeviceCapabilitiesState(
hasVibration: null == hasVibration ? _self.hasVibration : hasVibration // ignore: cast_nullable_to_non_nullable
as bool,hasAmplitudeControl: null == hasAmplitudeControl ? _self.hasAmplitudeControl : hasAmplitudeControl // ignore: cast_nullable_to_non_nullable
as bool,hasCustomVibrations: null == hasCustomVibrations ? _self.hasCustomVibrations : hasCustomVibrations // ignore: cast_nullable_to_non_nullable
as bool,initialized: null == initialized ? _self.initialized : initialized // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
