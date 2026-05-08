import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/config/generated/assets.gen.dart';

class LangConfig {
  const LangConfig._();

  static const String codePL = 'pl';
  static const String codeEN = 'en';

  static const List<Locale> supportedLocales = [Locale(codePL), Locale(codeEN)];

  static const Locale fallbackLocale = Locale(codePL);

  static String get translationsPath {
    final fullPath = Assets.translations.pl;
    return fullPath.substring(0, fullPath.lastIndexOf('/'));
  }
}
