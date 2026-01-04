// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Unauthenticated value)?  unauthenticated,TResult Function( _Authenticating value)?  authenticating,TResult Function( _TwoFaRequired value)?  twoFaRequired,TResult Function( _Authenticated value)?  authenticated,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _Authenticating() when authenticating != null:
return authenticating(_that);case _TwoFaRequired() when twoFaRequired != null:
return twoFaRequired(_that);case _Authenticated() when authenticated != null:
return authenticated(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Unauthenticated value)  unauthenticated,required TResult Function( _Authenticating value)  authenticating,required TResult Function( _TwoFaRequired value)  twoFaRequired,required TResult Function( _Authenticated value)  authenticated,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Unauthenticated():
return unauthenticated(_that);case _Authenticating():
return authenticating(_that);case _TwoFaRequired():
return twoFaRequired(_that);case _Authenticated():
return authenticated(_that);case _Error():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Unauthenticated value)?  unauthenticated,TResult? Function( _Authenticating value)?  authenticating,TResult? Function( _TwoFaRequired value)?  twoFaRequired,TResult? Function( _Authenticated value)?  authenticated,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _Authenticating() when authenticating != null:
return authenticating(_that);case _TwoFaRequired() when twoFaRequired != null:
return twoFaRequired(_that);case _Authenticated() when authenticated != null:
return authenticated(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  unauthenticated,TResult Function()?  authenticating,TResult Function( String email,  String tempToken)?  twoFaRequired,TResult Function( String userId,  String? accessToken,  String? refreshToken,  String? challenge,  bool isDeviceTrusted)?  authenticated,TResult Function( String code)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Unauthenticated() when unauthenticated != null:
return unauthenticated();case _Authenticating() when authenticating != null:
return authenticating();case _TwoFaRequired() when twoFaRequired != null:
return twoFaRequired(_that.email,_that.tempToken);case _Authenticated() when authenticated != null:
return authenticated(_that.userId,_that.accessToken,_that.refreshToken,_that.challenge,_that.isDeviceTrusted);case _Error() when error != null:
return error(_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  unauthenticated,required TResult Function()  authenticating,required TResult Function( String email,  String tempToken)  twoFaRequired,required TResult Function( String userId,  String? accessToken,  String? refreshToken,  String? challenge,  bool isDeviceTrusted)  authenticated,required TResult Function( String code)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Unauthenticated():
return unauthenticated();case _Authenticating():
return authenticating();case _TwoFaRequired():
return twoFaRequired(_that.email,_that.tempToken);case _Authenticated():
return authenticated(_that.userId,_that.accessToken,_that.refreshToken,_that.challenge,_that.isDeviceTrusted);case _Error():
return error(_that.code);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  unauthenticated,TResult? Function()?  authenticating,TResult? Function( String email,  String tempToken)?  twoFaRequired,TResult? Function( String userId,  String? accessToken,  String? refreshToken,  String? challenge,  bool isDeviceTrusted)?  authenticated,TResult? Function( String code)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Unauthenticated() when unauthenticated != null:
return unauthenticated();case _Authenticating() when authenticating != null:
return authenticating();case _TwoFaRequired() when twoFaRequired != null:
return twoFaRequired(_that.email,_that.tempToken);case _Authenticated() when authenticated != null:
return authenticated(_that.userId,_that.accessToken,_that.refreshToken,_that.challenge,_that.isDeviceTrusted);case _Error() when error != null:
return error(_that.code);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements AuthState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.initial()';
}


}




/// @nodoc


class _Unauthenticated implements AuthState {
  const _Unauthenticated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unauthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.unauthenticated()';
}


}




/// @nodoc


class _Authenticating implements AuthState {
  const _Authenticating();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Authenticating);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.authenticating()';
}


}




/// @nodoc


class _TwoFaRequired implements AuthState {
  const _TwoFaRequired({required this.email, required this.tempToken});
  

 final  String email;
 final  String tempToken;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TwoFaRequiredCopyWith<_TwoFaRequired> get copyWith => __$TwoFaRequiredCopyWithImpl<_TwoFaRequired>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TwoFaRequired&&(identical(other.email, email) || other.email == email)&&(identical(other.tempToken, tempToken) || other.tempToken == tempToken));
}


@override
int get hashCode => Object.hash(runtimeType,email,tempToken);

@override
String toString() {
  return 'AuthState.twoFaRequired(email: $email, tempToken: $tempToken)';
}


}

/// @nodoc
abstract mixin class _$TwoFaRequiredCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$TwoFaRequiredCopyWith(_TwoFaRequired value, $Res Function(_TwoFaRequired) _then) = __$TwoFaRequiredCopyWithImpl;
@useResult
$Res call({
 String email, String tempToken
});




}
/// @nodoc
class __$TwoFaRequiredCopyWithImpl<$Res>
    implements _$TwoFaRequiredCopyWith<$Res> {
  __$TwoFaRequiredCopyWithImpl(this._self, this._then);

  final _TwoFaRequired _self;
  final $Res Function(_TwoFaRequired) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? tempToken = null,}) {
  return _then(_TwoFaRequired(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,tempToken: null == tempToken ? _self.tempToken : tempToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Authenticated implements AuthState {
  const _Authenticated({required this.userId, this.accessToken, this.refreshToken, this.challenge, this.isDeviceTrusted = false});
  

 final  String userId;
 final  String? accessToken;
 final  String? refreshToken;
 final  String? challenge;
@JsonKey() final  bool isDeviceTrusted;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticatedCopyWith<_Authenticated> get copyWith => __$AuthenticatedCopyWithImpl<_Authenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Authenticated&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.challenge, challenge) || other.challenge == challenge)&&(identical(other.isDeviceTrusted, isDeviceTrusted) || other.isDeviceTrusted == isDeviceTrusted));
}


@override
int get hashCode => Object.hash(runtimeType,userId,accessToken,refreshToken,challenge,isDeviceTrusted);

@override
String toString() {
  return 'AuthState.authenticated(userId: $userId, accessToken: $accessToken, refreshToken: $refreshToken, challenge: $challenge, isDeviceTrusted: $isDeviceTrusted)';
}


}

/// @nodoc
abstract mixin class _$AuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthenticatedCopyWith(_Authenticated value, $Res Function(_Authenticated) _then) = __$AuthenticatedCopyWithImpl;
@useResult
$Res call({
 String userId, String? accessToken, String? refreshToken, String? challenge, bool isDeviceTrusted
});




}
/// @nodoc
class __$AuthenticatedCopyWithImpl<$Res>
    implements _$AuthenticatedCopyWith<$Res> {
  __$AuthenticatedCopyWithImpl(this._self, this._then);

  final _Authenticated _self;
  final $Res Function(_Authenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? accessToken = freezed,Object? refreshToken = freezed,Object? challenge = freezed,Object? isDeviceTrusted = null,}) {
  return _then(_Authenticated(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,challenge: freezed == challenge ? _self.challenge : challenge // ignore: cast_nullable_to_non_nullable
as String?,isDeviceTrusted: null == isDeviceTrusted ? _self.isDeviceTrusted : isDeviceTrusted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Error implements AuthState {
  const _Error({required this.code});
  

 final  String code;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,code);

@override
String toString() {
  return 'AuthState.error(code: $code)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String code
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,}) {
  return _then(_Error(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
