import 'package:easy_localization/easy_localization.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

extension DateFormatter on DateTime {
  String formatRelative() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(year, month, day);

    final timeStr = DateFormat.Hm().format(this);

    if (dateToCheck == today) {
      return '${LocaleKeys.common_today.tr()}, $timeStr';
    } else if (dateToCheck == yesterday) {
      return '${LocaleKeys.common_yesterday.tr()}, $timeStr';
    } else {
      return DateFormat('dd.MM.yyyy, HH:mm').format(this);
    }
  }
}
