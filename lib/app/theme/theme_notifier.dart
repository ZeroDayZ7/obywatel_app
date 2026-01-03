import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_notifier.g.dart';

const _themeKey = 'theme_mode';

/// Notifier zarządzający trybem motywu (Jasny/Ciemny/Systemowy)
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  // Prywatne gettery dla wygody i czystości kodu
  SharedPreferencesService get _prefs => ref.read(activePrefsProvider);

  @override
  ThemeMode build() {
    // Odczytujemy zapisany motyw. Zakładamy, że bootstrap zapewnił
    // dostępność activePrefsProvider synchronicznie.
    try {
      final saved = _prefs.read(_themeKey);
      if (saved != null) {
        return ThemeMode.values.firstWhere(
          (mode) => mode.name == saved,
          orElse: () => ThemeMode.system,
        );
      }
    } catch (e, s) {
      ref
          .read(appLoggerProvider)
          .e('Failed to load initial theme', error: e, stackTrace: s);
    }
    return ThemeMode.system;
  }

  /// Wspólna logika aktualizacji stanu i persystencji
  Future<void> _updateTheme(ThemeMode mode) async {
    // 1. Reakcja natychmiastowa w UI
    state = mode;

    try {
      // 2. Zapis na dysku
      await _prefs.write(_themeKey, mode.name);
      ref.read(appLoggerProvider).i('Theme persisted: ${mode.name}');
    } catch (e, s) {
      ref
          .read(appLoggerProvider)
          .e('Failed to save theme', error: e, stackTrace: s);
    }
  }

  // Publiczne API
  Future<void> setLight() => _updateTheme(ThemeMode.light);
  Future<void> setDark() => _updateTheme(ThemeMode.dark);
  Future<void> setSystem() => _updateTheme(ThemeMode.system);

  /// Opcjonalnie: Przełączanie motywu (Toggle)
  Future<void> toggleTheme() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    return _updateTheme(newMode);
  }
}
