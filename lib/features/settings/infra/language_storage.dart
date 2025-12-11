import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LanguageStorage {
  static const _key = 'selected_locale';

  Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }

  Future<Locale?> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    return code != null ? Locale(code) : null;
  }
}
