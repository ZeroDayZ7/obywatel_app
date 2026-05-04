import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/features/payments/domain/models/payment_transaction.dart';
import 'package:obywatel_plus/features/payments/domain/models/quick_action.dart';
import 'package:obywatel_plus/features/payments/domain/models/wallet_balance.dart';

part 'payments_state.freezed.dart';

@freezed
sealed class PaymentsState with _$PaymentsState {
  const factory PaymentsState({
    required WalletBalance balance,
    required List<PaymentTransaction> transactions,
    required List<QuickAction> quickActions,
    @Default(false) bool isLoading,
    String? error,
  }) = _PaymentsState;
}
