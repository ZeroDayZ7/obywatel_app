import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/tokens/border_radius.dart';
import 'package:obywatel_plus/features/home/domain/model/action_item.dart';

class ActionItemCard extends StatelessWidget {
  final ActionItem item;

  const ActionItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final badgeColor = item.scope == ActionScope.local
        ? const Color(0xFF00FF88)
        : const Color(0xFF00F0FF);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2638) : Colors.white,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zasięg + Lokalizacja + Typ
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.scope == ActionScope.local
                        ? '📍 LOKALNE'
                        : '🌐 GLOBALNE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                ),
                if (item.locationName != null) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.locationName!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 11,
                        color: theme.textTheme.bodyMedium?.color?.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),

            // Tytuł
            Text(
              item.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            // Opis
            Text(
              item.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13,
                color: theme.textTheme.bodyMedium?.color?.withValues(
                  alpha: 0.8,
                ),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Sekcja z AI Prediction / Podsumowaniem Sądowym
            if (item.aiOutcomePrediction != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: AppRadius.radiusLg,
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.aiOutcomePrediction!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Zdjęcie (jeżeli dołączone, np. do głosowania na ławkę)
            if (item.imageUrl != null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: AppRadius.radiusLg,
                child: Image.network(
                  item.imageUrl!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
