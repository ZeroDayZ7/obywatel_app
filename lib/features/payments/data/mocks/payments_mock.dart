import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/payments/domain/enums/quick_action_type.dart';
import 'package:obywatel_plus/features/payments/domain/enums/transaction_category.dart';
import 'package:obywatel_plus/features/payments/domain/enums/transaction_type.dart';
import 'package:obywatel_plus/features/payments/domain/models/payment_transaction.dart';
import 'package:obywatel_plus/features/payments/domain/models/quick_action.dart';
import 'package:obywatel_plus/features/payments/domain/models/wallet_balance.dart';

class PaymentsMock {
  static final balance = WalletBalance(
    total: 12480.50,
    incomeToday: 2150.00,
    expenseToday: 840.00,
    currency: 'PLN',
  );

  static final quickActions = [
    const QuickAction(
      id: 'qa_1',
      label: 'Skanuj',
      type: QuickActionType.scanQr,
      icon: Icons.qr_code_2,
      colorKey: 'orange',
    ),
    const QuickAction(
      id: 'qa_2',
      label: 'Przelew',
      type: QuickActionType.transfer,
      icon: Icons.send_rounded,
      colorKey: 'blue',
    ),
    const QuickAction(
      id: 'qa_3',
      label: 'Doładuj',
      type: QuickActionType.topUp,
      icon: Icons.add_card,
      colorKey: 'purple',
    ),
    const QuickAction(
      id: 'qa_4',
      label: 'Więcej',
      type: QuickActionType.more,
      icon: Icons.more_horiz,
      colorKey: 'grey',
    ),
  ];

  static final transactions = List.generate(
    12,
    (index) => PaymentTransaction(
      id: 'tx_$index',
      title: index % 2 == 0 ? 'Supermarket Eco' : 'Zwrot podatku',
      amount: index % 2 == 0 ? -124.00 - index : 2150.00 + index * 10,
      date: DateTime.now().subtract(Duration(days: index)),
      type: index % 2 == 0 ? TransactionType.expense : TransactionType.income,
      category: index % 2 == 0
          ? TransactionCategory.shopping
          : TransactionCategory.refund,
    ),
  );
}
