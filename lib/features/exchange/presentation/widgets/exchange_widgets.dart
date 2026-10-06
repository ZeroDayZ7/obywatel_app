import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/theme/app_colors.dart';
import 'package:obywatel_plus/core/design/tokens/border_radius.dart';
import 'package:obywatel_plus/core/design/tokens/spacing.dart';
import 'package:obywatel_plus/core/notifications/feedback_service.dart';
import 'package:obywatel_plus/core/notifications/feedback_type.dart';
import 'package:obywatel_plus/features/exchange/data/models/delegation_offer.dart';
import 'package:obywatel_plus/features/exchange/data/models/market_stats.dart';

class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({
    required this.filters,
    required this.activeFilter,
    required this.onChanged,
    super.key,
  });

  final List<String> filters;
  final String activeFilter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = activeFilter == filter;

          return ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (_) => onChanged(filter),
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
            selectedColor: colorScheme.primary,
            backgroundColor: colorScheme.surfaceContainerHighest,
            side: BorderSide(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
          );
        },
      ),
    );
  }
}

class MarketChartCard extends StatelessWidget {
  const MarketChartCard({
    required this.stats,
    required this.selectedRange,
    required this.onRangeChanged,
    super.key,
  });

  final MarketStats stats;
  final String selectedRange;
  final ValueChanged<String> onRangeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const ranges = ['1D', '1W', '1M', '1Y'];

    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trend rynku delegacji',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: ranges.map((range) {
                  final isSelected = selectedRange == range;
                  return Padding(
                    padding: const EdgeInsets.only(left: Spacing.xs),
                    child: GestureDetector(
                      onTap: () => onRangeChanged(range),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: Spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary.withValues(alpha: 0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Text(
                          range,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: Spacing.lg),
          SizedBox(
            height: 140,
            child: CustomPaint(
              painter: _SparklinePainter(
                values: stats.trendPoints,
                lineColor: colorScheme.primary,
                fillColor: colorScheme.primary.withValues(alpha: 0.15),
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Indeks rynku ${stats.marketIndex.toStringAsFixed(1)}',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '+${stats.liquidityRate.toStringAsFixed(1)}% płynności',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DelegationOfferTile extends StatelessWidget {
  const DelegationOfferTile({
    required this.offer,
    required this.onTap,
    required this.onDelegate,
    super.key,
  });

  final DelegationOffer offer;
  final VoidCallback onTap;
  final VoidCallback onDelegate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
                    child: Text(
                      offer.avatarLabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                offer.delegateName,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (offer.isVerified)
                              Icon(
                                Icons.verified_rounded,
                                size: 18,
                                color: colorScheme.primary,
                              ),
                          ],
                        ),
                        const SizedBox(height: Spacing.xs),
                        Wrap(
                          spacing: Spacing.xs,
                          runSpacing: Spacing.xs,
                          children: [
                            _Badge(label: offer.category, color: colorScheme.primary.withValues(alpha: 0.12)),
                            _Badge(label: offer.badge, color: colorScheme.secondary.withValues(alpha: 0.12)),
                            _Badge(label: offer.liquidityStatus, color: AppColors.success.withValues(alpha: 0.12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _StatPill(
                      label: 'Moc głosu',
                      value: '${offer.votingPower} pkt',
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: _StatPill(
                      label: 'Zaufanie',
                      value: '${offer.reputation.toStringAsFixed(0)}%',
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.md),
              Text(
                offer.strategyDescription,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.md),
              Row(
                children: [
                  Icon(Icons.trending_up_rounded, size: 16, color: AppColors.success),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    'Historie +${offer.historicalYield.toStringAsFixed(1)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    offer.fee == 0 ? 'Opłata: 0 PLN' : 'Opłata: ${offer.fee} CIVIC',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.md),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Aktywne wnioski: ${offer.activeProposals.join(', ')}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  FilledButton.icon(
                    onPressed: onDelegate,
                    icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                    label: const Text('Deleguj'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DelegationActionBottomSheet extends ConsumerWidget {
  const DelegationActionBottomSheet({
    required this.offer,
    super.key,
  });

  final DelegationOffer offer;

  static Future<void> show(BuildContext context, WidgetRef ref, DelegationOffer offer) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DelegationActionBottomSheet(offer: offer),
    ).then((_) {
      ref.read(feedbackServiceProvider).trigger(FeedbackType.info);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ranges = [250, 500, 750, 1000, 1250];
    final selected = offer.votingPower < 1000 ? 500 : 750;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: Spacing.xl),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            var chosenPower = selected;

            return Padding(
              padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.xl, Spacing.lg, Spacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.xl),
                  Text(
                    'Deleguj głos do ${offer.delegateName}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    'Wybierz moc delegacji dla tej oferty lub wyznacz konkretny obszar polityki.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: Spacing.xl),
                  Container(
                    padding: const EdgeInsets.all(Spacing.md),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Moc delegacji'),
                            Text(
                              '$chosenPower pkt',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Spacing.sm),
                        Slider(
                          value: chosenPower.toDouble(),
                          min: 250,
                          max: offer.votingPower.toDouble(),
                          divisions: 4,
                          onChanged: (value) {
                            setState(() => chosenPower = value.round());
                          },
                        ),
                        Wrap(
                          spacing: Spacing.xs,
                          children: ranges
                              .where((element) => element <= offer.votingPower)
                              .map(
                                (value) => FilterChip(
                                  label: Text('$value'),
                                  selected: chosenPower == value,
                                  onSelected: (_) => setState(() => chosenPower = value),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Wrap(
                    spacing: Spacing.sm,
                    runSpacing: Spacing.sm,
                    children: [
                      _Badge(label: offer.category, color: colorScheme.primary.withValues(alpha: 0.12)),
                      _Badge(label: 'Czysta delegacja', color: colorScheme.secondary.withValues(alpha: 0.12)),
                    ],
                  ),
                  const SizedBox(height: Spacing.xl),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Anuluj'),
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            ref.read(feedbackServiceProvider).trigger(FeedbackType.success);
                          },
                          child: const Text('Potwierdź'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({
    required this.values,
    required this.lineColor,
    required this.fillColor,
  });

  final List<double> values;
  final Color lineColor;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) {
      return;
    }

    final normalized = <Offset>[];
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final span = max - min == 0 ? 1.0 : max - min;

    for (var i = 0; i < values.length; i++) {
      final progress = values.length == 1 ? 0.0 : i / (values.length - 1);
      final x = progress * size.width;
      final y = size.height - ((values[i] - min) / span) * size.height * 0.9;
      normalized.add(Offset(x, y));
    }

    final linePath = Path()..moveTo(normalized.first.dx, normalized.first.dy);
    for (var i = 1; i < normalized.length; i++) {
      linePath.lineTo(normalized[i].dx, normalized[i].dy);
    }

    final areaPath = Path.from(linePath)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()..color = fillColor;
    canvas.drawPath(areaPath, fillPaint);

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor;
  }
}
