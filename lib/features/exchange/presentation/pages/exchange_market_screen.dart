import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/tokens/spacing.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/features/exchange/application/exchange_market_provider.dart';
import 'package:obywatel_plus/features/exchange/application/exchange_market_state.dart';
import 'package:obywatel_plus/features/exchange/presentation/widgets/exchange_widgets.dart';

class ExchangeMarketScreen extends ConsumerWidget {
  const ExchangeMarketScreen({super.key});

  static const List<String> filters = [
    'All',
    'Środowisko',
    'Transport',
    'Budżet Obywatelski',
    'Edukacja',
    'Cyfryzacja',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exchangeMarketProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (state.offers.isEmpty) {
      Future.microtask(() => ref.read(exchangeMarketProvider.notifier).load());
    }

    return AppScaffold(
      size: ContainerSize.medium,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go(AppRoutes.home),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          'Giełda Polityków',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      child: _buildContent(context, ref, state, colorScheme),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    ExchangeMarketState state,
    ColorScheme colorScheme,
  ) {
    final theme = Theme.of(context);
    final offers = state.offers;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rynek reputacji i wpływu',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            'Śledź notowania polityków, porównuj zaufanie i analizuj aktywne obszary poparcia.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.xl),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: 'Całkowita moc',
                  value: '${state.stats.totalDelegatedVolume}',
                  subtitle: 'PKT w obrocie',
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: _SummaryCard(
                  title: 'Płynność',
                  value: '${state.stats.liquidityRate.toStringAsFixed(1)}%',
                  subtitle: 'stabilna',
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          _SummaryCard(
            title: 'Aktywni delegaci',
            value: '${state.stats.activeDelegates}',
            subtitle: 'w obiegu w tej chwili',
            color: colorScheme.secondary,
            fullWidth: true,
          ),
          const SizedBox(height: Spacing.xl),
          MarketChartCard(
            stats: state.stats,
            selectedRange: state.selectedRange,
            onRangeChanged: (range) {
              ref.read(exchangeMarketProvider.notifier).setRange(range);
            },
          ),
          const SizedBox(height: Spacing.xl),
          Text(
            'Filtry',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: Spacing.md),
          FilterChipsRow(
            filters: filters,
            activeFilter: state.activeCategory,
            onChanged: (category) {
              ref.read(exchangeMarketProvider.notifier).setCategory(category);
            },
          ),
          const SizedBox(height: Spacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Oferty delegacji',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${offers.length} aktywne',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          if (offers.isEmpty)
            Container(
              padding: const EdgeInsets.all(Spacing.xl),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text('Brak ofert w wybranej kategorii.'),
            )
          else
            ...offers.map((offer) => Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.md),
                  child: DelegationOfferTile(
                    offer: offer,
                    onTap: () => context.push(AppRoutes.eVotingExchangeDetailPath(offer.id)),
                    onDelegate: () => DelegationActionBottomSheet.show(context, ref, offer),
                  ),
                )),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    this.fullWidth = false,
  });

  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
