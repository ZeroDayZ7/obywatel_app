// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_pin_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChangePinState {

 ChangePinStep get step; LocalSecurityMethod get currentMethod; LocalSecurityMethod get targetMethod; ChangePinOperationType get operationType; bool get isSubmitting; String? get errorMessageKey;
/// Create a copy of ChangePinState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangePinStateCopyWith<ChangePinState> get copyWith => _$ChangePinStateCopyWithImpl<ChangePinState>(this as ChangePinState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChangePinState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePinState&&(identical(other.step, _this.step) || other.step == _this.step)&&(identical(other.currentMethod, _this.currentMethod) || other.currentMethod == _this.currentMethod)&&(identical(other.targetMethod, _this.targetMethod) || other.targetMethod == _this.targetMethod)&&(identical(other.operationType, _this.operationType) || other.operationType == _this.operationType)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.errorMessageKey, _this.errorMessageKey) || other.errorMessageKey == _this.errorMessageKey));
}


@override
int get hashCode {
  final _this = this as ChangePinState;
  return Object.hash(runtimeType,_this.step,_this.currentMethod,_this.targetMethod,_this.operationType,_this.isSubmitting,_this.errorMessageKey);
}

@override
String toString() {
  final _this = this as ChangePinState;
  return 'ChangePinState(step: ${_this.step}, currentMethod: ${_this.currentMethod}, targetMethod: ${_this.targetMethod}, operationType: ${_this.operationType}, isSubmitting: ${_this.isSubmitting}, errorMessageKey: ${_this.errorMessageKey})';
}


}

/// @nodoc
abstract mixin class $ChangePinStateCopyWith<$Res>  {
  factory $ChangePinStateCopyWith(ChangePinState value, $Res Function(ChangePinState) _then) = _$ChangePinStateCopyWithImpl;
@useResult
$Res call({
 ChangePinStep step, LocalSecurityMethod currentMethod, LocalSecurityMethod targetMethod, ChangePinOperationType operationType, bool isSubmitting, String? errorMessageKey
});




}
/// @nodoc
class _$ChangePinStateCopyWithImpl<$Res>
    implements $ChangePinStateCopyWith<$Res> {
  _$ChangePinStateCopyWithImpl(this._self, this._then);

  final ChangePinState _self;
  final $Res Function(ChangePinState) _then;

/// Create a copy of ChangePinState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? currentMethod = null,Object? targetMethod = null,Object? operationType = null,Object? isSubmitting = null,Object? errorMessageKey = freezed,}) {
  return _then(ChangePinState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as ChangePinStep,currentMethod: null == currentMethod ? _self.currentMethod : currentMethod // ignore: cast_nullable_to_non_nullable
as LocalSecurityMethod,targetMethod: null == targetMethod ? _self.targetMethod : targetMethod // ignore: cast_nullable_to_non_nullable
as LocalSecurityMethod,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as ChangePinOperationType,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorMessageKey: freezed == errorMessageKey ? _self.errorMessageKey : errorMessageKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangePinState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangePinState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangePinState value)  $default,){
final _that = this;
switch (_that) {
case _ChangePinState():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangePinState value)?  $default,){
final _that = this;
switch (_that) {
case _ChangePinState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChangePinStep step,  LocalSecurityMethod currentMethod,  LocalSecurityMethod targetMethod,  ChangePinOperationType operationType,  bool isSubmitting,  String? errorMessageKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangePinState() when $default != null:
return $default(_that.step,_that.currentMethod,_that.targetMethod,_that.operationType,_that.isSubmitting,_that.errorMessageKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChangePinStep step,  LocalSecurityMethod currentMethod,  LocalSecurityMethod targetMethod,  ChangePinOperationType operationType,  bool isSubmitting,  String? errorMessageKey)  $default,) {final _that = this;
switch (_that) {
case _ChangePinState():
return $default(_that.step,_that.currentMethod,_that.targetMethod,_that.operationType,_that.isSubmitting,_that.errorMessageKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChangePinStep step,  LocalSecurityMethod currentMethod,  LocalSecurityMethod targetMethod,  ChangePinOperationType operationType,  bool isSubmitting,  String? errorMessageKey)?  $default,) {final _that = this;
switch (_that) {
case _ChangePinState() when $default != null:
return $default(_that.step,_that.currentMethod,_that.targetMethod,_that.operationType,_that.isSubmitting,_that.errorMessageKey);case _:
  return null;

}
}

}

/// @nodoc


class _ChangePinState extends ChangePinState {
  const _ChangePinState({this.step = ChangePinStep.selectMethod, this.currentMethod = LocalSecurityMethod.none, this.targetMethod = LocalSecurityMethod.none, this.operationType = ChangePinOperationType.changeSecret, this.isSubmitting = false, this.errorMessageKey}): super._();
  

@override@JsonKey() final  ChangePinStep step;
@override@JsonKey() final  LocalSecurityMethod currentMethod;
@override@JsonKey() final  LocalSecurityMethod targetMethod;
@override@JsonKey() final  ChangePinOperationType operationType;
@override@JsonKey() final  bool isSubmitting;
@override final  String? errorMessageKey;

/// Create a copy of ChangePinState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangePinStateCopyWith<_ChangePinState> get copyWith => __$ChangePinStateCopyWithImpl<_ChangePinState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangePinState&&(identical(other.step, step) || other.step == step)&&(identical(other.currentMethod, currentMethod) || other.currentMethod == currentMethod)&&(identical(other.targetMethod, targetMethod) || other.targetMethod == targetMethod)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorMessageKey, errorMessageKey) || other.errorMessageKey == errorMessageKey));
}


@override
int get hashCode {
    return Object.hash(runtimeType,step,currentMethod,targetMethod,operationType,isSubmitting,errorMessageKey);
}

@override
String toString() {
    return 'ChangePinState(step: $step, currentMethod: $currentMethod, targetMethod: $targetMethod, operationType: $operationType, isSubmitting: $isSubmitting, errorMessageKey: $errorMessageKey)';
}


}

/// @nodoc
abstract mixin class _$ChangePinStateCopyWith<$Res> implements $ChangePinStateCopyWith<$Res> {
  factory _$ChangePinStateCopyWith(_ChangePinState value, $Res Function(_ChangePinState) _then) = __$ChangePinStateCopyWithImpl;
@override @useResult
$Res call({
 ChangePinStep step, LocalSecurityMethod currentMethod, LocalSecurityMethod targetMethod, ChangePinOperationType operationType, bool isSubmitting, String? errorMessageKey
});




}
/// @nodoc
class __$ChangePinStateCopyWithImpl<$Res>
    implements _$ChangePinStateCopyWith<$Res> {
  __$ChangePinStateCopyWithImpl(this._self, this._then);

  final _ChangePinState _self;
  final $Res Function(_ChangePinState) _then;

/// Create a copy of ChangePinState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? currentMethod = null,Object? targetMethod = null,Object? operationType = null,Object? isSubmitting = null,Object? errorMessageKey = freezed,}) {
  return _then(_ChangePinState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as ChangePinStep,currentMethod: null == currentMethod ? _self.currentMethod : currentMethod // ignore: cast_nullable_to_non_nullable
as LocalSecurityMethod,targetMethod: null == targetMethod ? _self.targetMethod : targetMethod // ignore: cast_nullable_to_non_nullable
as LocalSecurityMethod,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as ChangePinOperationType,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorMessageKey: freezed == errorMessageKey ? _self.errorMessageKey : errorMessageKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
