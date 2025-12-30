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
  AppLogger get _logger => ref.read(appLoggerProvider);

  /// Synchroniczny dostęp do serwisu SharedPreferences
  SharedPreferencesService get _prefs => ref.read(activePrefsProvider);

  @override
  ThemeMode build() {
    // Inicjalizujemy stan motywu od razu podczas budowania notifiera.
    // Skoro bootstrap został ukończony, serwis jest dostępny synchronicznie.
    try {
      final saved = _prefs.read(_themeKey);
      if (saved != null) {
        return ThemeMode.values.firstWhere(
          (mode) => mode.name == saved,
          orElse: () => ThemeMode.system,
        );
      }
    } catch (e, s) {
      _logger.e('Failed to load initial theme', error: e, stackTrace: s);
    }
    return ThemeMode.system;
  }

  /// Prywatna metoda aktualizująca stan i zapisująca go na dysku
  Future<void> _updateTheme(ThemeMode mode) async {
    // 1. Najpierw aktualizujemy stan w RAM (UI reaguje natychmiast)
    state = mode;

    try {
      // 2. Asynchronicznie zapisujemy zmianę na dysku
      await _prefs.write(_themeKey, mode.name);
      _logger.i('Theme persisted: ${mode.name}');
    } catch (e, s) {
      _logger.e('Failed to save theme', error: e, stackTrace: s);
    }
  }

  // Publiczne API
  Future<void> setLight() => _updateTheme(ThemeMode.light);
  Future<void> setDark() => _updateTheme(ThemeMode.dark);
  Future<void> setSystem() => _updateTheme(ThemeMode.system);
}
