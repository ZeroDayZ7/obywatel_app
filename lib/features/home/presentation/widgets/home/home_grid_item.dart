import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/tokens/border_radius.dart';
import 'package:obywatel_plus/core/design/widgets/ui/badge.dart';

class HomeGridItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int? badgeCount;
  final VoidCallback onTap;
  final bool isEnabled;

  const HomeGridItem({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    this.badgeCount,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final adjustedColor =
        Color.lerp(
          color,
          theme.colorScheme.onSurface,
          theme.brightness == Brightness.dark ? 0.2 : 0.0,
        ) ??
        color;

    final finalColor = isEnabled ? adjustedColor : theme.disabledColor;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: isEnabled ? 1 : 0.5,
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
                  color: finalColor.withValues(alpha: 0.12),
                  border: Border.all(color: finalColor.withValues(alpha: 0.2)),
                ),
                child: Icon(icon, size: 28, color: finalColor),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                letterSpacing: 0.2,
                color: isEnabled ? null : theme.disabledColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
