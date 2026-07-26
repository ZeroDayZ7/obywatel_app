// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResetPasswordState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetPasswordState()';
}


}

/// @nodoc
class $ResetPasswordStateCopyWith<$Res>  {
$ResetPasswordStateCopyWith(ResetPasswordState _, $Res Function(ResetPasswordState) __);
}


/// Adds pattern-matching-related methods to [ResetPasswordState].
extension ResetPasswordStatePatterns on ResetPasswordState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _MethodChosen value)?  methodChosen,TResult Function( _Loading value)?  loading,TResult Function( _CodeSent value)?  codeSent,TResult Function( _CodeVerified value)?  codeVerified,TResult Function( _Completed value)?  completed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _MethodChosen() when methodChosen != null:
return methodChosen(_that);case _Loading() when loading != null:
return loading(_that);case _CodeSent() when codeSent != null:
return codeSent(_that);case _CodeVerified() when codeVerified != null:
return codeVerified(_that);case _Completed() when completed != null:
return completed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _MethodChosen value)  methodChosen,required TResult Function( _Loading value)  loading,required TResult Function( _CodeSent value)  codeSent,required TResult Function( _CodeVerified value)  codeVerified,required TResult Function( _Completed value)  completed,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _MethodChosen():
return methodChosen(_that);case _Loading():
return loading(_that);case _CodeSent():
return codeSent(_that);case _CodeVerified():
return codeVerified(_that);case _Completed():
return completed(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _MethodChosen value)?  methodChosen,TResult? Function( _Loading value)?  loading,TResult? Function( _CodeSent value)?  codeSent,TResult? Function( _CodeVerified value)?  codeVerified,TResult? Function( _Completed value)?  completed,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _MethodChosen() when methodChosen != null:
return methodChosen(_that);case _Loading() when loading != null:
return loading(_that);case _CodeSent() when codeSent != null:
return codeSent(_that);case _CodeVerified() when codeVerified != null:
return codeVerified(_that);case _Completed() when completed != null:
return completed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( String accountIdentifier,  String contactValue,  ResetMethod method)?  methodChosen,TResult Function()?  loading,TResult Function( String accountIdentifier,  String contactValue,  ResetMethod method,  int resendTime,  bool canResend,  String? token)?  codeSent,TResult Function( String? token,  String? challenge)?  codeVerified,TResult Function()?  completed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _MethodChosen() when methodChosen != null:
return methodChosen(_that.accountIdentifier,_that.contactValue,_that.method);case _Loading() when loading != null:
return loading();case _CodeSent() when codeSent != null:
return codeSent(_that.accountIdentifier,_that.contactValue,_that.method,_that.resendTime,_that.canResend,_that.token);case _CodeVerified() when codeVerified != null:
return codeVerified(_that.token,_that.challenge);case _Completed() when completed != null:
return completed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( String accountIdentifier,  String contactValue,  ResetMethod method)  methodChosen,required TResult Function()  loading,required TResult Function( String accountIdentifier,  String contactValue,  ResetMethod method,  int resendTime,  bool canResend,  String? token)  codeSent,required TResult Function( String? token,  String? challenge)  codeVerified,required TResult Function()  completed,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _MethodChosen():
return methodChosen(_that.accountIdentifier,_that.contactValue,_that.method);case _Loading():
return loading();case _CodeSent():
return codeSent(_that.accountIdentifier,_that.contactValue,_that.method,_that.resendTime,_that.canResend,_that.token);case _CodeVerified():
return codeVerified(_that.token,_that.challenge);case _Completed():
return completed();case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( String accountIdentifier,  String contactValue,  ResetMethod method)?  methodChosen,TResult? Function()?  loading,TResult? Function( String accountIdentifier,  String contactValue,  ResetMethod method,  int resendTime,  bool canResend,  String? token)?  codeSent,TResult? Function( String? token,  String? challenge)?  codeVerified,TResult? Function()?  completed,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _MethodChosen() when methodChosen != null:
return methodChosen(_that.accountIdentifier,_that.contactValue,_that.method);case _Loading() when loading != null:
return loading();case _CodeSent() when codeSent != null:
return codeSent(_that.accountIdentifier,_that.contactValue,_that.method,_that.resendTime,_that.canResend,_that.token);case _CodeVerified() when codeVerified != null:
return codeVerified(_that.token,_that.challenge);case _Completed() when completed != null:
return completed();case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ResetPasswordState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetPasswordState.initial()';
}


}




/// @nodoc


class _MethodChosen implements ResetPasswordState {
  const _MethodChosen({required this.accountIdentifier, required this.contactValue, required this.method});
  

 final  String accountIdentifier;
 final  String contactValue;
 final  ResetMethod method;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MethodChosenCopyWith<_MethodChosen> get copyWith => __$MethodChosenCopyWithImpl<_MethodChosen>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MethodChosen&&(identical(other.accountIdentifier, accountIdentifier) || other.accountIdentifier == accountIdentifier)&&(identical(other.contactValue, contactValue) || other.contactValue == contactValue)&&(identical(other.method, method) || other.method == method));
}


@override
int get hashCode => Object.hash(runtimeType,accountIdentifier,contactValue,method);

@override
String toString() {
  return 'ResetPasswordState.methodChosen(accountIdentifier: $accountIdentifier, contactValue: $contactValue, method: $method)';
}


}

