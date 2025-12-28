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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _MethodChosen value)?  methodChosen,TResult Function( _SendingCode value)?  sendingCode,TResult Function( _CodeSent value)?  codeSent,TResult Function( _VerifyingCode value)?  verifyingCode,TResult Function( _CodeVerified value)?  codeVerified,TResult Function( _ResettingPassword value)?  resettingPassword,TResult Function( _Completed value)?  completed,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _MethodChosen() when methodChosen != null:
return methodChosen(_that);case _SendingCode() when sendingCode != null:
return sendingCode(_that);case _CodeSent() when codeSent != null:
return codeSent(_that);case _VerifyingCode() when verifyingCode != null:
return verifyingCode(_that);case _CodeVerified() when codeVerified != null:
return codeVerified(_that);case _ResettingPassword() when resettingPassword != null:
return resettingPassword(_that);case _Completed() when completed != null:
return completed(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _MethodChosen value)  methodChosen,required TResult Function( _SendingCode value)  sendingCode,required TResult Function( _CodeSent value)  codeSent,required TResult Function( _VerifyingCode value)  verifyingCode,required TResult Function( _CodeVerified value)  codeVerified,required TResult Function( _ResettingPassword value)  resettingPassword,required TResult Function( _Completed value)  completed,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _MethodChosen():
return methodChosen(_that);case _SendingCode():
return sendingCode(_that);case _CodeSent():
return codeSent(_that);case _VerifyingCode():
return verifyingCode(_that);case _CodeVerified():
return codeVerified(_that);case _ResettingPassword():
return resettingPassword(_that);case _Completed():
return completed(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _MethodChosen value)?  methodChosen,TResult? Function( _SendingCode value)?  sendingCode,TResult? Function( _CodeSent value)?  codeSent,TResult? Function( _VerifyingCode value)?  verifyingCode,TResult? Function( _CodeVerified value)?  codeVerified,TResult? Function( _ResettingPassword value)?  resettingPassword,TResult? Function( _Completed value)?  completed,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _MethodChosen() when methodChosen != null:
return methodChosen(_that);case _SendingCode() when sendingCode != null:
return sendingCode(_that);case _CodeSent() when codeSent != null:
return codeSent(_that);case _VerifyingCode() when verifyingCode != null:
return verifyingCode(_that);case _CodeVerified() when codeVerified != null:
return codeVerified(_that);case _ResettingPassword() when resettingPassword != null:
return resettingPassword(_that);case _Completed() when completed != null:
return completed(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( String input,  ResetMethod method)?  methodChosen,TResult Function( String input,  ResetMethod method)?  sendingCode,TResult Function( String input,  ResetMethod method,  int resendTime,  bool canResend)?  codeSent,TResult Function()?  verifyingCode,TResult Function()?  codeVerified,TResult Function()?  resettingPassword,TResult Function()?  completed,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _MethodChosen() when methodChosen != null:
return methodChosen(_that.input,_that.method);case _SendingCode() when sendingCode != null:
return sendingCode(_that.input,_that.method);case _CodeSent() when codeSent != null:
return codeSent(_that.input,_that.method,_that.resendTime,_that.canResend);case _VerifyingCode() when verifyingCode != null:
return verifyingCode();case _CodeVerified() when codeVerified != null:
return codeVerified();case _ResettingPassword() when resettingPassword != null:
return resettingPassword();case _Completed() when completed != null:
return completed();case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( String input,  ResetMethod method)  methodChosen,required TResult Function( String input,  ResetMethod method)  sendingCode,required TResult Function( String input,  ResetMethod method,  int resendTime,  bool canResend)  codeSent,required TResult Function()  verifyingCode,required TResult Function()  codeVerified,required TResult Function()  resettingPassword,required TResult Function()  completed,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _MethodChosen():
return methodChosen(_that.input,_that.method);case _SendingCode():
return sendingCode(_that.input,_that.method);case _CodeSent():
return codeSent(_that.input,_that.method,_that.resendTime,_that.canResend);case _VerifyingCode():
return verifyingCode();case _CodeVerified():
return codeVerified();case _ResettingPassword():
return resettingPassword();case _Completed():
return completed();case _Error():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( String input,  ResetMethod method)?  methodChosen,TResult? Function( String input,  ResetMethod method)?  sendingCode,TResult? Function( String input,  ResetMethod method,  int resendTime,  bool canResend)?  codeSent,TResult? Function()?  verifyingCode,TResult? Function()?  codeVerified,TResult? Function()?  resettingPassword,TResult? Function()?  completed,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _MethodChosen() when methodChosen != null:
return methodChosen(_that.input,_that.method);case _SendingCode() when sendingCode != null:
return sendingCode(_that.input,_that.method);case _CodeSent() when codeSent != null:
return codeSent(_that.input,_that.method,_that.resendTime,_that.canResend);case _VerifyingCode() when verifyingCode != null:
return verifyingCode();case _CodeVerified() when codeVerified != null:
return codeVerified();case _ResettingPassword() when resettingPassword != null:
return resettingPassword();case _Completed() when completed != null:
return completed();case _Error() when error != null:
return error(_that.message);case _:
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
  const _MethodChosen({required this.input, required this.method});
  

 final  String input;
 final  ResetMethod method;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MethodChosenCopyWith<_MethodChosen> get copyWith => __$MethodChosenCopyWithImpl<_MethodChosen>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MethodChosen&&(identical(other.input, input) || other.input == input)&&(identical(other.method, method) || other.method == method));
}


