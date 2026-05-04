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

  static final transactions = [
    PaymentTransaction(
      id: 'tx_1',
      title: 'Biedronka - zakupy',
      amount: -124.30,
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.expense,
      category: TransactionCategory.shopping,
    ),
    PaymentTransaction(
      id: 'tx_2',
      title: 'Wypłata - firma XYZ',
      amount: 8500.00,
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: TransactionType.income,
      category: TransactionCategory.salary,
    ),
    PaymentTransaction(
      id: 'tx_3',
      title: 'ZUS składka',
      amount: -1450.00,
      date: DateTime.now().subtract(const Duration(days: 3)),
      type: TransactionType.expense,
      category: TransactionCategory.tax,
    ),
    PaymentTransaction(
      id: 'tx_4',
      title: 'Zwrot podatku 2025',
      amount: 2150.00,
      date: DateTime.now().subtract(const Duration(days: 4)),
      type: TransactionType.income,
      category: TransactionCategory.refund,
    ),
    PaymentTransaction(
      id: 'tx_5',
      title: 'Netflix subscription',
      amount: -49.99,
      date: DateTime.now().subtract(const Duration(days: 5)),
      type: TransactionType.expense,
      category: TransactionCategory.subscription,
    ),
    PaymentTransaction(
      id: 'tx_6',
      title: 'Przelew od Jan Kowalski',
      amount: 300.00,
      date: DateTime.now().subtract(const Duration(days: 6)),
      type: TransactionType.income,
      category: TransactionCategory.transfer,
    ),
    PaymentTransaction(
      id: 'tx_7',
      title: 'Żabka - szybkie zakupy',
      amount: -18.70,
      date: DateTime.now().subtract(const Duration(days: 7)),
      type: TransactionType.expense,
      category: TransactionCategory.shopping,
    ),
    PaymentTransaction(
      id: 'tx_8',
      title: 'Pensja - bonus kwartalny',
      amount: 12000.00,
      date: DateTime.now().subtract(const Duration(days: 8)),
      type: TransactionType.income,
      category: TransactionCategory.salary,
    ),
  ];
}
