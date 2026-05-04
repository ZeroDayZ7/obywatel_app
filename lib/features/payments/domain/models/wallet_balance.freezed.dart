// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_balance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalletBalance {

 double get total; double get incomeToday; double get expenseToday; String get currency;
/// Create a copy of WalletBalance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletBalanceCopyWith<WalletBalance> get copyWith => _$WalletBalanceCopyWithImpl<WalletBalance>(this as WalletBalance, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletBalance&&(identical(other.total, total) || other.total == total)&&(identical(other.incomeToday, incomeToday) || other.incomeToday == incomeToday)&&(identical(other.expenseToday, expenseToday) || other.expenseToday == expenseToday)&&(identical(other.currency, currency) || other.currency == currency));
}


@override
int get hashCode => Object.hash(runtimeType,total,incomeToday,expenseToday,currency);

@override
String toString() {
  return 'WalletBalance(total: $total, incomeToday: $incomeToday, expenseToday: $expenseToday, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $WalletBalanceCopyWith<$Res>  {
  factory $WalletBalanceCopyWith(WalletBalance value, $Res Function(WalletBalance) _then) = _$WalletBalanceCopyWithImpl;
@useResult
$Res call({
 double total, double incomeToday, double expenseToday, String currency
});




}
/// @nodoc
class _$WalletBalanceCopyWithImpl<$Res>
    implements $WalletBalanceCopyWith<$Res> {
  _$WalletBalanceCopyWithImpl(this._self, this._then);

  final WalletBalance _self;
  final $Res Function(WalletBalance) _then;

/// Create a copy of WalletBalance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? incomeToday = null,Object? expenseToday = null,Object? currency = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,incomeToday: null == incomeToday ? _self.incomeToday : incomeToday // ignore: cast_nullable_to_non_nullable
as double,expenseToday: null == expenseToday ? _self.expenseToday : expenseToday // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletBalance].
extension WalletBalancePatterns on WalletBalance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletBalance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletBalance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletBalance value)  $default,){
final _that = this;
switch (_that) {
case _WalletBalance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletBalance value)?  $default,){
final _that = this;
switch (_that) {
case _WalletBalance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double total,  double incomeToday,  double expenseToday,  String currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletBalance() when $default != null:
return $default(_that.total,_that.incomeToday,_that.expenseToday,_that.currency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double total,  double incomeToday,  double expenseToday,  String currency)  $default,) {final _that = this;
switch (_that) {
case _WalletBalance():
return $default(_that.total,_that.incomeToday,_that.expenseToday,_that.currency);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double total,  double incomeToday,  double expenseToday,  String currency)?  $default,) {final _that = this;
switch (_that) {
case _WalletBalance() when $default != null:
return $default(_that.total,_that.incomeToday,_that.expenseToday,_that.currency);case _:
  return null;

}
}

}

/// @nodoc


class _WalletBalance implements WalletBalance {
  const _WalletBalance({required this.total, required this.incomeToday, required this.expenseToday, required this.currency});
  

@override final  double total;
@override final  double incomeToday;
@override final  double expenseToday;
@override final  String currency;

/// Create a copy of WalletBalance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletBalanceCopyWith<_WalletBalance> get copyWith => __$WalletBalanceCopyWithImpl<_WalletBalance>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletBalance&&(identical(other.total, total) || other.total == total)&&(identical(other.incomeToday, incomeToday) || other.incomeToday == incomeToday)&&(identical(other.expenseToday, expenseToday) || other.expenseToday == expenseToday)&&(identical(other.currency, currency) || other.currency == currency));
}


@override
int get hashCode => Object.hash(runtimeType,total,incomeToday,expenseToday,currency);

@override
String toString() {
  return 'WalletBalance(total: $total, incomeToday: $incomeToday, expenseToday: $expenseToday, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$WalletBalanceCopyWith<$Res> implements $WalletBalanceCopyWith<$Res> {
  factory _$WalletBalanceCopyWith(_WalletBalance value, $Res Function(_WalletBalance) _then) = __$WalletBalanceCopyWithImpl;
@override @useResult
$Res call({
 double total, double incomeToday, double expenseToday, String currency
});




}
/// @nodoc
class __$WalletBalanceCopyWithImpl<$Res>
    implements _$WalletBalanceCopyWith<$Res> {
  __$WalletBalanceCopyWithImpl(this._self, this._then);

  final _WalletBalance _self;
  final $Res Function(_WalletBalance) _then;

/// Create a copy of WalletBalance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? incomeToday = null,Object? expenseToday = null,Object? currency = null,}) {
  return _then(_WalletBalance(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,incomeToday: null == incomeToday ? _self.incomeToday : incomeToday // ignore: cast_nullable_to_non_nullable
as double,expenseToday: null == expenseToday ? _self.expenseToday : expenseToday // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
