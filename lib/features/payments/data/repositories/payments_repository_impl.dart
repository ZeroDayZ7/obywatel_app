import 'package:obywatel_plus/features/payments/data/mocks/payments_mock.dart';
import 'package:obywatel_plus/features/payments/domain/models/payment_transaction.dart';
import 'package:obywatel_plus/features/payments/domain/models/quick_action.dart';
import 'package:obywatel_plus/features/payments/domain/models/wallet_balance.dart';
import 'package:obywatel_plus/features/payments/domain/repositories/payments_repository.dart';

class PaymentsRepositoryImpl implements PaymentsRepository {
  @override
  Future<WalletBalance> getBalance() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return PaymentsMock.balance;
  }

  @override
  Future<List<PaymentTransaction>> getTransactions() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return PaymentsMock.transactions;
  }

  @override
  Future<List<QuickAction>> getQuickActions() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return PaymentsMock.quickActions;
  }
}