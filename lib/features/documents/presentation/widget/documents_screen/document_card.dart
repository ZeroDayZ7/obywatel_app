import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/extensions/status_colors_theme.dart';

class DocumentCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isVerified;
  final String? status;

  const DocumentCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isVerified = false,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final normalizedStatus = (status ?? '').toUpperCase();
    final displayStatus = switch (normalizedStatus) {
      'ACTIVE' => 'Ważny',
      'PENDING' => 'Oczekujący',
      'EXPIRED' => 'Wygasły',
      'REVOKED' => 'Unieważniony',
      _ => 'Nieznany',
    };
    final isInactive = normalizedStatus == 'PENDING' ||
        normalizedStatus == 'EXPIRED' ||
        normalizedStatus == 'REVOKED';

    final statusColors = theme.extension<StatusColorsTheme>() ??
        StatusColorsTheme.fromColorScheme(colorScheme);
    final badgeColor = switch (normalizedStatus) {
      'ACTIVE' => colorScheme.primary,
      'PENDING' => statusColors.warning,
      'EXPIRED' || 'REVOKED' => colorScheme.error,
      _ => colorScheme.onSurfaceVariant,
    };

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: normalizedStatus == 'EXPIRED' || normalizedStatus == 'REVOKED' ? 0.7 : 1,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isInactive
                  ? badgeColor.withValues(alpha: 0.5)
                  : colorScheme.outlineVariant.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: isInactive ? badgeColor : colorScheme.primary, size: 32),
                  if (isVerified)
                    Icon(Icons.verified, color: colorScheme.primary, size: 20),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (status != null && status!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      displayStatus,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: badgeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
