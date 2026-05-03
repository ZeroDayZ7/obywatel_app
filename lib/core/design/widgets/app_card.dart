import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/tokens/border_radius.dart';

class AppCard extends StatelessWidget {
  final Widget? icon;
  final Widget? topRight;
  final Widget child;
  final Color themeColor;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    this.icon,
    this.topRight,
    required this.child,
    this.themeColor = Colors.blue,
    this.onTap,
    this.width = 180,
    this.height = 125,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: AppRadius.radiusLg,
          border: Border.all(
            color: themeColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null) icon!,
                if (topRight != null) topRight!,
              ],
            ),
            DefaultTextStyle(
              style:
                  theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ) ??
                  const TextStyle(),
              overflow: TextOverflow.ellipsis,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
