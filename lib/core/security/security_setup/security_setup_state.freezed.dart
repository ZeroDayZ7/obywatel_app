// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'security_setup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SecuritySetupState {

 bool get pinSet; bool get biometricAvailable; bool get biometricSet; bool get trustDevice;
/// Create a copy of SecuritySetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SecuritySetupStateCopyWith<SecuritySetupState> get copyWith => _$SecuritySetupStateCopyWithImpl<SecuritySetupState>(this as SecuritySetupState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SecuritySetupState&&(identical(other.pinSet, pinSet) || other.pinSet == pinSet)&&(identical(other.biometricAvailable, biometricAvailable) || other.biometricAvailable == biometricAvailable)&&(identical(other.biometricSet, biometricSet) || other.biometricSet == biometricSet)&&(identical(other.trustDevice, trustDevice) || other.trustDevice == trustDevice));
}


@override
int get hashCode => Object.hash(runtimeType,pinSet,biometricAvailable,biometricSet,trustDevice);

@override
String toString() {
  return 'SecuritySetupState(pinSet: $pinSet, biometricAvailable: $biometricAvailable, biometricSet: $biometricSet, trustDevice: $trustDevice)';
}


}

/// @nodoc
abstract mixin class $SecuritySetupStateCopyWith<$Res>  {
  factory $SecuritySetupStateCopyWith(SecuritySetupState value, $Res Function(SecuritySetupState) _then) = _$SecuritySetupStateCopyWithImpl;
@useResult
$Res call({
 bool pinSet, bool biometricAvailable, bool biometricSet, bool trustDevice
});




}
/// @nodoc
class _$SecuritySetupStateCopyWithImpl<$Res>
    implements $SecuritySetupStateCopyWith<$Res> {
  _$SecuritySetupStateCopyWithImpl(this._self, this._then);

  final SecuritySetupState _self;
  final $Res Function(SecuritySetupState) _then;

/// Create a copy of SecuritySetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pinSet = null,Object? biometricAvailable = null,Object? biometricSet = null,Object? trustDevice = null,}) {
  return _then(_self.copyWith(
pinSet: null == pinSet ? _self.pinSet : pinSet // ignore: cast_nullable_to_non_nullable
as bool,biometricAvailable: null == biometricAvailable ? _self.biometricAvailable : biometricAvailable // ignore: cast_nullable_to_non_nullable
as bool,biometricSet: null == biometricSet ? _self.biometricSet : biometricSet // ignore: cast_nullable_to_non_nullable
as bool,trustDevice: null == trustDevice ? _self.trustDevice : trustDevice // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SecuritySetupState].
extension SecuritySetupStatePatterns on SecuritySetupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SecuritySetupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SecuritySetupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SecuritySetupState value)  $default,){
final _that = this;
switch (_that) {
case _SecuritySetupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SecuritySetupState value)?  $default,){
final _that = this;
switch (_that) {
case _SecuritySetupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool pinSet,  bool biometricAvailable,  bool biometricSet,  bool trustDevice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SecuritySetupState() when $default != null:
return $default(_that.pinSet,_that.biometricAvailable,_that.biometricSet,_that.trustDevice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool pinSet,  bool biometricAvailable,  bool biometricSet,  bool trustDevice)  $default,) {final _that = this;
switch (_that) {
case _SecuritySetupState():
return $default(_that.pinSet,_that.biometricAvailable,_that.biometricSet,_that.trustDevice);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool pinSet,  bool biometricAvailable,  bool biometricSet,  bool trustDevice)?  $default,) {final _that = this;
switch (_that) {
case _SecuritySetupState() when $default != null:
return $default(_that.pinSet,_that.biometricAvailable,_that.biometricSet,_that.trustDevice);case _:
  return null;

}
}

}

/// @nodoc


class _SecuritySetupState extends SecuritySetupState {
  const _SecuritySetupState({required this.pinSet, required this.biometricAvailable, required this.biometricSet, this.trustDevice = true}): super._();
  

@override final  bool pinSet;
@override final  bool biometricAvailable;
@override final  bool biometricSet;
@override@JsonKey() final  bool trustDevice;

/// Create a copy of SecuritySetupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SecuritySetupStateCopyWith<_SecuritySetupState> get copyWith => __$SecuritySetupStateCopyWithImpl<_SecuritySetupState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecuritySetupState&&(identical(other.pinSet, pinSet) || other.pinSet == pinSet)&&(identical(other.biometricAvailable, biometricAvailable) || other.biometricAvailable == biometricAvailable)&&(identical(other.biometricSet, biometricSet) || other.biometricSet == biometricSet)&&(identical(other.trustDevice, trustDevice) || other.trustDevice == trustDevice));
}


@override
int get hashCode => Object.hash(runtimeType,pinSet,biometricAvailable,biometricSet,trustDevice);

@override
String toString() {
  return 'SecuritySetupState(pinSet: $pinSet, biometricAvailable: $biometricAvailable, biometricSet: $biometricSet, trustDevice: $trustDevice)';
}


}

/// @nodoc
abstract mixin class _$SecuritySetupStateCopyWith<$Res> implements $SecuritySetupStateCopyWith<$Res> {
  factory _$SecuritySetupStateCopyWith(_SecuritySetupState value, $Res Function(_SecuritySetupState) _then) = __$SecuritySetupStateCopyWithImpl;
@override @useResult
$Res call({
 bool pinSet, bool biometricAvailable, bool biometricSet, bool trustDevice
});




}
/// @nodoc
class __$SecuritySetupStateCopyWithImpl<$Res>
    implements _$SecuritySetupStateCopyWith<$Res> {
  __$SecuritySetupStateCopyWithImpl(this._self, this._then);

  final _SecuritySetupState _self;
  final $Res Function(_SecuritySetupState) _then;

/// Create a copy of SecuritySetupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pinSet = null,Object? biometricAvailable = null,Object? biometricSet = null,Object? trustDevice = null,}) {
  return _then(_SecuritySetupState(
pinSet: null == pinSet ? _self.pinSet : pinSet // ignore: cast_nullable_to_non_nullable
as bool,biometricAvailable: null == biometricAvailable ? _self.biometricAvailable : biometricAvailable // ignore: cast_nullable_to_non_nullable
as bool,biometricSet: null == biometricSet ? _self.biometricSet : biometricSet // ignore: cast_nullable_to_non_nullable
as bool,trustDevice: null == trustDevice ? _self.trustDevice : trustDevice // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