/// @nodoc
abstract mixin class _$MethodChosenCopyWith<$Res> implements $ResetPasswordStateCopyWith<$Res> {
  factory _$MethodChosenCopyWith(_MethodChosen value, $Res Function(_MethodChosen) _then) = __$MethodChosenCopyWithImpl;
@useResult
$Res call({
 String accountIdentifier, String contactValue, ResetMethod method
});




}
/// @nodoc
class __$MethodChosenCopyWithImpl<$Res>
    implements _$MethodChosenCopyWith<$Res> {
  __$MethodChosenCopyWithImpl(this._self, this._then);

  final _MethodChosen _self;
  final $Res Function(_MethodChosen) _then;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? accountIdentifier = null,Object? contactValue = null,Object? method = null,}) {
  return _then(_MethodChosen(
accountIdentifier: null == accountIdentifier ? _self.accountIdentifier : accountIdentifier // ignore: cast_nullable_to_non_nullable
as String,contactValue: null == contactValue ? _self.contactValue : contactValue // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ResetMethod,
  ));
}


}

/// @nodoc


class _Loading implements ResetPasswordState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetPasswordState.loading()';
}


}




/// @nodoc


class _CodeSent implements ResetPasswordState {
  const _CodeSent({required this.accountIdentifier, required this.contactValue, required this.method, required this.resendTime, required this.canResend, this.token});
  

 final  String accountIdentifier;
 final  String contactValue;
 final  ResetMethod method;
 final  int resendTime;
 final  bool canResend;
 final  String? token;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CodeSentCopyWith<_CodeSent> get copyWith => __$CodeSentCopyWithImpl<_CodeSent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CodeSent&&(identical(other.accountIdentifier, accountIdentifier) || other.accountIdentifier == accountIdentifier)&&(identical(other.contactValue, contactValue) || other.contactValue == contactValue)&&(identical(other.method, method) || other.method == method)&&(identical(other.resendTime, resendTime) || other.resendTime == resendTime)&&(identical(other.canResend, canResend) || other.canResend == canResend)&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,accountIdentifier,contactValue,method,resendTime,canResend,token);

@override
String toString() {
  return 'ResetPasswordState.codeSent(accountIdentifier: $accountIdentifier, contactValue: $contactValue, method: $method, resendTime: $resendTime, canResend: $canResend, token: $token)';
}


}

/// @nodoc
abstract mixin class _$CodeSentCopyWith<$Res> implements $ResetPasswordStateCopyWith<$Res> {
  factory _$CodeSentCopyWith(_CodeSent value, $Res Function(_CodeSent) _then) = __$CodeSentCopyWithImpl;
@useResult
$Res call({
 String accountIdentifier, String contactValue, ResetMethod method, int resendTime, bool canResend, String? token
});




}
/// @nodoc
class __$CodeSentCopyWithImpl<$Res>
    implements _$CodeSentCopyWith<$Res> {
  __$CodeSentCopyWithImpl(this._self, this._then);

  final _CodeSent _self;
  final $Res Function(_CodeSent) _then;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? accountIdentifier = null,Object? contactValue = null,Object? method = null,Object? resendTime = null,Object? canResend = null,Object? token = freezed,}) {
  return _then(_CodeSent(
accountIdentifier: null == accountIdentifier ? _self.accountIdentifier : accountIdentifier // ignore: cast_nullable_to_non_nullable
as String,contactValue: null == contactValue ? _self.contactValue : contactValue // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ResetMethod,resendTime: null == resendTime ? _self.resendTime : resendTime // ignore: cast_nullable_to_non_nullable
as int,canResend: null == canResend ? _self.canResend : canResend // ignore: cast_nullable_to_non_nullable
as bool,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _CodeVerified implements ResetPasswordState {
  const _CodeVerified({this.token, this.challenge});
  

 final  String? token;
 final  String? challenge;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CodeVerifiedCopyWith<_CodeVerified> get copyWith => __$CodeVerifiedCopyWithImpl<_CodeVerified>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CodeVerified&&(identical(other.token, token) || other.token == token)&&(identical(other.challenge, challenge) || other.challenge == challenge));
}


@override
int get hashCode => Object.hash(runtimeType,token,challenge);

@override
String toString() {
  return 'ResetPasswordState.codeVerified(token: $token, challenge: $challenge)';
}


}

/// @nodoc
abstract mixin class _$CodeVerifiedCopyWith<$Res> implements $ResetPasswordStateCopyWith<$Res> {
  factory _$CodeVerifiedCopyWith(_CodeVerified value, $Res Function(_CodeVerified) _then) = __$CodeVerifiedCopyWithImpl;
@useResult
$Res call({
 String? token, String? challenge
});




}
/// @nodoc
class __$CodeVerifiedCopyWithImpl<$Res>
    implements _$CodeVerifiedCopyWith<$Res> {
  __$CodeVerifiedCopyWithImpl(this._self, this._then);

  final _CodeVerified _self;
  final $Res Function(_CodeVerified) _then;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? token = freezed,Object? challenge = freezed,}) {
  return _then(_CodeVerified(
token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,challenge: freezed == challenge ? _self.challenge : challenge // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Completed implements ResetPasswordState {
  const _Completed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Completed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetPasswordState.completed()';
}


}




// dart format on
