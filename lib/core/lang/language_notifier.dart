import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/lang/languages.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_service.dart';

const _languageKey = 'app_language';

final languageProvider = NotifierProvider<LanguageNotifier, Locale>(
  LanguageNotifier.new,
);

class LanguageNotifier extends Notifier<Locale> {
  AppLogger get _logger => ref.read(appLoggerProvider);

  SharedPreferencesService? _prefs;

  @override
  Locale build() {
    _logger.i('🌐 LanguageNotifier initialized');

    ref
        .read(sharedPreferencesServiceProvider.future)
        .then((service) {
          _prefs = service;
          _loadLanguage();
        })
        .catchError((e, s) {
          _logger.e('⚠️ Failed to load language', error: e, stackTrace: s);
        });

    final deviceLocale = PlatformDispatcher.instance.locale;
    _logger.i('📱 Detected device locale: $deviceLocale');

    if (AppLanguages.supported.any(
      (lang) => lang.code == deviceLocale.languageCode,
    )) {
      _logger.i('✅ Device locale is supported: ${deviceLocale.languageCode}');
      return deviceLocale;
    }

    _logger.i('⚠️ Device locale not supported, using fallback: pl');
    return const Locale('pl');
  }

  Future<void> _loadLanguage() async {
    if (_prefs == null) return;

    final code = _prefs!.read(_languageKey);
    _logger.i('🪶 Loaded language from prefs: $code');

    if (code != null) {
      state = Locale(code);
    } else {
      state = const Locale('pl');
      await _saveLanguage(state);
    }
  }

  Future<void> _saveLanguage(Locale locale) async {
    if (_prefs == null) return;

    await _prefs!.write(_languageKey, locale.languageCode);
    _logger.i('💾 Saved language: ${locale.languageCode}');
  }

  Future<void> setLanguage(String code) async {
    state = Locale(code);
    await _saveLanguage(state);
  }

  Future<void> setPolish() async => setLanguage('pl');
  Future<void> setEnglish() async => setLanguage('en');
}
