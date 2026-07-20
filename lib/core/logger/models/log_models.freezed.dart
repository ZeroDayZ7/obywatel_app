// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'log_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Breadcrumb {

 String get timestamp; String get message; LogLevel get level; String get module;
/// Create a copy of Breadcrumb
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreadcrumbCopyWith<Breadcrumb> get copyWith => _$BreadcrumbCopyWithImpl<Breadcrumb>(this as Breadcrumb, _$identity);

  /// Serializes this Breadcrumb to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Breadcrumb&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.message, message) || other.message == message)&&(identical(other.level, level) || other.level == level)&&(identical(other.module, module) || other.module == module));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timestamp,message,level,module);

@override
String toString() {
  return 'Breadcrumb(timestamp: $timestamp, message: $message, level: $level, module: $module)';
}


}

/// @nodoc
abstract mixin class $BreadcrumbCopyWith<$Res>  {
  factory $BreadcrumbCopyWith(Breadcrumb value, $Res Function(Breadcrumb) _then) = _$BreadcrumbCopyWithImpl;
@useResult
$Res call({
 String timestamp, String message, LogLevel level, String module
});




}
/// @nodoc
class _$BreadcrumbCopyWithImpl<$Res>
    implements $BreadcrumbCopyWith<$Res> {
  _$BreadcrumbCopyWithImpl(this._self, this._then);

  final Breadcrumb _self;
  final $Res Function(Breadcrumb) _then;

/// Create a copy of Breadcrumb
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timestamp = null,Object? message = null,Object? level = null,Object? module = null,}) {
  return _then(_self.copyWith(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as LogLevel,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Breadcrumb].
extension BreadcrumbPatterns on Breadcrumb {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Breadcrumb value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Breadcrumb() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Breadcrumb value)  $default,){
final _that = this;
switch (_that) {
case _Breadcrumb():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Breadcrumb value)?  $default,){
final _that = this;
switch (_that) {
case _Breadcrumb() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String timestamp,  String message,  LogLevel level,  String module)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Breadcrumb() when $default != null:
return $default(_that.timestamp,_that.message,_that.level,_that.module);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String timestamp,  String message,  LogLevel level,  String module)  $default,) {final _that = this;
switch (_that) {
case _Breadcrumb():
return $default(_that.timestamp,_that.message,_that.level,_that.module);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String timestamp,  String message,  LogLevel level,  String module)?  $default,) {final _that = this;
switch (_that) {
case _Breadcrumb() when $default != null:
return $default(_that.timestamp,_that.message,_that.level,_that.module);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Breadcrumb implements Breadcrumb {
  const _Breadcrumb({required this.timestamp, required this.message, required this.level, required this.module});
  factory _Breadcrumb.fromJson(Map<String, dynamic> json) => _$BreadcrumbFromJson(json);

@override final  String timestamp;
@override final  String message;
@override final  LogLevel level;
@override final  String module;

/// Create a copy of Breadcrumb
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreadcrumbCopyWith<_Breadcrumb> get copyWith => __$BreadcrumbCopyWithImpl<_Breadcrumb>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BreadcrumbToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Breadcrumb&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.message, message) || other.message == message)&&(identical(other.level, level) || other.level == level)&&(identical(other.module, module) || other.module == module));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timestamp,message,level,module);

@override
String toString() {
  return 'Breadcrumb(timestamp: $timestamp, message: $message, level: $level, module: $module)';
}


}

