import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/features/payments/domain/enums/transaction_category.dart';
import 'package:obywatel_plus/features/payments/domain/enums/transaction_type.dart';

part 'payment_transaction.freezed.dart';

@freezed
sealed class PaymentTransaction with _$PaymentTransaction {
  const factory PaymentTransaction({
    required String id,
    required String title,
    required double amount,
    required DateTime date,
    required TransactionType type,
    required TransactionCategory category,
  }) = _PaymentTransaction;
}
