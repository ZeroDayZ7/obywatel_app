// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backend_sync.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BackendState {

 DateTime? get serverTime; Duration get timeOffset; int get rateLimitRemaining; String? get lastRequestId; bool get isMaintenanceMode; bool get isDeviceSecure; String? get deviceFingerprint;
/// Create a copy of BackendState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackendStateCopyWith<BackendState> get copyWith => _$BackendStateCopyWithImpl<BackendState>(this as BackendState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackendState&&(identical(other.serverTime, serverTime) || other.serverTime == serverTime)&&(identical(other.timeOffset, timeOffset) || other.timeOffset == timeOffset)&&(identical(other.rateLimitRemaining, rateLimitRemaining) || other.rateLimitRemaining == rateLimitRemaining)&&(identical(other.lastRequestId, lastRequestId) || other.lastRequestId == lastRequestId)&&(identical(other.isMaintenanceMode, isMaintenanceMode) || other.isMaintenanceMode == isMaintenanceMode)&&(identical(other.isDeviceSecure, isDeviceSecure) || other.isDeviceSecure == isDeviceSecure)&&(identical(other.deviceFingerprint, deviceFingerprint) || other.deviceFingerprint == deviceFingerprint));
}


@override
int get hashCode => Object.hash(runtimeType,serverTime,timeOffset,rateLimitRemaining,lastRequestId,isMaintenanceMode,isDeviceSecure,deviceFingerprint);

@override
String toString() {
  return 'BackendState(serverTime: $serverTime, timeOffset: $timeOffset, rateLimitRemaining: $rateLimitRemaining, lastRequestId: $lastRequestId, isMaintenanceMode: $isMaintenanceMode, isDeviceSecure: $isDeviceSecure, deviceFingerprint: $deviceFingerprint)';
}


}

/// @nodoc
abstract mixin class $BackendStateCopyWith<$Res>  {
  factory $BackendStateCopyWith(BackendState value, $Res Function(BackendState) _then) = _$BackendStateCopyWithImpl;
@useResult
$Res call({
 DateTime? serverTime, Duration timeOffset, int rateLimitRemaining, String? lastRequestId, bool isMaintenanceMode, bool isDeviceSecure, String? deviceFingerprint
});




}
/// @nodoc
class _$BackendStateCopyWithImpl<$Res>
    implements $BackendStateCopyWith<$Res> {
  _$BackendStateCopyWithImpl(this._self, this._then);

  final BackendState _self;
  final $Res Function(BackendState) _then;

/// Create a copy of BackendState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serverTime = freezed,Object? timeOffset = null,Object? rateLimitRemaining = null,Object? lastRequestId = freezed,Object? isMaintenanceMode = null,Object? isDeviceSecure = null,Object? deviceFingerprint = freezed,}) {
  return _then(_self.copyWith(
serverTime: freezed == serverTime ? _self.serverTime : serverTime // ignore: cast_nullable_to_non_nullable
as DateTime?,timeOffset: null == timeOffset ? _self.timeOffset : timeOffset // ignore: cast_nullable_to_non_nullable
as Duration,rateLimitRemaining: null == rateLimitRemaining ? _self.rateLimitRemaining : rateLimitRemaining // ignore: cast_nullable_to_non_nullable
as int,lastRequestId: freezed == lastRequestId ? _self.lastRequestId : lastRequestId // ignore: cast_nullable_to_non_nullable
as String?,isMaintenanceMode: null == isMaintenanceMode ? _self.isMaintenanceMode : isMaintenanceMode // ignore: cast_nullable_to_non_nullable
as bool,isDeviceSecure: null == isDeviceSecure ? _self.isDeviceSecure : isDeviceSecure // ignore: cast_nullable_to_non_nullable
as bool,deviceFingerprint: freezed == deviceFingerprint ? _self.deviceFingerprint : deviceFingerprint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BackendState].
extension BackendStatePatterns on BackendState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackendState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackendState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackendState value)  $default,){
final _that = this;
switch (_that) {
case _BackendState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackendState value)?  $default,){
final _that = this;
switch (_that) {
case _BackendState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? serverTime,  Duration timeOffset,  int rateLimitRemaining,  String? lastRequestId,  bool isMaintenanceMode,  bool isDeviceSecure,  String? deviceFingerprint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackendState() when $default != null:
return $default(_that.serverTime,_that.timeOffset,_that.rateLimitRemaining,_that.lastRequestId,_that.isMaintenanceMode,_that.isDeviceSecure,_that.deviceFingerprint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? serverTime,  Duration timeOffset,  int rateLimitRemaining,  String? lastRequestId,  bool isMaintenanceMode,  bool isDeviceSecure,  String? deviceFingerprint)  $default,) {final _that = this;
switch (_that) {
case _BackendState():
return $default(_that.serverTime,_that.timeOffset,_that.rateLimitRemaining,_that.lastRequestId,_that.isMaintenanceMode,_that.isDeviceSecure,_that.deviceFingerprint);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? serverTime,  Duration timeOffset,  int rateLimitRemaining,  String? lastRequestId,  bool isMaintenanceMode,  bool isDeviceSecure,  String? deviceFingerprint)?  $default,) {final _that = this;
switch (_that) {
case _BackendState() when $default != null:
return $default(_that.serverTime,_that.timeOffset,_that.rateLimitRemaining,_that.lastRequestId,_that.isMaintenanceMode,_that.isDeviceSecure,_that.deviceFingerprint);case _:
  return null;

}
}

}

