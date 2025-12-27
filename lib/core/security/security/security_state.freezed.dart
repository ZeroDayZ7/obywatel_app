// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'security_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SecurityState {

 bool get hasLocalLock;// Czy ekran blokady jest aktywny?
 bool get isPinConfigured;// Czy user ustawił PIN?
 bool get isBiometricEnabled;// Czy włączył biometrię w ustawieniach?
 bool get canUseBiometrics;// Czy urządzenie obsługuje biometrię?
 bool get isSetupCompleted;// Czy zakończył wizard powitalny?
 bool get initialized;
/// Create a copy of SecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SecurityStateCopyWith<SecurityState> get copyWith => _$SecurityStateCopyWithImpl<SecurityState>(this as SecurityState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SecurityState&&(identical(other.hasLocalLock, hasLocalLock) || other.hasLocalLock == hasLocalLock)&&(identical(other.isPinConfigured, isPinConfigured) || other.isPinConfigured == isPinConfigured)&&(identical(other.isBiometricEnabled, isBiometricEnabled) || other.isBiometricEnabled == isBiometricEnabled)&&(identical(other.canUseBiometrics, canUseBiometrics) || other.canUseBiometrics == canUseBiometrics)&&(identical(other.isSetupCompleted, isSetupCompleted) || other.isSetupCompleted == isSetupCompleted)&&(identical(other.initialized, initialized) || other.initialized == initialized));
}


@override
int get hashCode => Object.hash(runtimeType,hasLocalLock,isPinConfigured,isBiometricEnabled,canUseBiometrics,isSetupCompleted,initialized);

@override
String toString() {
  return 'SecurityState(hasLocalLock: $hasLocalLock, isPinConfigured: $isPinConfigured, isBiometricEnabled: $isBiometricEnabled, canUseBiometrics: $canUseBiometrics, isSetupCompleted: $isSetupCompleted, initialized: $initialized)';
}


}

/// @nodoc
abstract mixin class $SecurityStateCopyWith<$Res>  {
  factory $SecurityStateCopyWith(SecurityState value, $Res Function(SecurityState) _then) = _$SecurityStateCopyWithImpl;
@useResult
$Res call({
 bool hasLocalLock, bool isPinConfigured, bool isBiometricEnabled, bool canUseBiometrics, bool isSetupCompleted, bool initialized
});




}
/// @nodoc
class _$SecurityStateCopyWithImpl<$Res>
    implements $SecurityStateCopyWith<$Res> {
  _$SecurityStateCopyWithImpl(this._self, this._then);

  final SecurityState _self;
  final $Res Function(SecurityState) _then;

/// Create a copy of SecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasLocalLock = null,Object? isPinConfigured = null,Object? isBiometricEnabled = null,Object? canUseBiometrics = null,Object? isSetupCompleted = null,Object? initialized = null,}) {
  return _then(_self.copyWith(
hasLocalLock: null == hasLocalLock ? _self.hasLocalLock : hasLocalLock // ignore: cast_nullable_to_non_nullable
as bool,isPinConfigured: null == isPinConfigured ? _self.isPinConfigured : isPinConfigured // ignore: cast_nullable_to_non_nullable
as bool,isBiometricEnabled: null == isBiometricEnabled ? _self.isBiometricEnabled : isBiometricEnabled // ignore: cast_nullable_to_non_nullable
as bool,canUseBiometrics: null == canUseBiometrics ? _self.canUseBiometrics : canUseBiometrics // ignore: cast_nullable_to_non_nullable
as bool,isSetupCompleted: null == isSetupCompleted ? _self.isSetupCompleted : isSetupCompleted // ignore: cast_nullable_to_non_nullable
as bool,initialized: null == initialized ? _self.initialized : initialized // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SecurityState].
extension SecurityStatePatterns on SecurityState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SecurityState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SecurityState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SecurityState value)  $default,){
final _that = this;
switch (_that) {
case _SecurityState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SecurityState value)?  $default,){
final _that = this;
switch (_that) {
case _SecurityState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool hasLocalLock,  bool isPinConfigured,  bool isBiometricEnabled,  bool canUseBiometrics,  bool isSetupCompleted,  bool initialized)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SecurityState() when $default != null:
return $default(_that.hasLocalLock,_that.isPinConfigured,_that.isBiometricEnabled,_that.canUseBiometrics,_that.isSetupCompleted,_that.initialized);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool hasLocalLock,  bool isPinConfigured,  bool isBiometricEnabled,  bool canUseBiometrics,  bool isSetupCompleted,  bool initialized)  $default,) {final _that = this;
switch (_that) {
case _SecurityState():
return $default(_that.hasLocalLock,_that.isPinConfigured,_that.isBiometricEnabled,_that.canUseBiometrics,_that.isSetupCompleted,_that.initialized);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool hasLocalLock,  bool isPinConfigured,  bool isBiometricEnabled,  bool canUseBiometrics,  bool isSetupCompleted,  bool initialized)?  $default,) {final _that = this;
switch (_that) {
case _SecurityState() when $default != null:
return $default(_that.hasLocalLock,_that.isPinConfigured,_that.isBiometricEnabled,_that.canUseBiometrics,_that.isSetupCompleted,_that.initialized);case _:
  return null;

}
}

}

