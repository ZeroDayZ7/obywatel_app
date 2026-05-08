// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_init_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppInitStatus {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppInitStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppInitStatus()';
}


}

/// @nodoc
class $AppInitStatusCopyWith<$Res>  {
$AppInitStatusCopyWith(AppInitStatus _, $Res Function(AppInitStatus) __);
}


/// Adds pattern-matching-related methods to [AppInitStatus].
extension AppInitStatusPatterns on AppInitStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Loading value)?  loading,TResult Function( _Unauthenticated value)?  unauthenticated,TResult Function( _LockedPin value)?  lockedPin,TResult Function( _Authorized value)?  authorized,TResult Function( _ForceUpdate value)?  forceUpdate,TResult Function( _Maintenance value)?  maintenance,TResult Function( _Blocked value)?  blocked,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _LockedPin() when lockedPin != null:
return lockedPin(_that);case _Authorized() when authorized != null:
return authorized(_that);case _ForceUpdate() when forceUpdate != null:
return forceUpdate(_that);case _Maintenance() when maintenance != null:
return maintenance(_that);case _Blocked() when blocked != null:
return blocked(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Loading value)  loading,required TResult Function( _Unauthenticated value)  unauthenticated,required TResult Function( _LockedPin value)  lockedPin,required TResult Function( _Authorized value)  authorized,required TResult Function( _ForceUpdate value)  forceUpdate,required TResult Function( _Maintenance value)  maintenance,required TResult Function( _Blocked value)  blocked,}){
final _that = this;
switch (_that) {
case _Loading():
return loading(_that);case _Unauthenticated():
return unauthenticated(_that);case _LockedPin():
return lockedPin(_that);case _Authorized():
return authorized(_that);case _ForceUpdate():
return forceUpdate(_that);case _Maintenance():
return maintenance(_that);case _Blocked():
return blocked(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Loading value)?  loading,TResult? Function( _Unauthenticated value)?  unauthenticated,TResult? Function( _LockedPin value)?  lockedPin,TResult? Function( _Authorized value)?  authorized,TResult? Function( _ForceUpdate value)?  forceUpdate,TResult? Function( _Maintenance value)?  maintenance,TResult? Function( _Blocked value)?  blocked,}){
final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _LockedPin() when lockedPin != null:
return lockedPin(_that);case _Authorized() when authorized != null:
return authorized(_that);case _ForceUpdate() when forceUpdate != null:
return forceUpdate(_that);case _Maintenance() when maintenance != null:
return maintenance(_that);case _Blocked() when blocked != null:
return blocked(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function()?  unauthenticated,TResult Function()?  lockedPin,TResult Function()?  authorized,TResult Function()?  forceUpdate,TResult Function( String? message,  DateTime? estimatedEndTime)?  maintenance,TResult Function( String? reason)?  blocked,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading();case _Unauthenticated() when unauthenticated != null:
return unauthenticated();case _LockedPin() when lockedPin != null:
return lockedPin();case _Authorized() when authorized != null:
return authorized();case _ForceUpdate() when forceUpdate != null:
return forceUpdate();case _Maintenance() when maintenance != null:
return maintenance(_that.message,_that.estimatedEndTime);case _Blocked() when blocked != null:
return blocked(_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function()  unauthenticated,required TResult Function()  lockedPin,required TResult Function()  authorized,required TResult Function()  forceUpdate,required TResult Function( String? message,  DateTime? estimatedEndTime)  maintenance,required TResult Function( String? reason)  blocked,}) {final _that = this;
switch (_that) {
case _Loading():
return loading();case _Unauthenticated():
return unauthenticated();case _LockedPin():
return lockedPin();case _Authorized():
return authorized();case _ForceUpdate():
return forceUpdate();case _Maintenance():
return maintenance(_that.message,_that.estimatedEndTime);case _Blocked():
return blocked(_that.reason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function()?  unauthenticated,TResult? Function()?  lockedPin,TResult? Function()?  authorized,TResult? Function()?  forceUpdate,TResult? Function( String? message,  DateTime? estimatedEndTime)?  maintenance,TResult? Function( String? reason)?  blocked,}) {final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading();case _Unauthenticated() when unauthenticated != null:
return unauthenticated();case _LockedPin() when lockedPin != null:
return lockedPin();case _Authorized() when authorized != null:
return authorized();case _ForceUpdate() when forceUpdate != null:
return forceUpdate();case _Maintenance() when maintenance != null:
return maintenance(_that.message,_that.estimatedEndTime);case _Blocked() when blocked != null:
return blocked(_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _Loading implements AppInitStatus {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppInitStatus.loading()';
}


}




/// @nodoc


class _Unauthenticated implements AppInitStatus {
  const _Unauthenticated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unauthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppInitStatus.unauthenticated()';
}


}




/// @nodoc


class _LockedPin implements AppInitStatus {
  const _LockedPin();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LockedPin);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppInitStatus.lockedPin()';
}


}




