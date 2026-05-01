import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/tokens/border_radius.dart';
import 'package:obywatel_plus/core/design/widgets/badge.dart';

class HomeGridItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int? badgeCount;
  final VoidCallback onTap;

  const HomeGridItem({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final adjustedColor = Color.lerp(
          color,
          theme.colorScheme.onSurface,
          theme.brightness == Brightness.dark ? 0.2 : 0.0,
        ) ??
        color;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppBadge(
            count: badgeCount ?? 0,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: AppRadius.radiusLg,
                color: adjustedColor.withValues(alpha: 0.12),
                border: Border.all(
                  color: adjustedColor.withValues(alpha: 0.2),
                ),
              ),
              child: Icon(icon, size: 28, color: adjustedColor),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              letterSpacing: 0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}