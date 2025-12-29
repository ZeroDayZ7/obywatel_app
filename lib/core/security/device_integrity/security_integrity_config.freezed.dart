// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'security_integrity_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SecurityIntegrityConfig {

 bool get blockRooted; bool get blockEmulator; bool get blockDeveloperMode; bool get blockDangerousApps;
/// Create a copy of SecurityIntegrityConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SecurityIntegrityConfigCopyWith<SecurityIntegrityConfig> get copyWith => _$SecurityIntegrityConfigCopyWithImpl<SecurityIntegrityConfig>(this as SecurityIntegrityConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SecurityIntegrityConfig&&(identical(other.blockRooted, blockRooted) || other.blockRooted == blockRooted)&&(identical(other.blockEmulator, blockEmulator) || other.blockEmulator == blockEmulator)&&(identical(other.blockDeveloperMode, blockDeveloperMode) || other.blockDeveloperMode == blockDeveloperMode)&&(identical(other.blockDangerousApps, blockDangerousApps) || other.blockDangerousApps == blockDangerousApps));
}


@override
int get hashCode => Object.hash(runtimeType,blockRooted,blockEmulator,blockDeveloperMode,blockDangerousApps);

@override
String toString() {
  return 'SecurityIntegrityConfig(blockRooted: $blockRooted, blockEmulator: $blockEmulator, blockDeveloperMode: $blockDeveloperMode, blockDangerousApps: $blockDangerousApps)';
}


}

/// @nodoc
abstract mixin class $SecurityIntegrityConfigCopyWith<$Res>  {
  factory $SecurityIntegrityConfigCopyWith(SecurityIntegrityConfig value, $Res Function(SecurityIntegrityConfig) _then) = _$SecurityIntegrityConfigCopyWithImpl;
@useResult
$Res call({
 bool blockRooted, bool blockEmulator, bool blockDeveloperMode, bool blockDangerousApps
});




}
/// @nodoc
class _$SecurityIntegrityConfigCopyWithImpl<$Res>
    implements $SecurityIntegrityConfigCopyWith<$Res> {
  _$SecurityIntegrityConfigCopyWithImpl(this._self, this._then);

  final SecurityIntegrityConfig _self;
  final $Res Function(SecurityIntegrityConfig) _then;

/// Create a copy of SecurityIntegrityConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? blockRooted = null,Object? blockEmulator = null,Object? blockDeveloperMode = null,Object? blockDangerousApps = null,}) {
  return _then(_self.copyWith(
blockRooted: null == blockRooted ? _self.blockRooted : blockRooted // ignore: cast_nullable_to_non_nullable
as bool,blockEmulator: null == blockEmulator ? _self.blockEmulator : blockEmulator // ignore: cast_nullable_to_non_nullable
as bool,blockDeveloperMode: null == blockDeveloperMode ? _self.blockDeveloperMode : blockDeveloperMode // ignore: cast_nullable_to_non_nullable
as bool,blockDangerousApps: null == blockDangerousApps ? _self.blockDangerousApps : blockDangerousApps // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SecurityIntegrityConfig].
extension SecurityIntegrityConfigPatterns on SecurityIntegrityConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SecurityIntegrityConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SecurityIntegrityConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SecurityIntegrityConfig value)  $default,){
final _that = this;
switch (_that) {
case _SecurityIntegrityConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SecurityIntegrityConfig value)?  $default,){
final _that = this;
switch (_that) {
case _SecurityIntegrityConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool blockRooted,  bool blockEmulator,  bool blockDeveloperMode,  bool blockDangerousApps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SecurityIntegrityConfig() when $default != null:
return $default(_that.blockRooted,_that.blockEmulator,_that.blockDeveloperMode,_that.blockDangerousApps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool blockRooted,  bool blockEmulator,  bool blockDeveloperMode,  bool blockDangerousApps)  $default,) {final _that = this;
switch (_that) {
case _SecurityIntegrityConfig():
return $default(_that.blockRooted,_that.blockEmulator,_that.blockDeveloperMode,_that.blockDangerousApps);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool blockRooted,  bool blockEmulator,  bool blockDeveloperMode,  bool blockDangerousApps)?  $default,) {final _that = this;
switch (_that) {
case _SecurityIntegrityConfig() when $default != null:
return $default(_that.blockRooted,_that.blockEmulator,_that.blockDeveloperMode,_that.blockDangerousApps);case _:
  return null;

}
}

}

/// @nodoc


class _SecurityIntegrityConfig extends SecurityIntegrityConfig {
  const _SecurityIntegrityConfig({this.blockRooted = true, this.blockEmulator = true, this.blockDeveloperMode = false, this.blockDangerousApps = true}): super._();
  

@override@JsonKey() final  bool blockRooted;
@override@JsonKey() final  bool blockEmulator;
@override@JsonKey() final  bool blockDeveloperMode;
@override@JsonKey() final  bool blockDangerousApps;

/// Create a copy of SecurityIntegrityConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SecurityIntegrityConfigCopyWith<_SecurityIntegrityConfig> get copyWith => __$SecurityIntegrityConfigCopyWithImpl<_SecurityIntegrityConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecurityIntegrityConfig&&(identical(other.blockRooted, blockRooted) || other.blockRooted == blockRooted)&&(identical(other.blockEmulator, blockEmulator) || other.blockEmulator == blockEmulator)&&(identical(other.blockDeveloperMode, blockDeveloperMode) || other.blockDeveloperMode == blockDeveloperMode)&&(identical(other.blockDangerousApps, blockDangerousApps) || other.blockDangerousApps == blockDangerousApps));
}


@override
int get hashCode => Object.hash(runtimeType,blockRooted,blockEmulator,blockDeveloperMode,blockDangerousApps);

@override
String toString() {
  return 'SecurityIntegrityConfig(blockRooted: $blockRooted, blockEmulator: $blockEmulator, blockDeveloperMode: $blockDeveloperMode, blockDangerousApps: $blockDangerousApps)';
}


}

/// @nodoc
abstract mixin class _$SecurityIntegrityConfigCopyWith<$Res> implements $SecurityIntegrityConfigCopyWith<$Res> {
  factory _$SecurityIntegrityConfigCopyWith(_SecurityIntegrityConfig value, $Res Function(_SecurityIntegrityConfig) _then) = __$SecurityIntegrityConfigCopyWithImpl;
@override @useResult
$Res call({
 bool blockRooted, bool blockEmulator, bool blockDeveloperMode, bool blockDangerousApps
});




}
/// @nodoc
class __$SecurityIntegrityConfigCopyWithImpl<$Res>
    implements _$SecurityIntegrityConfigCopyWith<$Res> {
  __$SecurityIntegrityConfigCopyWithImpl(this._self, this._then);

  final _SecurityIntegrityConfig _self;
  final $Res Function(_SecurityIntegrityConfig) _then;

/// Create a copy of SecurityIntegrityConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? blockRooted = null,Object? blockEmulator = null,Object? blockDeveloperMode = null,Object? blockDangerousApps = null,}) {
  return _then(_SecurityIntegrityConfig(
blockRooted: null == blockRooted ? _self.blockRooted : blockRooted // ignore: cast_nullable_to_non_nullable
as bool,blockEmulator: null == blockEmulator ? _self.blockEmulator : blockEmulator // ignore: cast_nullable_to_non_nullable
as bool,blockDeveloperMode: null == blockDeveloperMode ? _self.blockDeveloperMode : blockDeveloperMode // ignore: cast_nullable_to_non_nullable
as bool,blockDangerousApps: null == blockDangerousApps ? _self.blockDangerousApps : blockDangerousApps // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
