// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppFailure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppFailure()';
}


}

/// @nodoc
class $AppFailureCopyWith<$Res>  {
$AppFailureCopyWith(AppFailure _, $Res Function(AppFailure) __);
}


/// Adds pattern-matching-related methods to [AppFailure].
extension AppFailurePatterns on AppFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Network value)?  network,TResult Function( _Server value)?  server,TResult Function( _Validation value)?  validation,TResult Function( _Cache value)?  cache,TResult Function( _Unknown value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Network() when network != null:
return network(_that);case _Server() when server != null:
return server(_that);case _Validation() when validation != null:
return validation(_that);case _Cache() when cache != null:
return cache(_that);case _Unknown() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Network value)  network,required TResult Function( _Server value)  server,required TResult Function( _Validation value)  validation,required TResult Function( _Cache value)  cache,required TResult Function( _Unknown value)  unknown,}){
final _that = this;
switch (_that) {
case _Network():
return network(_that);case _Server():
return server(_that);case _Validation():
return validation(_that);case _Cache():
return cache(_that);case _Unknown():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Network value)?  network,TResult? Function( _Server value)?  server,TResult? Function( _Validation value)?  validation,TResult? Function( _Cache value)?  cache,TResult? Function( _Unknown value)?  unknown,}){
final _that = this;
switch (_that) {
case _Network() when network != null:
return network(_that);case _Server() when server != null:
return server(_that);case _Validation() when validation != null:
return validation(_that);case _Cache() when cache != null:
return cache(_that);case _Unknown() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  network,TResult Function( int? statusCode)?  server,TResult Function( String messageKey)?  validation,TResult Function()?  cache,TResult Function()?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Network() when network != null:
return network();case _Server() when server != null:
return server(_that.statusCode);case _Validation() when validation != null:
return validation(_that.messageKey);case _Cache() when cache != null:
return cache();case _Unknown() when unknown != null:
return unknown();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  network,required TResult Function( int? statusCode)  server,required TResult Function( String messageKey)  validation,required TResult Function()  cache,required TResult Function()  unknown,}) {final _that = this;
switch (_that) {
case _Network():
return network();case _Server():
return server(_that.statusCode);case _Validation():
return validation(_that.messageKey);case _Cache():
return cache();case _Unknown():
return unknown();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  network,TResult? Function( int? statusCode)?  server,TResult? Function( String messageKey)?  validation,TResult? Function()?  cache,TResult? Function()?  unknown,}) {final _that = this;
switch (_that) {
case _Network() when network != null:
return network();case _Server() when server != null:
return server(_that.statusCode);case _Validation() when validation != null:
return validation(_that.messageKey);case _Cache() when cache != null:
return cache();case _Unknown() when unknown != null:
return unknown();case _:
  return null;

}
}

}

/// @nodoc


class _Network extends AppFailure {
  const _Network(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Network);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppFailure.network()';
}


}




/// @nodoc


class _Server extends AppFailure {
  const _Server({this.statusCode}): super._();
  

 final  int? statusCode;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerCopyWith<_Server> get copyWith => __$ServerCopyWithImpl<_Server>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Server&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,statusCode);

@override
String toString() {
  return 'AppFailure.server(statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class _$ServerCopyWith<$Res> implements $AppFailureCopyWith<$Res> {
  factory _$ServerCopyWith(_Server value, $Res Function(_Server) _then) = __$ServerCopyWithImpl;
@useResult
$Res call({
 int? statusCode
});




}
/// @nodoc
class __$ServerCopyWithImpl<$Res>
    implements _$ServerCopyWith<$Res> {
  __$ServerCopyWithImpl(this._self, this._then);

  final _Server _self;
  final $Res Function(_Server) _then;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? statusCode = freezed,}) {
  return _then(_Server(
statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class _Validation extends AppFailure {
  const _Validation({required this.messageKey}): super._();
  

 final  String messageKey;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ValidationCopyWith<_Validation> get copyWith => __$ValidationCopyWithImpl<_Validation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Validation&&(identical(other.messageKey, messageKey) || other.messageKey == messageKey));
}


@override
int get hashCode => Object.hash(runtimeType,messageKey);

@override
String toString() {
  return 'AppFailure.validation(messageKey: $messageKey)';
}


}

/// @nodoc
abstract mixin class _$ValidationCopyWith<$Res> implements $AppFailureCopyWith<$Res> {
  factory _$ValidationCopyWith(_Validation value, $Res Function(_Validation) _then) = __$ValidationCopyWithImpl;
@useResult
$Res call({
 String messageKey
});




}
/// @nodoc
class __$ValidationCopyWithImpl<$Res>
    implements _$ValidationCopyWith<$Res> {
  __$ValidationCopyWithImpl(this._self, this._then);

  final _Validation _self;
  final $Res Function(_Validation) _then;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messageKey = null,}) {
  return _then(_Validation(
messageKey: null == messageKey ? _self.messageKey : messageKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Cache extends AppFailure {
  const _Cache(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cache);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppFailure.cache()';
}


}




/// @nodoc


class _Unknown extends AppFailure {
  const _Unknown(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unknown);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppFailure.unknown()';
}


}




// dart format on
