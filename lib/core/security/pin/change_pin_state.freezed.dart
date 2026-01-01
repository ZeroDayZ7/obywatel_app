// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_pin_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChangePinState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePinState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChangePinState()';
}


}

/// @nodoc
class $ChangePinStateCopyWith<$Res>  {
$ChangePinStateCopyWith(ChangePinState _, $Res Function(ChangePinState) __);
}


/// Adds pattern-matching-related methods to [ChangePinState].
extension ChangePinStatePatterns on ChangePinState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _EnterOld value)?  enterOld,TResult Function( _EnterNew value)?  enterNew,TResult Function( _ConfirmNew value)?  confirmNew,TResult Function( _Loading value)?  loading,TResult Function( _Success value)?  success,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnterOld() when enterOld != null:
return enterOld(_that);case _EnterNew() when enterNew != null:
return enterNew(_that);case _ConfirmNew() when confirmNew != null:
return confirmNew(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _EnterOld value)  enterOld,required TResult Function( _EnterNew value)  enterNew,required TResult Function( _ConfirmNew value)  confirmNew,required TResult Function( _Loading value)  loading,required TResult Function( _Success value)  success,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _EnterOld():
return enterOld(_that);case _EnterNew():
return enterNew(_that);case _ConfirmNew():
return confirmNew(_that);case _Loading():
return loading(_that);case _Success():
return success(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _EnterOld value)?  enterOld,TResult? Function( _EnterNew value)?  enterNew,TResult? Function( _ConfirmNew value)?  confirmNew,TResult? Function( _Loading value)?  loading,TResult? Function( _Success value)?  success,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _EnterOld() when enterOld != null:
return enterOld(_that);case _EnterNew() when enterNew != null:
return enterNew(_that);case _ConfirmNew() when confirmNew != null:
return confirmNew(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  enterOld,TResult Function()?  enterNew,TResult Function()?  confirmNew,TResult Function()?  loading,TResult Function()?  success,TResult Function( String messageKey)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnterOld() when enterOld != null:
return enterOld();case _EnterNew() when enterNew != null:
return enterNew();case _ConfirmNew() when confirmNew != null:
return confirmNew();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success();case _Error() when error != null:
return error(_that.messageKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  enterOld,required TResult Function()  enterNew,required TResult Function()  confirmNew,required TResult Function()  loading,required TResult Function()  success,required TResult Function( String messageKey)  error,}) {final _that = this;
switch (_that) {
case _EnterOld():
return enterOld();case _EnterNew():
return enterNew();case _ConfirmNew():
return confirmNew();case _Loading():
return loading();case _Success():
return success();case _Error():
return error(_that.messageKey);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  enterOld,TResult? Function()?  enterNew,TResult? Function()?  confirmNew,TResult? Function()?  loading,TResult? Function()?  success,TResult? Function( String messageKey)?  error,}) {final _that = this;
switch (_that) {
case _EnterOld() when enterOld != null:
return enterOld();case _EnterNew() when enterNew != null:
return enterNew();case _ConfirmNew() when confirmNew != null:
return confirmNew();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success();case _Error() when error != null:
return error(_that.messageKey);case _:
  return null;

}
}

}

/// @nodoc


class _EnterOld extends ChangePinState {
  const _EnterOld(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnterOld);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChangePinState.enterOld()';
}


}




/// @nodoc


class _EnterNew extends ChangePinState {
  const _EnterNew(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnterNew);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChangePinState.enterNew()';
}


}




/// @nodoc


class _ConfirmNew extends ChangePinState {
  const _ConfirmNew(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfirmNew);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChangePinState.confirmNew()';
}


}




/// @nodoc


class _Loading extends ChangePinState {
  const _Loading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChangePinState.loading()';
}


}




/// @nodoc


class _Success extends ChangePinState {
  const _Success(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChangePinState.success()';
}


}




/// @nodoc


class _Error extends ChangePinState {
  const _Error(this.messageKey): super._();
  

 final  String messageKey;

/// Create a copy of ChangePinState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.messageKey, messageKey) || other.messageKey == messageKey));
}


@override
int get hashCode => Object.hash(runtimeType,messageKey);

@override
String toString() {
  return 'ChangePinState.error(messageKey: $messageKey)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ChangePinStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String messageKey
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of ChangePinState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messageKey = null,}) {
  return _then(_Error(
null == messageKey ? _self.messageKey : messageKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
