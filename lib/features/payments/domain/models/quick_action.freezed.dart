// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuickAction {

 String get id; String get label; QuickActionType get type; IconData get icon; String get colorKey;
/// Create a copy of QuickAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickActionCopyWith<QuickAction> get copyWith => _$QuickActionCopyWithImpl<QuickAction>(this as QuickAction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickAction&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.colorKey, colorKey) || other.colorKey == colorKey));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,type,icon,colorKey);

@override
String toString() {
  return 'QuickAction(id: $id, label: $label, type: $type, icon: $icon, colorKey: $colorKey)';
}


}

/// @nodoc
abstract mixin class $QuickActionCopyWith<$Res>  {
  factory $QuickActionCopyWith(QuickAction value, $Res Function(QuickAction) _then) = _$QuickActionCopyWithImpl;
@useResult
$Res call({
 String id, String label, QuickActionType type, IconData icon, String colorKey
});




}
/// @nodoc
class _$QuickActionCopyWithImpl<$Res>
    implements $QuickActionCopyWith<$Res> {
  _$QuickActionCopyWithImpl(this._self, this._then);

  final QuickAction _self;
  final $Res Function(QuickAction) _then;

/// Create a copy of QuickAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? type = null,Object? icon = null,Object? colorKey = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuickActionType,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,colorKey: null == colorKey ? _self.colorKey : colorKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickAction].
extension QuickActionPatterns on QuickAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickAction value)  $default,){
final _that = this;
switch (_that) {
case _QuickAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickAction value)?  $default,){
final _that = this;
switch (_that) {
case _QuickAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  QuickActionType type,  IconData icon,  String colorKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickAction() when $default != null:
return $default(_that.id,_that.label,_that.type,_that.icon,_that.colorKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  QuickActionType type,  IconData icon,  String colorKey)  $default,) {final _that = this;
switch (_that) {
case _QuickAction():
return $default(_that.id,_that.label,_that.type,_that.icon,_that.colorKey);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  QuickActionType type,  IconData icon,  String colorKey)?  $default,) {final _that = this;
switch (_that) {
case _QuickAction() when $default != null:
return $default(_that.id,_that.label,_that.type,_that.icon,_that.colorKey);case _:
  return null;

}
}

}

/// @nodoc


class _QuickAction implements QuickAction {
  const _QuickAction({required this.id, required this.label, required this.type, required this.icon, required this.colorKey});
  

@override final  String id;
@override final  String label;
@override final  QuickActionType type;
@override final  IconData icon;
@override final  String colorKey;

/// Create a copy of QuickAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickActionCopyWith<_QuickAction> get copyWith => __$QuickActionCopyWithImpl<_QuickAction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickAction&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.colorKey, colorKey) || other.colorKey == colorKey));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,type,icon,colorKey);

@override
String toString() {
  return 'QuickAction(id: $id, label: $label, type: $type, icon: $icon, colorKey: $colorKey)';
}


}

/// @nodoc
abstract mixin class _$QuickActionCopyWith<$Res> implements $QuickActionCopyWith<$Res> {
  factory _$QuickActionCopyWith(_QuickAction value, $Res Function(_QuickAction) _then) = __$QuickActionCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, QuickActionType type, IconData icon, String colorKey
});




}
/// @nodoc
class __$QuickActionCopyWithImpl<$Res>
    implements _$QuickActionCopyWith<$Res> {
  __$QuickActionCopyWithImpl(this._self, this._then);

  final _QuickAction _self;
  final $Res Function(_QuickAction) _then;

/// Create a copy of QuickAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? type = null,Object? icon = null,Object? colorKey = null,}) {
  return _then(_QuickAction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuickActionType,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,colorKey: null == colorKey ? _self.colorKey : colorKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
