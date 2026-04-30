import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_notifier.g.dart';

const _themeKey = 'theme_mode';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  SharedPreferencesService get _prefs => ref.read(activePrefsProvider);

  @override
  ThemeMode build() {
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

  Future<void> _updateTheme(ThemeMode mode) async {
    state = mode;

    try {
      await _prefs.write(_themeKey, mode.name);
      ref.read(appLoggerProvider).i('Theme persisted: ${mode.name}');
    } catch (e, s) {
      ref
          .read(appLoggerProvider)
          .e('Failed to save theme', error: e, stackTrace: s);
    }
  }

  Future<void> setLight() => _updateTheme(ThemeMode.light);
  Future<void> setDark() => _updateTheme(ThemeMode.dark);
  Future<void> setSystem() => _updateTheme(ThemeMode.system);

  Future<void> toggleTheme() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    return _updateTheme(newMode);
  }
}
