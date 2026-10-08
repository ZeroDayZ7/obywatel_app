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

  static const _communicationItem = QuickAccessItem(
    title: 'Komunikacja',
    subtitle: 'Wiadomości i kontakty',
    icon: Icons.forum_outlined,
    accent: QuickAccessAccent.primary,
    route: AppRoutes.communication,
  );

  static const _documentsItem = QuickAccessItem(
    title: 'Dokumenty',
    subtitle: 'Dokumenty i eID',
    icon: Icons.description_outlined,
    accent: QuickAccessAccent.secondary,
    route: AppRoutes.documents,
  );

  static const _servicesItem = QuickAccessItem(
    title: 'Usługi',
    subtitle: 'Najczęstsze działania',
    icon: Icons.grid_view_rounded,
    accent: QuickAccessAccent.tertiary,
    route: AppRoutes.services,
  );

  static const _notificationsItem = QuickAccessItem(
    title: 'Powiadomienia',
    subtitle: 'Aktualności i alerty',
    icon: Icons.notifications_none_rounded,
    accent: QuickAccessAccent.error,
    route: AppRoutes.notifications,
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compactMode = constraints.maxWidth < 620;
          final leftItems = <QuickAccessItem>[
            _communicationItem,
            _servicesItem,
            _liquidDemocracyItem,
          ];
          final rightItems = <QuickAccessItem>[
            _documentsItem,
            _notificationsItem,
            _marketItem,
          ];

          final wallColumns = compactMode
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (final item in [...leftItems, ...rightItems])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _QuickAccessWallTile(item: item),
                      ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final item in leftItems)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _QuickAccessWallTile(item: item),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          for (final item in rightItems)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _QuickAccessWallTile(item: item),
                            ),
                        ],
                      ),
                    ),
                  ],
                );

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1040),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
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
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    wallColumns,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuickAccessWallTile extends StatelessWidget {
  final QuickAccessItem item;

  const _QuickAccessWallTile({required this.item});

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

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 360,
        minHeight: 122,
      ),
      child: SizedBox(
        width: 320,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => context.push(item.route),
              splashColor: accentColor.withValues(alpha: 0.12),
              highlightColor: accentColor.withValues(alpha: 0.06),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(item.icon, color: accentColor, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          if (item.subtitle case final subtitle?)
                            Text(
                              subtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.72),
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: colorScheme.onSurface.withValues(alpha: 0.42),
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

