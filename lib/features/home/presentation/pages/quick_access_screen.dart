// lib/features/home/presentation/pages/quick_access_screen.dart
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

  static const _contactsItem = QuickAccessItem(
    title: 'Kontakty',
    icon: Icons.badge_outlined,
    accent: QuickAccessAccent.primary,
    route: AppRoutes.contacts,
  );

  static const _communicationItem = QuickAccessItem(
    title: 'Komunikacja',
    subtitle: 'Wiadomości i kontakty',
    icon: Icons.forum_outlined,
    accent: QuickAccessAccent.primary,
    route: AppRoutes.communication,
  );

  static const _liquidDemocracyItem = QuickAccessItem(
    title: 'Płynna Demokracja',
    subtitle: 'Głosowanie i delegacje',
    icon: Icons.how_to_vote_rounded,
    accent: QuickAccessAccent.primary,
    route: AppRoutes.eVoting,
  );

  static final _marketItem = QuickAccessItem(
    title: 'Giełda Zaufania',
    subtitle: 'Rynek reputacji',
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
                  'Szybki dostęp',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: const [
                Expanded(child: _QuickAccessCard(item: _communicationItem)),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _QuickAccessCard(item: _liquidDemocracyItem)),
                const SizedBox(width: 14),
                Expanded(child: _QuickAccessCard(item: _marketItem)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// standardowy kwadratowy kafel
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

    return AspectRatio(
      aspectRatio: 1.05,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.6),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.push(item.route),
              splashColor: accentColor.withValues(alpha: 0.1),
              highlightColor: accentColor.withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: accentColor.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Icon(item.icon, color: accentColor, size: 24),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.subtitle case final subtitle?) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                              fontSize: 12,
                              height: 1.2,
                            ),
                            maxLines: 1,
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
      ),
    );
  }
}

