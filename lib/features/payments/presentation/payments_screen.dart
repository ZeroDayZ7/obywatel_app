import 'package:flutter/material.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finanse'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ModernBalanceCard(isDark: isDark),
                  const SizedBox(height: 32),
                  _buildSectionHeader(theme, 'Szybkie akcje'),
                  const SizedBox(height: 16),
                  _QuickActionsRow(),
                  const SizedBox(height: 32),
                  _buildSectionHeader(theme, 'Ostatnie operacje'),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _TransactionTile(index: index),
                childCount: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _ModernBalanceCard extends StatelessWidget {
  final bool isDark;
  const _ModernBalanceCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: isDark ? theme.colorScheme.surfaceContainer : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:isDark ? 0.3 : 0.05),
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
            '12 480,50 PLN',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildMiniStat(Icons.arrow_upward, '1.2k', Colors.green),
              const SizedBox(width: 16),
              _buildMiniStat(Icons.arrow_downward, '0.8k', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value, Color color) {
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

class _QuickActionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ActionItem(
          icon: Icons.qr_code_2,
          label: 'Skanuj',
          color: Colors.orange,
        ),
        _ActionItem(
          icon: Icons.send_rounded,
          label: 'Przelew',
          color: Colors.blue,
        ),
        _ActionItem(
          icon: Icons.add_moderator,
          label: 'Doładuj',
          color: Colors.purple,
        ),
        _ActionItem(
          icon: Icons.more_horiz,
          label: 'Więcej',
          color: Colors.grey,
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: color.withValues(alpha:isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final int index;
  const _TransactionTile({required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNegative = index % 2 == 0;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha:0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isNegative
              ? Icons.shopping_bag_outlined
              : Icons.account_balance_wallet_outlined,
          size: 20,
        ),
      ),
      title: Text(
        isNegative ? 'Supermarket "Eco"' : 'Zwrot podatku',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Text('24 Kwietnia, 2026', style: theme.textTheme.bodySmall),
      trailing: Text(
        isNegative ? '-124,00 PLN' : '+2 150,00 PLN',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 15,
          color: isNegative ? null : Colors.green,
        ),
      ),
    );
  }
}
