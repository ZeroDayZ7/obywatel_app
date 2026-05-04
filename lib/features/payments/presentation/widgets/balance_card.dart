import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/payments/domain/models/wallet_balance.dart';

class BalanceCard extends StatelessWidget {
  final WalletBalance balance;

  const BalanceCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: isDark ? theme.colorScheme.surfaceContainer : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Twój portfel',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.contactless_outlined, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${balance.total.toStringAsFixed(2)} ${balance.currency}',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _MiniStat(
                icon: Icons.arrow_upward,
                value: balance.incomeToday.toStringAsFixed(0),
                color: Colors.green,
              ),
              const SizedBox(width: 16),
              _MiniStat(
                icon: Icons.arrow_downward,
                value: balance.expenseToday.toStringAsFixed(0),
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _MiniStat({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
