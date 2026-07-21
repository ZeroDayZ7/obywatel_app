import 'package:easy_localization/easy_localization.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

abstract class DateFormatter {
  /// Formatuję datę/timestamp w postaci ciągu tekstowego (ISO 8601 lub millis).
  /// Automatycznie oczyszcza ciąg ze spacji i białych znaków (.trim()).
  static String formatRelativeDateTime(String rawDate) {
    final cleanDate = rawDate.trim();
    if (cleanDate.isEmpty) {
      return rawDate;
    }

    final parsedDate =
        DateTime.tryParse(cleanDate) ??
        DateTime.fromMillisecondsSinceEpoch(int.tryParse(cleanDate) ?? 0);

    if (parsedDate.millisecondsSinceEpoch == 0) {
      return rawDate;
    }

    return parsedDate.formatRelative();
  }
}

extension DateFormatterExtension on DateTime {
  /// Formatuję instancję DateTime względem dzisiejszego dnia.
  String formatRelative() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkDate = DateTime(year, month, day);

    final timeStr = DateFormat.Hm().format(this);

    if (checkDate == today) {
      return '${LocaleKeys.common_today.tr()}, $timeStr';
    } else if (checkDate == yesterday) {
      return '${LocaleKeys.common_yesterday.tr()}, $timeStr';
    } else {
      return DateFormat('dd.MM.yyyy, HH:mm').format(this);
    }
  }
}
