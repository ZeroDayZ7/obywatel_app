// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_access_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuickAccessItem {

 String get id; String get title; String get subtitle; String get iconName; QuickAccessAccent get accent; String get route; bool get isEnabled; int get sortOrder; bool get isHidden; int get visualOffsetX; int get visualOffsetY; double get widthScale;
/// Create a copy of QuickAccessItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickAccessItemCopyWith<QuickAccessItem> get copyWith => _$QuickAccessItemCopyWithImpl<QuickAccessItem>(this as QuickAccessItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickAccessItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.accent, accent) || other.accent == accent)&&(identical(other.route, route) || other.route == route)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.visualOffsetX, visualOffsetX) || other.visualOffsetX == visualOffsetX)&&(identical(other.visualOffsetY, visualOffsetY) || other.visualOffsetY == visualOffsetY)&&(identical(other.widthScale, widthScale) || other.widthScale == widthScale));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,iconName,accent,route,isEnabled,sortOrder,isHidden,visualOffsetX,visualOffsetY,widthScale);

@override
String toString() {
  return 'QuickAccessItem(id: $id, title: $title, subtitle: $subtitle, iconName: $iconName, accent: $accent, route: $route, isEnabled: $isEnabled, sortOrder: $sortOrder, isHidden: $isHidden, visualOffsetX: $visualOffsetX, visualOffsetY: $visualOffsetY, widthScale: $widthScale)';
}


}

/// @nodoc
abstract mixin class $QuickAccessItemCopyWith<$Res>  {
  factory $QuickAccessItemCopyWith(QuickAccessItem value, $Res Function(QuickAccessItem) _then) = _$QuickAccessItemCopyWithImpl;
@useResult
$Res call({
 String id, String title, String subtitle, String iconName, QuickAccessAccent accent, String route, bool isEnabled, int sortOrder, bool isHidden, int visualOffsetX, int visualOffsetY, double widthScale
});




}
/// @nodoc
class _$QuickAccessItemCopyWithImpl<$Res>
    implements $QuickAccessItemCopyWith<$Res> {
  _$QuickAccessItemCopyWithImpl(this._self, this._then);

  final QuickAccessItem _self;
  final $Res Function(QuickAccessItem) _then;

/// Create a copy of QuickAccessItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? iconName = null,Object? accent = null,Object? route = null,Object? isEnabled = null,Object? sortOrder = null,Object? isHidden = null,Object? visualOffsetX = null,Object? visualOffsetY = null,Object? widthScale = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,accent: null == accent ? _self.accent : accent // ignore: cast_nullable_to_non_nullable
as QuickAccessAccent,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,visualOffsetX: null == visualOffsetX ? _self.visualOffsetX : visualOffsetX // ignore: cast_nullable_to_non_nullable
as int,visualOffsetY: null == visualOffsetY ? _self.visualOffsetY : visualOffsetY // ignore: cast_nullable_to_non_nullable
as int,widthScale: null == widthScale ? _self.widthScale : widthScale // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickAccessItem].
extension QuickAccessItemPatterns on QuickAccessItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickAccessItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickAccessItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickAccessItem value)  $default,){
final _that = this;
switch (_that) {
case _QuickAccessItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickAccessItem value)?  $default,){
final _that = this;
switch (_that) {
case _QuickAccessItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle,  String iconName,  QuickAccessAccent accent,  String route,  bool isEnabled,  int sortOrder,  bool isHidden,  int visualOffsetX,  int visualOffsetY,  double widthScale)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickAccessItem() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.iconName,_that.accent,_that.route,_that.isEnabled,_that.sortOrder,_that.isHidden,_that.visualOffsetX,_that.visualOffsetY,_that.widthScale);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle,  String iconName,  QuickAccessAccent accent,  String route,  bool isEnabled,  int sortOrder,  bool isHidden,  int visualOffsetX,  int visualOffsetY,  double widthScale)  $default,) {final _that = this;
switch (_that) {
case _QuickAccessItem():
return $default(_that.id,_that.title,_that.subtitle,_that.iconName,_that.accent,_that.route,_that.isEnabled,_that.sortOrder,_that.isHidden,_that.visualOffsetX,_that.visualOffsetY,_that.widthScale);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String subtitle,  String iconName,  QuickAccessAccent accent,  String route,  bool isEnabled,  int sortOrder,  bool isHidden,  int visualOffsetX,  int visualOffsetY,  double widthScale)?  $default,) {final _that = this;
switch (_that) {
case _QuickAccessItem() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.iconName,_that.accent,_that.route,_that.isEnabled,_that.sortOrder,_that.isHidden,_that.visualOffsetX,_that.visualOffsetY,_that.widthScale);case _:
  return null;

}
}

}

