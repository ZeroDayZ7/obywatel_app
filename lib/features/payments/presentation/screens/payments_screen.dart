import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/design/widgets/app_bar.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
import 'package:obywatel_plus/features/payments/application/payments_provider.dart';
import 'package:obywatel_plus/features/payments/presentation/widgets/balance_card.dart';
import 'package:obywatel_plus/features/payments/presentation/widgets/quick_actions_row.dart';
import 'package:obywatel_plus/features/payments/presentation/widgets/transaction_tile.dart';

class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(paymentsProvider);

    return AppScaffold(
      appBar: AppAppBar(
        title: 'Finanse',
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.analytics_outlined),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      child: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (state) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BalanceCard(balance: state.balance),
                      const SizedBox(height: 32),

                      const Text(
                        'Szybkie akcje',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),

                      QuickActionsRow(actions: state.quickActions),

                      const SizedBox(height: 32),

                      const Text(
                        'Ostatnie operacje',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return TransactionTile(
                    transaction: state.transactions[index],
                  );
                }, childCount: state.transactions.length),
              ),
            ],
          );
        },
      ),
    );
  }
}
