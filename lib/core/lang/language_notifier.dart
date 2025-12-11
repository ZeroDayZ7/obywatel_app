import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_service.dart';

const _languageKey = 'app_language';

/// Riverpod Notifier dla języka aplikacji
final languageProvider = NotifierProvider<LanguageNotifier, Locale>(LanguageNotifier.new);

class LanguageNotifier extends Notifier<Locale> {
  late final AppLogger _logger;
  late final SharedPreferencesService _prefs;

  @override
  Locale build() {
    _logger = ref.read(appLoggerProvider);
    _logger.i('🌐 LanguageNotifier initialized');

    // Pobieramy SharedPreferencesService z FutureProvider
    ref
        .read(sharedPreferencesServiceProvider.future)
        .then((service) {
          _prefs = service;
          _loadLanguage();
        })
        .catchError((e, s) {
          _logger.e('⚠️ Failed to load language', error: e, stackTrace: s);
        });

    return const Locale('pl'); // domyślny język
  }

  Future<void> _loadLanguage() async {
    final code = _prefs.read(_languageKey);
    _logger.i('🪶 Loaded language from prefs: $code');

    if (code != null) {
      state = Locale(code);
    } else {
      state = const Locale('pl');
      await _saveLanguage(state);
    }
  }

  Future<void> _saveLanguage(Locale locale) async {
    await _prefs.write(_languageKey, locale.languageCode);
    _logger.i('💾 Saved language: ${locale.languageCode}');
  }

  Future<void> setLanguage(String code) async {
    state = Locale(code);
    await _saveLanguage(state);
  }

  Future<void> setPolish() async => setLanguage('pl');
  Future<void> setEnglish() async => setLanguage('en');
}