/// @nodoc
abstract mixin class _$BreadcrumbCopyWith<$Res> implements $BreadcrumbCopyWith<$Res> {
  factory _$BreadcrumbCopyWith(_Breadcrumb value, $Res Function(_Breadcrumb) _then) = __$BreadcrumbCopyWithImpl;
@override @useResult
$Res call({
 String timestamp, String message, LogLevel level, String module
});




}
/// @nodoc
class __$BreadcrumbCopyWithImpl<$Res>
    implements _$BreadcrumbCopyWith<$Res> {
  __$BreadcrumbCopyWithImpl(this._self, this._then);

  final _Breadcrumb _self;
  final $Res Function(_Breadcrumb) _then;

/// Create a copy of Breadcrumb
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timestamp = null,Object? message = null,Object? level = null,Object? module = null,}) {
  return _then(_Breadcrumb(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as LogLevel,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$LogPayload {

 LogLevel get level; String get message; String get env; String? get error; String? get stackTrace; List<Breadcrumb> get breadcrumbs; String get service;
/// Create a copy of LogPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LogPayloadCopyWith<LogPayload> get copyWith => _$LogPayloadCopyWithImpl<LogPayload>(this as LogPayload, _$identity);

  /// Serializes this LogPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogPayload&&(identical(other.level, level) || other.level == level)&&(identical(other.message, message) || other.message == message)&&(identical(other.env, env) || other.env == env)&&(identical(other.error, error) || other.error == error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace)&&const DeepCollectionEquality().equals(other.breadcrumbs, breadcrumbs)&&(identical(other.service, service) || other.service == service));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,message,env,error,stackTrace,const DeepCollectionEquality().hash(breadcrumbs),service);

@override
String toString() {
  return 'LogPayload(level: $level, message: $message, env: $env, error: $error, stackTrace: $stackTrace, breadcrumbs: $breadcrumbs, service: $service)';
}


}

/// @nodoc
abstract mixin class $LogPayloadCopyWith<$Res>  {
  factory $LogPayloadCopyWith(LogPayload value, $Res Function(LogPayload) _then) = _$LogPayloadCopyWithImpl;
@useResult
$Res call({
 LogLevel level, String message, String env, String? error, String? stackTrace, List<Breadcrumb> breadcrumbs, String service
});




}
/// @nodoc
class _$LogPayloadCopyWithImpl<$Res>
    implements $LogPayloadCopyWith<$Res> {
  _$LogPayloadCopyWithImpl(this._self, this._then);

  final LogPayload _self;
  final $Res Function(LogPayload) _then;

/// Create a copy of LogPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? message = null,Object? env = null,Object? error = freezed,Object? stackTrace = freezed,Object? breadcrumbs = null,Object? service = null,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as LogLevel,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,env: null == env ? _self.env : env // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as String?,breadcrumbs: null == breadcrumbs ? _self.breadcrumbs : breadcrumbs // ignore: cast_nullable_to_non_nullable
as List<Breadcrumb>,service: null == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LogPayload].
extension LogPayloadPatterns on LogPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LogPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LogPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LogPayload value)  $default,){
final _that = this;
switch (_that) {
case _LogPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LogPayload value)?  $default,){
final _that = this;
switch (_that) {
case _LogPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LogLevel level,  String message,  String env,  String? error,  String? stackTrace,  List<Breadcrumb> breadcrumbs,  String service)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LogPayload() when $default != null:
return $default(_that.level,_that.message,_that.env,_that.error,_that.stackTrace,_that.breadcrumbs,_that.service);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LogLevel level,  String message,  String env,  String? error,  String? stackTrace,  List<Breadcrumb> breadcrumbs,  String service)  $default,) {final _that = this;
switch (_that) {
case _LogPayload():
return $default(_that.level,_that.message,_that.env,_that.error,_that.stackTrace,_that.breadcrumbs,_that.service);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LogLevel level,  String message,  String env,  String? error,  String? stackTrace,  List<Breadcrumb> breadcrumbs,  String service)?  $default,) {final _that = this;
switch (_that) {
case _LogPayload() when $default != null:
return $default(_that.level,_that.message,_that.env,_that.error,_that.stackTrace,_that.breadcrumbs,_that.service);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LogPayload implements LogPayload {
  const _LogPayload({required this.level, required this.message, required this.env, this.error, this.stackTrace, required final  List<Breadcrumb> breadcrumbs, this.service = 'obywatel_app'}): _breadcrumbs = breadcrumbs;
  factory _LogPayload.fromJson(Map<String, dynamic> json) => _$LogPayloadFromJson(json);

@override final  LogLevel level;
@override final  String message;
@override final  String env;
@override final  String? error;
@override final  String? stackTrace;
 final  List<Breadcrumb> _breadcrumbs;
@override List<Breadcrumb> get breadcrumbs {
  if (_breadcrumbs is EqualUnmodifiableListView) return _breadcrumbs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_breadcrumbs);
}

@override@JsonKey() final  String service;

/// Create a copy of LogPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogPayloadCopyWith<_LogPayload> get copyWith => __$LogPayloadCopyWithImpl<_LogPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LogPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogPayload&&(identical(other.level, level) || other.level == level)&&(identical(other.message, message) || other.message == message)&&(identical(other.env, env) || other.env == env)&&(identical(other.error, error) || other.error == error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace)&&const DeepCollectionEquality().equals(other._breadcrumbs, _breadcrumbs)&&(identical(other.service, service) || other.service == service));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,message,env,error,stackTrace,const DeepCollectionEquality().hash(_breadcrumbs),service);

@override
String toString() {
  return 'LogPayload(level: $level, message: $message, env: $env, error: $error, stackTrace: $stackTrace, breadcrumbs: $breadcrumbs, service: $service)';
}


}

/// @nodoc
abstract mixin class _$LogPayloadCopyWith<$Res> implements $LogPayloadCopyWith<$Res> {
  factory _$LogPayloadCopyWith(_LogPayload value, $Res Function(_LogPayload) _then) = __$LogPayloadCopyWithImpl;
@override @useResult
$Res call({
 LogLevel level, String message, String env, String? error, String? stackTrace, List<Breadcrumb> breadcrumbs, String service
});




}
/// @nodoc
class __$LogPayloadCopyWithImpl<$Res>
    implements _$LogPayloadCopyWith<$Res> {
  __$LogPayloadCopyWithImpl(this._self, this._then);

  final _LogPayload _self;
  final $Res Function(_LogPayload) _then;

/// Create a copy of LogPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? message = null,Object? env = null,Object? error = freezed,Object? stackTrace = freezed,Object? breadcrumbs = null,Object? service = null,}) {
  return _then(_LogPayload(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as LogLevel,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,env: null == env ? _self.env : env // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as String?,breadcrumbs: null == breadcrumbs ? _self._breadcrumbs : breadcrumbs // ignore: cast_nullable_to_non_nullable
as List<Breadcrumb>,service: null == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
