import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/theme_extensions.dart';
import 'package:obywatel_plus/features/payments/domain/models/quick_action.dart';

class QuickActionsRow extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActionsRow({super.key, required this.actions});

  Color _mapColor(BuildContext context, String key) {
    final colorScheme = context.colorScheme;
    final statusColors = context.statusColors;

    switch (key) {
      case 'orange':
        return statusColors.warning;
      case 'blue':
        return colorScheme.primary;
      case 'purple':
        return colorScheme.tertiary;
      default:
        return colorScheme.outlineVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((action) {
        final color = _mapColor(context, action.colorKey);

        return Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(action.icon, color: color, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              action.label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        );
      }).toList(),
    );
  }
}
