import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_service.dart';

const _themeKey = 'theme_mode';

/// Riverpod Notifier dla motywu aplikacji
final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

class ThemeNotifier extends Notifier<ThemeMode> {
  late final AppLogger _logger;
  late final SharedPreferencesService _prefs;

  @override
  ThemeMode build() {
    _logger = ref.read(appLoggerProvider);
    _logger.i('🎨 ThemeNotifier initialized');

    // Pobieramy SharedPreferencesService z FutureProvider
    ref.read(sharedPreferencesServiceProvider.future).then((service) {
      _prefs = service;
      _loadTheme();
    }).catchError((e, s) {
      _logger.e('⚠️ Failed to load theme', error: e, stackTrace: s);
    });

    return ThemeMode.system;
  }

  Future<void> _loadTheme() async {
    final themeString = _prefs.read(_themeKey);
    _logger.i('🪶 Loaded theme from prefs: $themeString');

    switch (themeString) {
      case 'light':
        state = ThemeMode.light;
        break;
      case 'dark':
        state = ThemeMode.dark;
        break;
      default:
        state = ThemeMode.system;
    }
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    await _prefs.write(_themeKey, mode.name);
    _logger.i('💾 Saved theme: ${mode.name}');
  }

  Future<void> setLight() async {
    state = ThemeMode.light;
    await _saveTheme(state);
  }

  Future<void> setDark() async {
    state = ThemeMode.dark;
    await _saveTheme(state);
  }

  Future<void> setSystem() async {
    state = ThemeMode.system;
    await _saveTheme(state);
  }
}
