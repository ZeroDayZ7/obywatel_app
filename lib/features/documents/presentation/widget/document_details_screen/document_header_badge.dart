import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/documents/domain/models/document_model.dart';

class DocumentHeaderBadge extends StatelessWidget {
  final DocumentModel doc;
  const DocumentHeaderBadge({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isVerified = doc.isVerified;

    final badgeColor = isVerified ? colorScheme.primary : colorScheme.error;
    final badgeText = isVerified ? 'DOKUMENT WAŻNY' : 'NIEAKTYWNY';

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
                isVerified ? Icons.verified_user : Icons.gpp_maybe,
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
