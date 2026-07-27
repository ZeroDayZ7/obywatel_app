import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/home_app_bar.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/main_drawer.dart';

class QuickAccessItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String route;

  const QuickAccessItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.route,
  });
}

class QuickAccessScreen extends StatelessWidget {
  const QuickAccessScreen({super.key});

  static const List<QuickAccessItem> _items = [
    QuickAccessItem(
      title: 'Dokumenty',
      subtitle: 'Dowód, prawo jazdy',
      icon: Icons.badge_outlined,
      iconColor: Color(0xFF26C6DA),
      route: AppRoutes.documents,
    ),
    QuickAccessItem(
      title: 'Wiadomości',
      subtitle: 'Czat i zgłoszenia',
      icon: Icons.chat_bubble_outline_rounded,
      iconColor: Color(0xFF42A5F5),
      route: AppRoutes.chats,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      appBar: const HomeAppBar(),
      drawer: const MainDrawer(),
      size: ContainerSize.medium,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bolt_rounded,
                  color: Colors.amber.shade600,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  'Szybki dostęp',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
  
            const SizedBox(height: 20),

            // Grid 2x2 na 4 skróty
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final item = _items[index];
                return _buildQuickAccessCard(context, item);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessCard(BuildContext context, QuickAccessItem item) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => context.go(item.route),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item.iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 26),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
