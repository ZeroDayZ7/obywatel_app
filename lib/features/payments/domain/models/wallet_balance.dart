import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_balance.freezed.dart';

@freezed
sealed class WalletBalance with _$WalletBalance {
  const factory WalletBalance({
    required double total,
    required double incomeToday,
    required double expenseToday,
    required String currency,
  }) = _WalletBalance;
}
