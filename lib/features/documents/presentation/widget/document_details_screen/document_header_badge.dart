import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';

class DocumentHeaderBadge extends StatelessWidget {
  final DocumentModel doc;
  const DocumentHeaderBadge({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final badgeColor = switch (doc.normalizedStatus) {
      'ACTIVE' => colorScheme.primary,
      'PENDING' => Colors.orange.shade700,
      'EXPIRED' || 'REVOKED' => colorScheme.error,
      _ => colorScheme.onSurfaceVariant,
    };

    final badgeText = switch (doc.normalizedStatus) {
      'ACTIVE' => doc.statusLabel,
      'PENDING' => doc.statusLabel,
      'EXPIRED' => doc.statusLabel,
      'REVOKED' => doc.statusLabel,
      _ => 'STATUS',
    };

    final badgeIcon = switch (doc.normalizedStatus) {
      'ACTIVE' => Icons.verified_user,
      'PENDING' => Icons.pending_actions,
      'EXPIRED' || 'REVOKED' => Icons.gpp_maybe,
      _ => Icons.info_outline,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Icon(
                badgeIcon,
                size: 16,
                color: badgeColor,
              ),
              const SizedBox(width: 6),
              Text(
                badgeText,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: badgeColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.more_vert, color: colorScheme.onSurfaceVariant),
      ],
    );
  }
}
