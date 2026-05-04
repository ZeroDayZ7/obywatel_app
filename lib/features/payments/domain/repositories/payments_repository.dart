import 'package:obywatel_plus/features/payments/domain/models/payment_transaction.dart';
import 'package:obywatel_plus/features/payments/domain/models/quick_action.dart';
import 'package:obywatel_plus/features/payments/domain/models/wallet_balance.dart';

abstract class PaymentsRepository {
  Future<WalletBalance> getBalance();
  Future<List<PaymentTransaction>> getTransactions();
  Future<List<QuickAction>> getQuickActions();
}
