import 'package:flutter/material.dart';

class AppLanguage {
  final Locale locale;
  final String name;

  const AppLanguage(this.locale, this.name);

  String get code => locale.languageCode;
}

class AppLanguages {
  static final List<AppLanguage> supported = [
    const AppLanguage(Locale('pl'), 'Polski'),
    const AppLanguage(Locale('en'), 'English'),
  ];
}