/// @nodoc


class _Authorized implements AppInitStatus {
  const _Authorized();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Authorized);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppInitStatus.authorized()';
}


}




/// @nodoc


class _ForceUpdate implements AppInitStatus {
  const _ForceUpdate();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForceUpdate);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppInitStatus.forceUpdate()';
}


}




/// @nodoc


class _Maintenance implements AppInitStatus {
  const _Maintenance({this.message, this.estimatedEndTime});
  

 final  String? message;
 final  DateTime? estimatedEndTime;

/// Create a copy of AppInitStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaintenanceCopyWith<_Maintenance> get copyWith => __$MaintenanceCopyWithImpl<_Maintenance>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Maintenance&&(identical(other.message, message) || other.message == message)&&(identical(other.estimatedEndTime, estimatedEndTime) || other.estimatedEndTime == estimatedEndTime));
}


@override
int get hashCode => Object.hash(runtimeType,message,estimatedEndTime);

@override
String toString() {
  return 'AppInitStatus.maintenance(message: $message, estimatedEndTime: $estimatedEndTime)';
}


}

/// @nodoc
abstract mixin class _$MaintenanceCopyWith<$Res> implements $AppInitStatusCopyWith<$Res> {
  factory _$MaintenanceCopyWith(_Maintenance value, $Res Function(_Maintenance) _then) = __$MaintenanceCopyWithImpl;
@useResult
$Res call({
 String? message, DateTime? estimatedEndTime
});




}
/// @nodoc
class __$MaintenanceCopyWithImpl<$Res>
    implements _$MaintenanceCopyWith<$Res> {
  __$MaintenanceCopyWithImpl(this._self, this._then);

  final _Maintenance _self;
  final $Res Function(_Maintenance) _then;

/// Create a copy of AppInitStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? estimatedEndTime = freezed,}) {
  return _then(_Maintenance(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,estimatedEndTime: freezed == estimatedEndTime ? _self.estimatedEndTime : estimatedEndTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc


class _Blocked implements AppInitStatus {
  const _Blocked({this.reason});
  

 final  String? reason;

/// Create a copy of AppInitStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockedCopyWith<_Blocked> get copyWith => __$BlockedCopyWithImpl<_Blocked>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Blocked&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'AppInitStatus.blocked(reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$BlockedCopyWith<$Res> implements $AppInitStatusCopyWith<$Res> {
  factory _$BlockedCopyWith(_Blocked value, $Res Function(_Blocked) _then) = __$BlockedCopyWithImpl;
@useResult
$Res call({
 String? reason
});




}
/// @nodoc
class __$BlockedCopyWithImpl<$Res>
    implements _$BlockedCopyWith<$Res> {
  __$BlockedCopyWithImpl(this._self, this._then);

  final _Blocked _self;
  final $Res Function(_Blocked) _then;

/// Create a copy of AppInitStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = freezed,}) {
  return _then(_Blocked(
reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
