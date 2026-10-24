// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_access_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuickAccessState {

 List<QuickAccessItem> get items;
/// Create a copy of QuickAccessState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickAccessStateCopyWith<QuickAccessState> get copyWith => _$QuickAccessStateCopyWithImpl<QuickAccessState>(this as QuickAccessState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickAccessState&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'QuickAccessState(items: $items)';
}


}

/// @nodoc
abstract mixin class $QuickAccessStateCopyWith<$Res>  {
  factory $QuickAccessStateCopyWith(QuickAccessState value, $Res Function(QuickAccessState) _then) = _$QuickAccessStateCopyWithImpl;
@useResult
$Res call({
 List<QuickAccessItem> items
});




}
/// @nodoc
class _$QuickAccessStateCopyWithImpl<$Res>
    implements $QuickAccessStateCopyWith<$Res> {
  _$QuickAccessStateCopyWithImpl(this._self, this._then);

  final QuickAccessState _self;
  final $Res Function(QuickAccessState) _then;

/// Create a copy of QuickAccessState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<QuickAccessItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickAccessState].
extension QuickAccessStatePatterns on QuickAccessState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickAccessState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickAccessState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickAccessState value)  $default,){
final _that = this;
switch (_that) {
case _QuickAccessState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickAccessState value)?  $default,){
final _that = this;
switch (_that) {
case _QuickAccessState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<QuickAccessItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickAccessState() when $default != null:
return $default(_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<QuickAccessItem> items)  $default,) {final _that = this;
switch (_that) {
case _QuickAccessState():
return $default(_that.items);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<QuickAccessItem> items)?  $default,) {final _that = this;
switch (_that) {
case _QuickAccessState() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _QuickAccessState implements QuickAccessState {
  const _QuickAccessState({final  List<QuickAccessItem> items = const <QuickAccessItem>[]}): _items = items;
  

 final  List<QuickAccessItem> _items;
@override@JsonKey() List<QuickAccessItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of QuickAccessState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickAccessStateCopyWith<_QuickAccessState> get copyWith => __$QuickAccessStateCopyWithImpl<_QuickAccessState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickAccessState&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'QuickAccessState(items: $items)';
}


}

/// @nodoc
abstract mixin class _$QuickAccessStateCopyWith<$Res> implements $QuickAccessStateCopyWith<$Res> {
  factory _$QuickAccessStateCopyWith(_QuickAccessState value, $Res Function(_QuickAccessState) _then) = __$QuickAccessStateCopyWithImpl;
@override @useResult
$Res call({
 List<QuickAccessItem> items
});




}
/// @nodoc
class __$QuickAccessStateCopyWithImpl<$Res>
    implements _$QuickAccessStateCopyWith<$Res> {
  __$QuickAccessStateCopyWithImpl(this._self, this._then);

  final _QuickAccessState _self;
  final $Res Function(_QuickAccessState) _then;

/// Create a copy of QuickAccessState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_QuickAccessState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<QuickAccessItem>,
  ));
}


}

// dart format on
