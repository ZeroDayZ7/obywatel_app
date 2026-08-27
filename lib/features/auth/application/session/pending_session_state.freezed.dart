// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PendingSession {

 String get setupToken;
/// Create a copy of PendingSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingSessionCopyWith<PendingSession> get copyWith => _$PendingSessionCopyWithImpl<PendingSession>(this as PendingSession, _$identity);

  /// Serializes this PendingSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingSession&&(identical(other.setupToken, setupToken) || other.setupToken == setupToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,setupToken);

@override
String toString() {
  return 'PendingSession(setupToken: $setupToken)';
}


}

/// @nodoc
abstract mixin class $PendingSessionCopyWith<$Res>  {
  factory $PendingSessionCopyWith(PendingSession value, $Res Function(PendingSession) _then) = _$PendingSessionCopyWithImpl;
@useResult
$Res call({
 String setupToken
});




}
/// @nodoc
class _$PendingSessionCopyWithImpl<$Res>
    implements $PendingSessionCopyWith<$Res> {
  _$PendingSessionCopyWithImpl(this._self, this._then);

  final PendingSession _self;
  final $Res Function(PendingSession) _then;

/// Create a copy of PendingSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? setupToken = null,}) {
  return _then(_self.copyWith(
setupToken: null == setupToken ? _self.setupToken : setupToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingSession].
extension PendingSessionPatterns on PendingSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingSession value)  $default,){
final _that = this;
switch (_that) {
case _PendingSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingSession value)?  $default,){
final _that = this;
switch (_that) {
case _PendingSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String setupToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingSession() when $default != null:
return $default(_that.setupToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String setupToken)  $default,) {final _that = this;
switch (_that) {
case _PendingSession():
return $default(_that.setupToken);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String setupToken)?  $default,) {final _that = this;
switch (_that) {
case _PendingSession() when $default != null:
return $default(_that.setupToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PendingSession implements PendingSession {
  const _PendingSession({required this.setupToken});
  factory _PendingSession.fromJson(Map<String, dynamic> json) => _$PendingSessionFromJson(json);

@override final  String setupToken;

/// Create a copy of PendingSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingSessionCopyWith<_PendingSession> get copyWith => __$PendingSessionCopyWithImpl<_PendingSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PendingSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingSession&&(identical(other.setupToken, setupToken) || other.setupToken == setupToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,setupToken);

@override
String toString() {
  return 'PendingSession(setupToken: $setupToken)';
}


}

/// @nodoc
abstract mixin class _$PendingSessionCopyWith<$Res> implements $PendingSessionCopyWith<$Res> {
  factory _$PendingSessionCopyWith(_PendingSession value, $Res Function(_PendingSession) _then) = __$PendingSessionCopyWithImpl;
@override @useResult
$Res call({
 String setupToken
});




}
/// @nodoc
class __$PendingSessionCopyWithImpl<$Res>
    implements _$PendingSessionCopyWith<$Res> {
  __$PendingSessionCopyWithImpl(this._self, this._then);

  final _PendingSession _self;
  final $Res Function(_PendingSession) _then;

/// Create a copy of PendingSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? setupToken = null,}) {
  return _then(_PendingSession(
setupToken: null == setupToken ? _self.setupToken : setupToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
