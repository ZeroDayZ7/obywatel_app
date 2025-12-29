// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_attempt_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PinAttemptState {

 int get attempts; DateTime? get lockUntil;
/// Create a copy of PinAttemptState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinAttemptStateCopyWith<PinAttemptState> get copyWith => _$PinAttemptStateCopyWithImpl<PinAttemptState>(this as PinAttemptState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinAttemptState&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.lockUntil, lockUntil) || other.lockUntil == lockUntil));
}


@override
int get hashCode => Object.hash(runtimeType,attempts,lockUntil);

@override
String toString() {
  return 'PinAttemptState(attempts: $attempts, lockUntil: $lockUntil)';
}


}

/// @nodoc
abstract mixin class $PinAttemptStateCopyWith<$Res>  {
  factory $PinAttemptStateCopyWith(PinAttemptState value, $Res Function(PinAttemptState) _then) = _$PinAttemptStateCopyWithImpl;
@useResult
$Res call({
 int attempts, DateTime? lockUntil
});




}
/// @nodoc
class _$PinAttemptStateCopyWithImpl<$Res>
    implements $PinAttemptStateCopyWith<$Res> {
  _$PinAttemptStateCopyWithImpl(this._self, this._then);

  final PinAttemptState _self;
  final $Res Function(PinAttemptState) _then;

/// Create a copy of PinAttemptState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attempts = null,Object? lockUntil = freezed,}) {
  return _then(_self.copyWith(
attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,lockUntil: freezed == lockUntil ? _self.lockUntil : lockUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PinAttemptState].
extension PinAttemptStatePatterns on PinAttemptState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PinAttemptState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PinAttemptState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PinAttemptState value)  $default,){
final _that = this;
switch (_that) {
case _PinAttemptState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PinAttemptState value)?  $default,){
final _that = this;
switch (_that) {
case _PinAttemptState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int attempts,  DateTime? lockUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PinAttemptState() when $default != null:
return $default(_that.attempts,_that.lockUntil);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int attempts,  DateTime? lockUntil)  $default,) {final _that = this;
switch (_that) {
case _PinAttemptState():
return $default(_that.attempts,_that.lockUntil);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int attempts,  DateTime? lockUntil)?  $default,) {final _that = this;
switch (_that) {
case _PinAttemptState() when $default != null:
return $default(_that.attempts,_that.lockUntil);case _:
  return null;

}
}

}

/// @nodoc


class _PinAttemptState extends PinAttemptState {
  const _PinAttemptState({this.attempts = 0, this.lockUntil}): super._();
  

@override@JsonKey() final  int attempts;
@override final  DateTime? lockUntil;

/// Create a copy of PinAttemptState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PinAttemptStateCopyWith<_PinAttemptState> get copyWith => __$PinAttemptStateCopyWithImpl<_PinAttemptState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PinAttemptState&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.lockUntil, lockUntil) || other.lockUntil == lockUntil));
}


@override
int get hashCode => Object.hash(runtimeType,attempts,lockUntil);

@override
String toString() {
  return 'PinAttemptState(attempts: $attempts, lockUntil: $lockUntil)';
}


}

/// @nodoc
abstract mixin class _$PinAttemptStateCopyWith<$Res> implements $PinAttemptStateCopyWith<$Res> {
  factory _$PinAttemptStateCopyWith(_PinAttemptState value, $Res Function(_PinAttemptState) _then) = __$PinAttemptStateCopyWithImpl;
@override @useResult
$Res call({
 int attempts, DateTime? lockUntil
});




}
/// @nodoc
class __$PinAttemptStateCopyWithImpl<$Res>
    implements _$PinAttemptStateCopyWith<$Res> {
  __$PinAttemptStateCopyWithImpl(this._self, this._then);

  final _PinAttemptState _self;
  final $Res Function(_PinAttemptState) _then;

/// Create a copy of PinAttemptState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attempts = null,Object? lockUntil = freezed,}) {
  return _then(_PinAttemptState(
attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,lockUntil: freezed == lockUntil ? _self.lockUntil : lockUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
