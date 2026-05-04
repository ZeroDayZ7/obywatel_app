import 'package:obywatel_plus/features/payments/data/repositories/payments_repository_impl.dart';
import 'package:obywatel_plus/features/payments/domain/models/payment_transaction.dart';
import 'package:obywatel_plus/features/payments/domain/models/quick_action.dart';
import 'package:obywatel_plus/features/payments/domain/models/wallet_balance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payments_provider.g.dart';

class PaymentsState {
  final WalletBalance balance;
  final List<PaymentTransaction> transactions;
  final List<QuickAction> quickActions;

  const PaymentsState({
    required this.balance,
    this.transactions = const [],
    this.quickActions = const [],
  });

  PaymentsState copyWith({
    WalletBalance? balance,
    List<PaymentTransaction>? transactions,
    List<QuickAction>? quickActions,
  }) {
    return PaymentsState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      quickActions: quickActions ?? this.quickActions,
    );
  }
}

@riverpod
class Payments extends _$Payments {
  final _repo = PaymentsRepositoryImpl();

  @override
  Future<PaymentsState> build() async {
    final balance = await _repo.getBalance();
    final transactions = await _repo.getTransactions();
    final quickActions = await _repo.getQuickActions();

    return PaymentsState(
      balance: balance,
      transactions: transactions,
      quickActions: quickActions,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final balance = await _repo.getBalance();
      final transactions = await _repo.getTransactions();
      final quickActions = await _repo.getQuickActions();

      return PaymentsState(
        balance: balance,
        transactions: transactions,
        quickActions: quickActions,
      );
    });
  }
}