@override
int get hashCode => Object.hash(runtimeType,input,method);

@override
String toString() {
  return 'ResetPasswordState.methodChosen(input: $input, method: $method)';
}


}

/// @nodoc
abstract mixin class _$MethodChosenCopyWith<$Res> implements $ResetPasswordStateCopyWith<$Res> {
  factory _$MethodChosenCopyWith(_MethodChosen value, $Res Function(_MethodChosen) _then) = __$MethodChosenCopyWithImpl;
@useResult
$Res call({
 String input, ResetMethod method
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
@pragma('vm:prefer-inline') $Res call({Object? input = null,Object? method = null,}) {
  return _then(_MethodChosen(
input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ResetMethod,
  ));
}


}

/// @nodoc


class _SendingCode implements ResetPasswordState {
  const _SendingCode({required this.input, required this.method});
  

 final  String input;
 final  ResetMethod method;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendingCodeCopyWith<_SendingCode> get copyWith => __$SendingCodeCopyWithImpl<_SendingCode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendingCode&&(identical(other.input, input) || other.input == input)&&(identical(other.method, method) || other.method == method));
}


@override
int get hashCode => Object.hash(runtimeType,input,method);

@override
String toString() {
  return 'ResetPasswordState.sendingCode(input: $input, method: $method)';
}


}

/// @nodoc
abstract mixin class _$SendingCodeCopyWith<$Res> implements $ResetPasswordStateCopyWith<$Res> {
  factory _$SendingCodeCopyWith(_SendingCode value, $Res Function(_SendingCode) _then) = __$SendingCodeCopyWithImpl;
@useResult
$Res call({
 String input, ResetMethod method
});




}
/// @nodoc
class __$SendingCodeCopyWithImpl<$Res>
    implements _$SendingCodeCopyWith<$Res> {
  __$SendingCodeCopyWithImpl(this._self, this._then);

  final _SendingCode _self;
  final $Res Function(_SendingCode) _then;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? input = null,Object? method = null,}) {
  return _then(_SendingCode(
input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ResetMethod,
  ));
}


}

/// @nodoc


class _CodeSent implements ResetPasswordState {
  const _CodeSent({required this.input, required this.method, this.resendTime = 30, this.canResend = false});
  

 final  String input;
 final  ResetMethod method;
@JsonKey() final  int resendTime;
@JsonKey() final  bool canResend;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CodeSentCopyWith<_CodeSent> get copyWith => __$CodeSentCopyWithImpl<_CodeSent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CodeSent&&(identical(other.input, input) || other.input == input)&&(identical(other.method, method) || other.method == method)&&(identical(other.resendTime, resendTime) || other.resendTime == resendTime)&&(identical(other.canResend, canResend) || other.canResend == canResend));
}


@override
int get hashCode => Object.hash(runtimeType,input,method,resendTime,canResend);

@override
String toString() {
  return 'ResetPasswordState.codeSent(input: $input, method: $method, resendTime: $resendTime, canResend: $canResend)';
}


}

/// @nodoc
abstract mixin class _$CodeSentCopyWith<$Res> implements $ResetPasswordStateCopyWith<$Res> {
  factory _$CodeSentCopyWith(_CodeSent value, $Res Function(_CodeSent) _then) = __$CodeSentCopyWithImpl;
@useResult
$Res call({
 String input, ResetMethod method, int resendTime, bool canResend
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
@pragma('vm:prefer-inline') $Res call({Object? input = null,Object? method = null,Object? resendTime = null,Object? canResend = null,}) {
  return _then(_CodeSent(
input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ResetMethod,resendTime: null == resendTime ? _self.resendTime : resendTime // ignore: cast_nullable_to_non_nullable
as int,canResend: null == canResend ? _self.canResend : canResend // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _VerifyingCode implements ResetPasswordState {
  const _VerifyingCode();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerifyingCode);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetPasswordState.verifyingCode()';
}


}




/// @nodoc


class _CodeVerified implements ResetPasswordState {
  const _CodeVerified();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CodeVerified);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetPasswordState.codeVerified()';
}


}




/// @nodoc


class _ResettingPassword implements ResetPasswordState {
  const _ResettingPassword();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResettingPassword);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetPasswordState.resettingPassword()';
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




/// @nodoc


class _Error implements ResetPasswordState {
  const _Error({required this.message});
  

 final  String message;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ResetPasswordState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ResetPasswordStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