/// @nodoc


class _QuickAccessItem extends QuickAccessItem {
  const _QuickAccessItem({required this.id, required this.title, this.subtitle = '', required this.iconName, this.accent = QuickAccessAccent.primary, required this.route, this.isEnabled = true, this.sortOrder = 0, this.isHidden = false, this.visualOffsetX = 0, this.visualOffsetY = 0, this.widthScale = 1.0}): super._();
  

@override final  String id;
@override final  String title;
@override@JsonKey() final  String subtitle;
@override final  String iconName;
@override@JsonKey() final  QuickAccessAccent accent;
@override final  String route;
@override@JsonKey() final  bool isEnabled;
@override@JsonKey() final  int sortOrder;
@override@JsonKey() final  bool isHidden;
@override@JsonKey() final  int visualOffsetX;
@override@JsonKey() final  int visualOffsetY;
@override@JsonKey() final  double widthScale;

/// Create a copy of QuickAccessItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickAccessItemCopyWith<_QuickAccessItem> get copyWith => __$QuickAccessItemCopyWithImpl<_QuickAccessItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickAccessItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.accent, accent) || other.accent == accent)&&(identical(other.route, route) || other.route == route)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.visualOffsetX, visualOffsetX) || other.visualOffsetX == visualOffsetX)&&(identical(other.visualOffsetY, visualOffsetY) || other.visualOffsetY == visualOffsetY)&&(identical(other.widthScale, widthScale) || other.widthScale == widthScale));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,iconName,accent,route,isEnabled,sortOrder,isHidden,visualOffsetX,visualOffsetY,widthScale);

@override
String toString() {
  return 'QuickAccessItem(id: $id, title: $title, subtitle: $subtitle, iconName: $iconName, accent: $accent, route: $route, isEnabled: $isEnabled, sortOrder: $sortOrder, isHidden: $isHidden, visualOffsetX: $visualOffsetX, visualOffsetY: $visualOffsetY, widthScale: $widthScale)';
}


}

/// @nodoc
abstract mixin class _$QuickAccessItemCopyWith<$Res> implements $QuickAccessItemCopyWith<$Res> {
  factory _$QuickAccessItemCopyWith(_QuickAccessItem value, $Res Function(_QuickAccessItem) _then) = __$QuickAccessItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String subtitle, String iconName, QuickAccessAccent accent, String route, bool isEnabled, int sortOrder, bool isHidden, int visualOffsetX, int visualOffsetY, double widthScale
});




}
/// @nodoc
class __$QuickAccessItemCopyWithImpl<$Res>
    implements _$QuickAccessItemCopyWith<$Res> {
  __$QuickAccessItemCopyWithImpl(this._self, this._then);

  final _QuickAccessItem _self;
  final $Res Function(_QuickAccessItem) _then;

/// Create a copy of QuickAccessItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? iconName = null,Object? accent = null,Object? route = null,Object? isEnabled = null,Object? sortOrder = null,Object? isHidden = null,Object? visualOffsetX = null,Object? visualOffsetY = null,Object? widthScale = null,}) {
  return _then(_QuickAccessItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,accent: null == accent ? _self.accent : accent // ignore: cast_nullable_to_non_nullable
as QuickAccessAccent,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,visualOffsetX: null == visualOffsetX ? _self.visualOffsetX : visualOffsetX // ignore: cast_nullable_to_non_nullable
as int,visualOffsetY: null == visualOffsetY ? _self.visualOffsetY : visualOffsetY // ignore: cast_nullable_to_non_nullable
as int,widthScale: null == widthScale ? _self.widthScale : widthScale // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
