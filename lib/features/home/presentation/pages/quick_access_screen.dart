// lib/features/home/presentation/pages/quick_access_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/home_app_bar.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/main_drawer.dart';

enum QuickAccessAccent { primary, secondary, tertiary, error }

class QuickAccessItem {
  final String title;
  final String? subtitle;
  final IconData icon;
  final QuickAccessAccent accent;
  final String route;

  const QuickAccessItem({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.accent,
    required this.route,
  });
}

class QuickAccessScreen extends StatelessWidget {
  const QuickAccessScreen({super.key});

  static const _communicationItem = QuickAccessItem(
    title: 'quick_access.communication',
    subtitle: 'quick_access.communication_subtitle',
    icon: Icons.forum_outlined,
    accent: QuickAccessAccent.primary,
    route: AppRoutes.communication,
  );

  static const _liquidDemocracyItem = QuickAccessItem(
    title: 'quick_access.liquid_democracy',
    subtitle: 'quick_access.liquid_democracy_subtitle',
    icon: Icons.how_to_vote_rounded,
    accent: QuickAccessAccent.primary,
    route: AppRoutes.eVoting,
  );

  static final _marketItem = QuickAccessItem(
    title: 'quick_access.trust_exchange',
    subtitle: 'quick_access.trust_exchange_subtitle',
    icon: Icons.trending_up_rounded,
    accent: QuickAccessAccent.tertiary,
    route: AppRoutes.eVotingExchangePath(),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScaffold(
      appBar: const HomeAppBar(),
      drawer: const MainDrawer(),
      size: ContainerSize.medium,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.bolt_rounded,
                    color: colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'quick_access.title'.tr(),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(child: _QuickAccessCard(item: _communicationItem)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _QuickAccessCard(item: _liquidDemocracyItem)),
                const SizedBox(width: 10),
                Expanded(child: _QuickAccessCard(item: _marketItem)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final QuickAccessItem item;

  const _QuickAccessCard({required this.item});

  Color _resolveAccentColor(ColorScheme colorScheme) {
    return switch (item.accent) {
      QuickAccessAccent.primary => colorScheme.primary,
      QuickAccessAccent.secondary => colorScheme.secondary,
      QuickAccessAccent.tertiary => colorScheme.tertiary,
      QuickAccessAccent.error => colorScheme.error,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = _resolveAccentColor(colorScheme);

    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push(item.route),
            splashColor: accentColor.withValues(alpha: 0.1),
            highlightColor: accentColor.withValues(alpha: 0.05),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(item.icon, color: accentColor, size: 20),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title.tr(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.subtitle case final subtitle?) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle.tr(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}