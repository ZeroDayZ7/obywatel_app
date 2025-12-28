// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthResponse {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthResponse);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthResponse()';
}


}

/// @nodoc
class $AuthResponseCopyWith<$Res>  {
$AuthResponseCopyWith(AuthResponse _, $Res Function(AuthResponse) __);
}


/// Adds pattern-matching-related methods to [AuthResponse].
extension AuthResponsePatterns on AuthResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _TwoFaRequired value)?  twoFaRequired,TResult Function( _Success value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TwoFaRequired() when twoFaRequired != null:
return twoFaRequired(_that);case _Success() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _TwoFaRequired value)  twoFaRequired,required TResult Function( _Success value)  success,}){
final _that = this;
switch (_that) {
case _TwoFaRequired():
return twoFaRequired(_that);case _Success():
return success(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _TwoFaRequired value)?  twoFaRequired,TResult? Function( _Success value)?  success,}){
final _that = this;
switch (_that) {
case _TwoFaRequired() when twoFaRequired != null:
return twoFaRequired(_that);case _Success() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String twoFaToken)?  twoFaRequired,TResult Function( String accessToken,  String refreshToken,  String userId)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TwoFaRequired() when twoFaRequired != null:
return twoFaRequired(_that.twoFaToken);case _Success() when success != null:
return success(_that.accessToken,_that.refreshToken,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String twoFaToken)  twoFaRequired,required TResult Function( String accessToken,  String refreshToken,  String userId)  success,}) {final _that = this;
switch (_that) {
case _TwoFaRequired():
return twoFaRequired(_that.twoFaToken);case _Success():
return success(_that.accessToken,_that.refreshToken,_that.userId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String twoFaToken)?  twoFaRequired,TResult? Function( String accessToken,  String refreshToken,  String userId)?  success,}) {final _that = this;
switch (_that) {
case _TwoFaRequired() when twoFaRequired != null:
return twoFaRequired(_that.twoFaToken);case _Success() when success != null:
return success(_that.accessToken,_that.refreshToken,_that.userId);case _:
  return null;

}
}

}

/// @nodoc


class _TwoFaRequired implements AuthResponse {
  const _TwoFaRequired({required this.twoFaToken});
  

 final  String twoFaToken;

/// Create a copy of AuthResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TwoFaRequiredCopyWith<_TwoFaRequired> get copyWith => __$TwoFaRequiredCopyWithImpl<_TwoFaRequired>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TwoFaRequired&&(identical(other.twoFaToken, twoFaToken) || other.twoFaToken == twoFaToken));
}


@override
int get hashCode => Object.hash(runtimeType,twoFaToken);

@override
String toString() {
  return 'AuthResponse.twoFaRequired(twoFaToken: $twoFaToken)';
}


}

/// @nodoc
abstract mixin class _$TwoFaRequiredCopyWith<$Res> implements $AuthResponseCopyWith<$Res> {
  factory _$TwoFaRequiredCopyWith(_TwoFaRequired value, $Res Function(_TwoFaRequired) _then) = __$TwoFaRequiredCopyWithImpl;
@useResult
$Res call({
 String twoFaToken
});




}
/// @nodoc
class __$TwoFaRequiredCopyWithImpl<$Res>
    implements _$TwoFaRequiredCopyWith<$Res> {
  __$TwoFaRequiredCopyWithImpl(this._self, this._then);

  final _TwoFaRequired _self;
  final $Res Function(_TwoFaRequired) _then;

/// Create a copy of AuthResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? twoFaToken = null,}) {
  return _then(_TwoFaRequired(
twoFaToken: null == twoFaToken ? _self.twoFaToken : twoFaToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Success implements AuthResponse {
  const _Success({required this.accessToken, required this.refreshToken, required this.userId});
  

 final  String accessToken;
 final  String refreshToken;
 final  String userId;

/// Create a copy of AuthResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,userId);

@override
String toString() {
  return 'AuthResponse.success(accessToken: $accessToken, refreshToken: $refreshToken, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $AuthResponseCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken, String userId
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of AuthResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? userId = null,}) {
  return _then(_Success(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