/// @nodoc


class _BackendState extends BackendState {
  const _BackendState({this.serverTime, this.timeOffset = Duration.zero, this.rateLimitRemaining = 100, this.lastRequestId, this.isMaintenanceMode = false, this.isDeviceSecure = false, this.deviceFingerprint}): super._();
  

@override final  DateTime? serverTime;
@override@JsonKey() final  Duration timeOffset;
@override@JsonKey() final  int rateLimitRemaining;
@override final  String? lastRequestId;
@override@JsonKey() final  bool isMaintenanceMode;
@override@JsonKey() final  bool isDeviceSecure;
@override final  String? deviceFingerprint;

/// Create a copy of BackendState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackendStateCopyWith<_BackendState> get copyWith => __$BackendStateCopyWithImpl<_BackendState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackendState&&(identical(other.serverTime, serverTime) || other.serverTime == serverTime)&&(identical(other.timeOffset, timeOffset) || other.timeOffset == timeOffset)&&(identical(other.rateLimitRemaining, rateLimitRemaining) || other.rateLimitRemaining == rateLimitRemaining)&&(identical(other.lastRequestId, lastRequestId) || other.lastRequestId == lastRequestId)&&(identical(other.isMaintenanceMode, isMaintenanceMode) || other.isMaintenanceMode == isMaintenanceMode)&&(identical(other.isDeviceSecure, isDeviceSecure) || other.isDeviceSecure == isDeviceSecure)&&(identical(other.deviceFingerprint, deviceFingerprint) || other.deviceFingerprint == deviceFingerprint));
}


@override
int get hashCode => Object.hash(runtimeType,serverTime,timeOffset,rateLimitRemaining,lastRequestId,isMaintenanceMode,isDeviceSecure,deviceFingerprint);

@override
String toString() {
  return 'BackendState(serverTime: $serverTime, timeOffset: $timeOffset, rateLimitRemaining: $rateLimitRemaining, lastRequestId: $lastRequestId, isMaintenanceMode: $isMaintenanceMode, isDeviceSecure: $isDeviceSecure, deviceFingerprint: $deviceFingerprint)';
}


}

/// @nodoc
abstract mixin class _$BackendStateCopyWith<$Res> implements $BackendStateCopyWith<$Res> {
  factory _$BackendStateCopyWith(_BackendState value, $Res Function(_BackendState) _then) = __$BackendStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime? serverTime, Duration timeOffset, int rateLimitRemaining, String? lastRequestId, bool isMaintenanceMode, bool isDeviceSecure, String? deviceFingerprint
});




}
/// @nodoc
class __$BackendStateCopyWithImpl<$Res>
    implements _$BackendStateCopyWith<$Res> {
  __$BackendStateCopyWithImpl(this._self, this._then);

  final _BackendState _self;
  final $Res Function(_BackendState) _then;

/// Create a copy of BackendState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serverTime = freezed,Object? timeOffset = null,Object? rateLimitRemaining = null,Object? lastRequestId = freezed,Object? isMaintenanceMode = null,Object? isDeviceSecure = null,Object? deviceFingerprint = freezed,}) {
  return _then(_BackendState(
serverTime: freezed == serverTime ? _self.serverTime : serverTime // ignore: cast_nullable_to_non_nullable
as DateTime?,timeOffset: null == timeOffset ? _self.timeOffset : timeOffset // ignore: cast_nullable_to_non_nullable
as Duration,rateLimitRemaining: null == rateLimitRemaining ? _self.rateLimitRemaining : rateLimitRemaining // ignore: cast_nullable_to_non_nullable
as int,lastRequestId: freezed == lastRequestId ? _self.lastRequestId : lastRequestId // ignore: cast_nullable_to_non_nullable
as String?,isMaintenanceMode: null == isMaintenanceMode ? _self.isMaintenanceMode : isMaintenanceMode // ignore: cast_nullable_to_non_nullable
as bool,isDeviceSecure: null == isDeviceSecure ? _self.isDeviceSecure : isDeviceSecure // ignore: cast_nullable_to_non_nullable
as bool,deviceFingerprint: freezed == deviceFingerprint ? _self.deviceFingerprint : deviceFingerprint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
