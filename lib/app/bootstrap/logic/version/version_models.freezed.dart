// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'version_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VersionState {

 String get minVersion; String get latestVersion; bool get forceUpdate;
/// Create a copy of VersionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VersionStateCopyWith<VersionState> get copyWith => _$VersionStateCopyWithImpl<VersionState>(this as VersionState, _$identity);

  /// Serializes this VersionState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VersionState&&(identical(other.minVersion, minVersion) || other.minVersion == minVersion)&&(identical(other.latestVersion, latestVersion) || other.latestVersion == latestVersion)&&(identical(other.forceUpdate, forceUpdate) || other.forceUpdate == forceUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,minVersion,latestVersion,forceUpdate);

@override
String toString() {
  return 'VersionState(minVersion: $minVersion, latestVersion: $latestVersion, forceUpdate: $forceUpdate)';
}


}

/// @nodoc
abstract mixin class $VersionStateCopyWith<$Res>  {
  factory $VersionStateCopyWith(VersionState value, $Res Function(VersionState) _then) = _$VersionStateCopyWithImpl;
@useResult
$Res call({
 String minVersion, String latestVersion, bool forceUpdate
});




}
/// @nodoc
class _$VersionStateCopyWithImpl<$Res>
    implements $VersionStateCopyWith<$Res> {
  _$VersionStateCopyWithImpl(this._self, this._then);

  final VersionState _self;
  final $Res Function(VersionState) _then;

/// Create a copy of VersionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minVersion = null,Object? latestVersion = null,Object? forceUpdate = null,}) {
  return _then(_self.copyWith(
minVersion: null == minVersion ? _self.minVersion : minVersion // ignore: cast_nullable_to_non_nullable
as String,latestVersion: null == latestVersion ? _self.latestVersion : latestVersion // ignore: cast_nullable_to_non_nullable
as String,forceUpdate: null == forceUpdate ? _self.forceUpdate : forceUpdate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VersionState].
extension VersionStatePatterns on VersionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VersionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VersionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VersionState value)  $default,){
final _that = this;
switch (_that) {
case _VersionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VersionState value)?  $default,){
final _that = this;
switch (_that) {
case _VersionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String minVersion,  String latestVersion,  bool forceUpdate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VersionState() when $default != null:
return $default(_that.minVersion,_that.latestVersion,_that.forceUpdate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String minVersion,  String latestVersion,  bool forceUpdate)  $default,) {final _that = this;
switch (_that) {
case _VersionState():
return $default(_that.minVersion,_that.latestVersion,_that.forceUpdate);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String minVersion,  String latestVersion,  bool forceUpdate)?  $default,) {final _that = this;
switch (_that) {
case _VersionState() when $default != null:
return $default(_that.minVersion,_that.latestVersion,_that.forceUpdate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VersionState implements VersionState {
  const _VersionState({this.minVersion = '0.0.0', this.latestVersion = '0.0.0', this.forceUpdate = false});
  factory _VersionState.fromJson(Map<String, dynamic> json) => _$VersionStateFromJson(json);

@override@JsonKey() final  String minVersion;
@override@JsonKey() final  String latestVersion;
@override@JsonKey() final  bool forceUpdate;

/// Create a copy of VersionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VersionStateCopyWith<_VersionState> get copyWith => __$VersionStateCopyWithImpl<_VersionState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VersionStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VersionState&&(identical(other.minVersion, minVersion) || other.minVersion == minVersion)&&(identical(other.latestVersion, latestVersion) || other.latestVersion == latestVersion)&&(identical(other.forceUpdate, forceUpdate) || other.forceUpdate == forceUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,minVersion,latestVersion,forceUpdate);

@override
String toString() {
  return 'VersionState(minVersion: $minVersion, latestVersion: $latestVersion, forceUpdate: $forceUpdate)';
}


}

/// @nodoc
abstract mixin class _$VersionStateCopyWith<$Res> implements $VersionStateCopyWith<$Res> {
  factory _$VersionStateCopyWith(_VersionState value, $Res Function(_VersionState) _then) = __$VersionStateCopyWithImpl;
@override @useResult
$Res call({
 String minVersion, String latestVersion, bool forceUpdate
});




}
/// @nodoc
class __$VersionStateCopyWithImpl<$Res>
    implements _$VersionStateCopyWith<$Res> {
  __$VersionStateCopyWithImpl(this._self, this._then);

  final _VersionState _self;
  final $Res Function(_VersionState) _then;

/// Create a copy of VersionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minVersion = null,Object? latestVersion = null,Object? forceUpdate = null,}) {
  return _then(_VersionState(
minVersion: null == minVersion ? _self.minVersion : minVersion // ignore: cast_nullable_to_non_nullable
as String,latestVersion: null == latestVersion ? _self.latestVersion : latestVersion // ignore: cast_nullable_to_non_nullable
as String,forceUpdate: null == forceUpdate ? _self.forceUpdate : forceUpdate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
