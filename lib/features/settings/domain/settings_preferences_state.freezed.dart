// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_preferences_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingsPreferencesState {

 AppLockTimeout get appLockTimeout; bool get biometricPrompt;
/// Create a copy of SettingsPreferencesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsPreferencesStateCopyWith<SettingsPreferencesState> get copyWith => _$SettingsPreferencesStateCopyWithImpl<SettingsPreferencesState>(this as SettingsPreferencesState, _$identity);

  /// Serializes this SettingsPreferencesState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsPreferencesState&&(identical(other.appLockTimeout, appLockTimeout) || other.appLockTimeout == appLockTimeout)&&(identical(other.biometricPrompt, biometricPrompt) || other.biometricPrompt == biometricPrompt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appLockTimeout,biometricPrompt);

@override
String toString() {
  return 'SettingsPreferencesState(appLockTimeout: $appLockTimeout, biometricPrompt: $biometricPrompt)';
}


}

/// @nodoc
abstract mixin class $SettingsPreferencesStateCopyWith<$Res>  {
  factory $SettingsPreferencesStateCopyWith(SettingsPreferencesState value, $Res Function(SettingsPreferencesState) _then) = _$SettingsPreferencesStateCopyWithImpl;
@useResult
$Res call({
 AppLockTimeout appLockTimeout, bool biometricPrompt
});




}
/// @nodoc
class _$SettingsPreferencesStateCopyWithImpl<$Res>
    implements $SettingsPreferencesStateCopyWith<$Res> {
  _$SettingsPreferencesStateCopyWithImpl(this._self, this._then);

  final SettingsPreferencesState _self;
  final $Res Function(SettingsPreferencesState) _then;

/// Create a copy of SettingsPreferencesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appLockTimeout = null,Object? biometricPrompt = null,}) {
  return _then(_self.copyWith(
appLockTimeout: null == appLockTimeout ? _self.appLockTimeout : appLockTimeout // ignore: cast_nullable_to_non_nullable
as AppLockTimeout,biometricPrompt: null == biometricPrompt ? _self.biometricPrompt : biometricPrompt // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsPreferencesState].
extension SettingsPreferencesStatePatterns on SettingsPreferencesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsPreferencesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsPreferencesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsPreferencesState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsPreferencesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsPreferencesState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsPreferencesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppLockTimeout appLockTimeout,  bool biometricPrompt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsPreferencesState() when $default != null:
return $default(_that.appLockTimeout,_that.biometricPrompt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppLockTimeout appLockTimeout,  bool biometricPrompt)  $default,) {final _that = this;
switch (_that) {
case _SettingsPreferencesState():
return $default(_that.appLockTimeout,_that.biometricPrompt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppLockTimeout appLockTimeout,  bool biometricPrompt)?  $default,) {final _that = this;
switch (_that) {
case _SettingsPreferencesState() when $default != null:
return $default(_that.appLockTimeout,_that.biometricPrompt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettingsPreferencesState implements SettingsPreferencesState {
  const _SettingsPreferencesState({this.appLockTimeout = AppLockTimeout.minute1, this.biometricPrompt = true});
  factory _SettingsPreferencesState.fromJson(Map<String, dynamic> json) => _$SettingsPreferencesStateFromJson(json);

@override@JsonKey() final  AppLockTimeout appLockTimeout;
@override@JsonKey() final  bool biometricPrompt;

/// Create a copy of SettingsPreferencesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsPreferencesStateCopyWith<_SettingsPreferencesState> get copyWith => __$SettingsPreferencesStateCopyWithImpl<_SettingsPreferencesState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingsPreferencesStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsPreferencesState&&(identical(other.appLockTimeout, appLockTimeout) || other.appLockTimeout == appLockTimeout)&&(identical(other.biometricPrompt, biometricPrompt) || other.biometricPrompt == biometricPrompt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appLockTimeout,biometricPrompt);

@override
String toString() {
  return 'SettingsPreferencesState(appLockTimeout: $appLockTimeout, biometricPrompt: $biometricPrompt)';
}


}

/// @nodoc
abstract mixin class _$SettingsPreferencesStateCopyWith<$Res> implements $SettingsPreferencesStateCopyWith<$Res> {
  factory _$SettingsPreferencesStateCopyWith(_SettingsPreferencesState value, $Res Function(_SettingsPreferencesState) _then) = __$SettingsPreferencesStateCopyWithImpl;
@override @useResult
$Res call({
 AppLockTimeout appLockTimeout, bool biometricPrompt
});




}
/// @nodoc
class __$SettingsPreferencesStateCopyWithImpl<$Res>
    implements _$SettingsPreferencesStateCopyWith<$Res> {
  __$SettingsPreferencesStateCopyWithImpl(this._self, this._then);

  final _SettingsPreferencesState _self;
  final $Res Function(_SettingsPreferencesState) _then;

/// Create a copy of SettingsPreferencesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appLockTimeout = null,Object? biometricPrompt = null,}) {
  return _then(_SettingsPreferencesState(
appLockTimeout: null == appLockTimeout ? _self.appLockTimeout : appLockTimeout // ignore: cast_nullable_to_non_nullable
as AppLockTimeout,biometricPrompt: null == biometricPrompt ? _self.biometricPrompt : biometricPrompt // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
