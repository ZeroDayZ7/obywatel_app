// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payments_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaymentsState {

 WalletBalance get balance; List<PaymentTransaction> get transactions; List<QuickAction> get quickActions; bool get isLoading; String? get error;
/// Create a copy of PaymentsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentsStateCopyWith<PaymentsState> get copyWith => _$PaymentsStateCopyWithImpl<PaymentsState>(this as PaymentsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentsState&&(identical(other.balance, balance) || other.balance == balance)&&const DeepCollectionEquality().equals(other.transactions, transactions)&&const DeepCollectionEquality().equals(other.quickActions, quickActions)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,balance,const DeepCollectionEquality().hash(transactions),const DeepCollectionEquality().hash(quickActions),isLoading,error);

@override
String toString() {
  return 'PaymentsState(balance: $balance, transactions: $transactions, quickActions: $quickActions, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class $PaymentsStateCopyWith<$Res>  {
  factory $PaymentsStateCopyWith(PaymentsState value, $Res Function(PaymentsState) _then) = _$PaymentsStateCopyWithImpl;
@useResult
$Res call({
 WalletBalance balance, List<PaymentTransaction> transactions, List<QuickAction> quickActions, bool isLoading, String? error
});


$WalletBalanceCopyWith<$Res> get balance;

}
/// @nodoc
class _$PaymentsStateCopyWithImpl<$Res>
    implements $PaymentsStateCopyWith<$Res> {
  _$PaymentsStateCopyWithImpl(this._self, this._then);

  final PaymentsState _self;
  final $Res Function(PaymentsState) _then;

/// Create a copy of PaymentsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? balance = null,Object? transactions = null,Object? quickActions = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as WalletBalance,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<PaymentTransaction>,quickActions: null == quickActions ? _self.quickActions : quickActions // ignore: cast_nullable_to_non_nullable
as List<QuickAction>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PaymentsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletBalanceCopyWith<$Res> get balance {
  
  return $WalletBalanceCopyWith<$Res>(_self.balance, (value) {
    return _then(_self.copyWith(balance: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaymentsState].
extension PaymentsStatePatterns on PaymentsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentsState value)  $default,){
final _that = this;
switch (_that) {
case _PaymentsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentsState value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WalletBalance balance,  List<PaymentTransaction> transactions,  List<QuickAction> quickActions,  bool isLoading,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentsState() when $default != null:
return $default(_that.balance,_that.transactions,_that.quickActions,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WalletBalance balance,  List<PaymentTransaction> transactions,  List<QuickAction> quickActions,  bool isLoading,  String? error)  $default,) {final _that = this;
switch (_that) {
case _PaymentsState():
return $default(_that.balance,_that.transactions,_that.quickActions,_that.isLoading,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WalletBalance balance,  List<PaymentTransaction> transactions,  List<QuickAction> quickActions,  bool isLoading,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _PaymentsState() when $default != null:
return $default(_that.balance,_that.transactions,_that.quickActions,_that.isLoading,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _PaymentsState implements PaymentsState {
  const _PaymentsState({required this.balance, required final  List<PaymentTransaction> transactions, required final  List<QuickAction> quickActions, this.isLoading = false, this.error}): _transactions = transactions,_quickActions = quickActions;
  

@override final  WalletBalance balance;
 final  List<PaymentTransaction> _transactions;
@override List<PaymentTransaction> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

 final  List<QuickAction> _quickActions;
@override List<QuickAction> get quickActions {
  if (_quickActions is EqualUnmodifiableListView) return _quickActions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_quickActions);
}

@override@JsonKey() final  bool isLoading;
@override final  String? error;

/// Create a copy of PaymentsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentsStateCopyWith<_PaymentsState> get copyWith => __$PaymentsStateCopyWithImpl<_PaymentsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentsState&&(identical(other.balance, balance) || other.balance == balance)&&const DeepCollectionEquality().equals(other._transactions, _transactions)&&const DeepCollectionEquality().equals(other._quickActions, _quickActions)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,balance,const DeepCollectionEquality().hash(_transactions),const DeepCollectionEquality().hash(_quickActions),isLoading,error);

@override
String toString() {
  return 'PaymentsState(balance: $balance, transactions: $transactions, quickActions: $quickActions, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class _$PaymentsStateCopyWith<$Res> implements $PaymentsStateCopyWith<$Res> {
  factory _$PaymentsStateCopyWith(_PaymentsState value, $Res Function(_PaymentsState) _then) = __$PaymentsStateCopyWithImpl;
@override @useResult
$Res call({
 WalletBalance balance, List<PaymentTransaction> transactions, List<QuickAction> quickActions, bool isLoading, String? error
});


@override $WalletBalanceCopyWith<$Res> get balance;

}
/// @nodoc
class __$PaymentsStateCopyWithImpl<$Res>
    implements _$PaymentsStateCopyWith<$Res> {
  __$PaymentsStateCopyWithImpl(this._self, this._then);

  final _PaymentsState _self;
  final $Res Function(_PaymentsState) _then;

/// Create a copy of PaymentsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? balance = null,Object? transactions = null,Object? quickActions = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_PaymentsState(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as WalletBalance,transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<PaymentTransaction>,quickActions: null == quickActions ? _self._quickActions : quickActions // ignore: cast_nullable_to_non_nullable
as List<QuickAction>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PaymentsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletBalanceCopyWith<$Res> get balance {
  
  return $WalletBalanceCopyWith<$Res>(_self.balance, (value) {
    return _then(_self.copyWith(balance: value));
  });
}
}

// dart format on