/// @nodoc


class _SecurityState extends SecurityState {
  const _SecurityState({required this.hasLocalLock, required this.isPinConfigured, required this.isBiometricEnabled, required this.canUseBiometrics, required this.isSetupCompleted, required this.initialized}): super._();
  

@override final  bool hasLocalLock;
// Czy ekran blokady jest aktywny?
@override final  bool isPinConfigured;
// Czy user ustawił PIN?
@override final  bool isBiometricEnabled;
// Czy włączył biometrię w ustawieniach?
@override final  bool canUseBiometrics;
// Czy urządzenie obsługuje biometrię?
@override final  bool isSetupCompleted;
// Czy zakończył wizard powitalny?
@override final  bool initialized;

/// Create a copy of SecurityState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SecurityStateCopyWith<_SecurityState> get copyWith => __$SecurityStateCopyWithImpl<_SecurityState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecurityState&&(identical(other.hasLocalLock, hasLocalLock) || other.hasLocalLock == hasLocalLock)&&(identical(other.isPinConfigured, isPinConfigured) || other.isPinConfigured == isPinConfigured)&&(identical(other.isBiometricEnabled, isBiometricEnabled) || other.isBiometricEnabled == isBiometricEnabled)&&(identical(other.canUseBiometrics, canUseBiometrics) || other.canUseBiometrics == canUseBiometrics)&&(identical(other.isSetupCompleted, isSetupCompleted) || other.isSetupCompleted == isSetupCompleted)&&(identical(other.initialized, initialized) || other.initialized == initialized));
}


@override
int get hashCode => Object.hash(runtimeType,hasLocalLock,isPinConfigured,isBiometricEnabled,canUseBiometrics,isSetupCompleted,initialized);

@override
String toString() {
  return 'SecurityState(hasLocalLock: $hasLocalLock, isPinConfigured: $isPinConfigured, isBiometricEnabled: $isBiometricEnabled, canUseBiometrics: $canUseBiometrics, isSetupCompleted: $isSetupCompleted, initialized: $initialized)';
}


}

/// @nodoc
abstract mixin class _$SecurityStateCopyWith<$Res> implements $SecurityStateCopyWith<$Res> {
  factory _$SecurityStateCopyWith(_SecurityState value, $Res Function(_SecurityState) _then) = __$SecurityStateCopyWithImpl;
@override @useResult
$Res call({
 bool hasLocalLock, bool isPinConfigured, bool isBiometricEnabled, bool canUseBiometrics, bool isSetupCompleted, bool initialized
});




}
/// @nodoc
class __$SecurityStateCopyWithImpl<$Res>
    implements _$SecurityStateCopyWith<$Res> {
  __$SecurityStateCopyWithImpl(this._self, this._then);

  final _SecurityState _self;
  final $Res Function(_SecurityState) _then;

/// Create a copy of SecurityState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasLocalLock = null,Object? isPinConfigured = null,Object? isBiometricEnabled = null,Object? canUseBiometrics = null,Object? isSetupCompleted = null,Object? initialized = null,}) {
  return _then(_SecurityState(
hasLocalLock: null == hasLocalLock ? _self.hasLocalLock : hasLocalLock // ignore: cast_nullable_to_non_nullable
as bool,isPinConfigured: null == isPinConfigured ? _self.isPinConfigured : isPinConfigured // ignore: cast_nullable_to_non_nullable
as bool,isBiometricEnabled: null == isBiometricEnabled ? _self.isBiometricEnabled : isBiometricEnabled // ignore: cast_nullable_to_non_nullable
as bool,canUseBiometrics: null == canUseBiometrics ? _self.canUseBiometrics : canUseBiometrics // ignore: cast_nullable_to_non_nullable
as bool,isSetupCompleted: null == isSetupCompleted ? _self.isSetupCompleted : isSetupCompleted // ignore: cast_nullable_to_non_nullable
as bool,initialized: null == initialized ? _self.initialized : initialized // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
