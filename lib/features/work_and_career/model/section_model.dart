import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';

class Section {
  final IconData icon;
  final String titleKey;
  final String route;

  Section({
    required this.icon,
    required this.titleKey,
    required this.route,
  });

  /// Getter który automatycznie zwraca przetłumaczony tytuł
  // String get title => titleKey.tr();
}
