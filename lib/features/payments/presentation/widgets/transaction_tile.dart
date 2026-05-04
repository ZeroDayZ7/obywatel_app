import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/payments/domain/enums/transaction_type.dart';
import 'package:obywatel_plus/features/payments/domain/models/payment_transaction.dart';

class TransactionTile extends StatelessWidget {
  final PaymentTransaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isExpense = transaction.type == TransactionType.expense;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.5,
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isExpense
              ? Icons.shopping_bag_outlined
              : Icons.account_balance_wallet_outlined,
          size: 20,
        ),
      ),
      title: Text(
        transaction.title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Text(
        _formatDate(transaction.date),
        style: theme.textTheme.bodySmall,
      ),
      trailing: Text(
        _formatAmount(transaction.amount),
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 15,
          color: isExpense ? Colors.red : Colors.green,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  String _formatAmount(double amount) {
    final sign = amount >= 0 ? '+' : '-';
    return '$sign${amount.abs().toStringAsFixed(2)} PLN';
  }
}
