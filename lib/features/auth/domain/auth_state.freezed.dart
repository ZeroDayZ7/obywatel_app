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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Locked value)?  locked,TResult Function( _Unauthenticated value)?  unauthenticated,TResult Function( _Authenticating value)?  authenticating,TResult Function( _TwoFaRequired value)?  twoFaRequired,TResult Function( _PartiallyAuthenticated value)?  partiallyAuthenticated,TResult Function( _Authenticated value)?  authenticated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Locked() when locked != null:
return locked(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _Authenticating() when authenticating != null:
return authenticating(_that);case _TwoFaRequired() when twoFaRequired != null:
return twoFaRequired(_that);case _PartiallyAuthenticated() when partiallyAuthenticated != null:
return partiallyAuthenticated(_that);case _Authenticated() when authenticated != null:
return authenticated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Locked value)  locked,required TResult Function( _Unauthenticated value)  unauthenticated,required TResult Function( _Authenticating value)  authenticating,required TResult Function( _TwoFaRequired value)  twoFaRequired,required TResult Function( _PartiallyAuthenticated value)  partiallyAuthenticated,required TResult Function( _Authenticated value)  authenticated,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Locked():
return locked(_that);case _Unauthenticated():
return unauthenticated(_that);case _Authenticating():
return authenticating(_that);case _TwoFaRequired():
return twoFaRequired(_that);case _PartiallyAuthenticated():
return partiallyAuthenticated(_that);case _Authenticated():
return authenticated(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Locked value)?  locked,TResult? Function( _Unauthenticated value)?  unauthenticated,TResult? Function( _Authenticating value)?  authenticating,TResult? Function( _TwoFaRequired value)?  twoFaRequired,TResult? Function( _PartiallyAuthenticated value)?  partiallyAuthenticated,TResult? Function( _Authenticated value)?  authenticated,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Locked() when locked != null:
return locked(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _Authenticating() when authenticating != null:
return authenticating(_that);case _TwoFaRequired() when twoFaRequired != null:
return twoFaRequired(_that);case _PartiallyAuthenticated() when partiallyAuthenticated != null:
return partiallyAuthenticated(_that);case _Authenticated() when authenticated != null:
return authenticated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  locked,TResult Function()?  unauthenticated,TResult Function()?  authenticating,TResult Function( String email,  String tempToken)?  twoFaRequired,TResult Function( String setupToken,  String challenge)?  partiallyAuthenticated,TResult Function( AuthUser user,  bool isDeviceTrusted)?  authenticated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Locked() when locked != null:
return locked();case _Unauthenticated() when unauthenticated != null:
return unauthenticated();case _Authenticating() when authenticating != null:
return authenticating();case _TwoFaRequired() when twoFaRequired != null:
return twoFaRequired(_that.email,_that.tempToken);case _PartiallyAuthenticated() when partiallyAuthenticated != null:
return partiallyAuthenticated(_that.setupToken,_that.challenge);case _Authenticated() when authenticated != null:
return authenticated(_that.user,_that.isDeviceTrusted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  locked,required TResult Function()  unauthenticated,required TResult Function()  authenticating,required TResult Function( String email,  String tempToken)  twoFaRequired,required TResult Function( String setupToken,  String challenge)  partiallyAuthenticated,required TResult Function( AuthUser user,  bool isDeviceTrusted)  authenticated,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Locked():
return locked();case _Unauthenticated():
return unauthenticated();case _Authenticating():
return authenticating();case _TwoFaRequired():
return twoFaRequired(_that.email,_that.tempToken);case _PartiallyAuthenticated():
return partiallyAuthenticated(_that.setupToken,_that.challenge);case _Authenticated():
return authenticated(_that.user,_that.isDeviceTrusted);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  locked,TResult? Function()?  unauthenticated,TResult? Function()?  authenticating,TResult? Function( String email,  String tempToken)?  twoFaRequired,TResult? Function( String setupToken,  String challenge)?  partiallyAuthenticated,TResult? Function( AuthUser user,  bool isDeviceTrusted)?  authenticated,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Locked() when locked != null:
return locked();case _Unauthenticated() when unauthenticated != null:
return unauthenticated();case _Authenticating() when authenticating != null:
return authenticating();case _TwoFaRequired() when twoFaRequired != null:
return twoFaRequired(_that.email,_that.tempToken);case _PartiallyAuthenticated() when partiallyAuthenticated != null:
return partiallyAuthenticated(_that.setupToken,_that.challenge);case _Authenticated() when authenticated != null:
return authenticated(_that.user,_that.isDeviceTrusted);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends AuthState {
  const _Initial(): super._();
  






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


class _Locked extends AuthState {
  const _Locked(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Locked);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.locked()';
}


}




/// @nodoc


class _Unauthenticated extends AuthState {
  const _Unauthenticated(): super._();
  






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


class _Authenticating extends AuthState {
  const _Authenticating(): super._();
  






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


class _TwoFaRequired extends AuthState {
  const _TwoFaRequired({required this.email, required this.tempToken}): super._();
  

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


class _PartiallyAuthenticated extends AuthState {
  const _PartiallyAuthenticated({required this.setupToken, required this.challenge}): super._();
  

 final  String setupToken;
 final  String challenge;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartiallyAuthenticatedCopyWith<_PartiallyAuthenticated> get copyWith => __$PartiallyAuthenticatedCopyWithImpl<_PartiallyAuthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartiallyAuthenticated&&(identical(other.setupToken, setupToken) || other.setupToken == setupToken)&&(identical(other.challenge, challenge) || other.challenge == challenge));
}


@override
int get hashCode => Object.hash(runtimeType,setupToken,challenge);

@override
String toString() {
  return 'AuthState.partiallyAuthenticated(setupToken: $setupToken, challenge: $challenge)';
}


}

/// @nodoc
abstract mixin class _$PartiallyAuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$PartiallyAuthenticatedCopyWith(_PartiallyAuthenticated value, $Res Function(_PartiallyAuthenticated) _then) = __$PartiallyAuthenticatedCopyWithImpl;
@useResult
$Res call({
 String setupToken, String challenge
});




}
/// @nodoc
class __$PartiallyAuthenticatedCopyWithImpl<$Res>
    implements _$PartiallyAuthenticatedCopyWith<$Res> {
  __$PartiallyAuthenticatedCopyWithImpl(this._self, this._then);

  final _PartiallyAuthenticated _self;
  final $Res Function(_PartiallyAuthenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? setupToken = null,Object? challenge = null,}) {
  return _then(_PartiallyAuthenticated(
setupToken: null == setupToken ? _self.setupToken : setupToken // ignore: cast_nullable_to_non_nullable
as String,challenge: null == challenge ? _self.challenge : challenge // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Authenticated extends AuthState {
  const _Authenticated({required this.user, this.isDeviceTrusted = false}): super._();
  

 final  AuthUser user;
@JsonKey() final  bool isDeviceTrusted;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticatedCopyWith<_Authenticated> get copyWith => __$AuthenticatedCopyWithImpl<_Authenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Authenticated&&(identical(other.user, user) || other.user == user)&&(identical(other.isDeviceTrusted, isDeviceTrusted) || other.isDeviceTrusted == isDeviceTrusted));
}


@override
int get hashCode => Object.hash(runtimeType,user,isDeviceTrusted);

@override
String toString() {
  return 'AuthState.authenticated(user: $user, isDeviceTrusted: $isDeviceTrusted)';
}


}

/// @nodoc
abstract mixin class _$AuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthenticatedCopyWith(_Authenticated value, $Res Function(_Authenticated) _then) = __$AuthenticatedCopyWithImpl;
@useResult
$Res call({
 AuthUser user, bool isDeviceTrusted
});


$AuthUserCopyWith<$Res> get user;

}
/// @nodoc
class __$AuthenticatedCopyWithImpl<$Res>
    implements _$AuthenticatedCopyWith<$Res> {
  __$AuthenticatedCopyWithImpl(this._self, this._then);

  final _Authenticated _self;
  final $Res Function(_Authenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,Object? isDeviceTrusted = null,}) {
  return _then(_Authenticated(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUser,isDeviceTrusted: null == isDeviceTrusted ? _self.isDeviceTrusted : isDeviceTrusted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res> get user {
  
  return $AuthUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
