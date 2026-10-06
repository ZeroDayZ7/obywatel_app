// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_section.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsSection {

 String get title; List<ActionItem> get items;
/// Create a copy of SettingsSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsSectionCopyWith<SettingsSection> get copyWith => _$SettingsSectionCopyWithImpl<SettingsSection>(this as SettingsSection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsSection&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'SettingsSection(title: $title, items: $items)';
}


}

/// @nodoc
abstract mixin class $SettingsSectionCopyWith<$Res>  {
  factory $SettingsSectionCopyWith(SettingsSection value, $Res Function(SettingsSection) _then) = _$SettingsSectionCopyWithImpl;
@useResult
$Res call({
 String title, List<ActionItem> items
});




}
/// @nodoc
class _$SettingsSectionCopyWithImpl<$Res>
    implements $SettingsSectionCopyWith<$Res> {
  _$SettingsSectionCopyWithImpl(this._self, this._then);

  final SettingsSection _self;
  final $Res Function(SettingsSection) _then;

/// Create a copy of SettingsSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? items = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ActionItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsSection].
extension SettingsSectionPatterns on SettingsSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsSection value)  $default,){
final _that = this;
switch (_that) {
case _SettingsSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsSection value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  List<ActionItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsSection() when $default != null:
return $default(_that.title,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  List<ActionItem> items)  $default,) {final _that = this;
switch (_that) {
case _SettingsSection():
return $default(_that.title,_that.items);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  List<ActionItem> items)?  $default,) {final _that = this;
switch (_that) {
case _SettingsSection() when $default != null:
return $default(_that.title,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsSection implements SettingsSection {
  const _SettingsSection({required this.title, required final  List<ActionItem> items}): _items = items;
  

@override final  String title;
 final  List<ActionItem> _items;
@override List<ActionItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SettingsSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsSectionCopyWith<_SettingsSection> get copyWith => __$SettingsSectionCopyWithImpl<_SettingsSection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsSection&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'SettingsSection(title: $title, items: $items)';
}


}

/// @nodoc
abstract mixin class _$SettingsSectionCopyWith<$Res> implements $SettingsSectionCopyWith<$Res> {
  factory _$SettingsSectionCopyWith(_SettingsSection value, $Res Function(_SettingsSection) _then) = __$SettingsSectionCopyWithImpl;
@override @useResult
$Res call({
 String title, List<ActionItem> items
});




}
/// @nodoc
class __$SettingsSectionCopyWithImpl<$Res>
    implements _$SettingsSectionCopyWith<$Res> {
  __$SettingsSectionCopyWithImpl(this._self, this._then);

  final _SettingsSection _self;
  final $Res Function(_SettingsSection) _then;

/// Create a copy of SettingsSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? items = null,}) {
  return _then(_SettingsSection(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ActionItem>,
  ));
}


}

// dart format on
