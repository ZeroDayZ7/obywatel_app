import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:obywatel_plus/app/theme/theme_extensions.dart';

class DocumentExpiryBadge extends StatelessWidget {
  final String date;

  const DocumentExpiryBadge({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDisplayDate(date);
    final statusColors = context.statusColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_available, size: 18, color: statusColors.warning),
          const SizedBox(width: 8),
          Text(
            'Wygasa: $formattedDate',
            style: TextStyle(
              color: statusColors.warning,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDisplayDate(String rawDate) {
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) {
      return rawDate;
    }
    return DateFormat('dd.MM.yyyy', 'pl').format(parsed);
  }
}
