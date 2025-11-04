import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/core_providers.dart';

const _themeKey = 'theme_mode';

/// Riverpod Notifier dla motywu aplikacji
final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

class ThemeNotifier extends Notifier<ThemeMode> {
  late final AppLogger _logger;
  SharedPreferences? _prefs;

  @override
  ThemeMode build() {
    // _logger = sl<AppLogger>();
    _logger = ref.read(appLoggerProvider);
    _logger.i('🎨 ThemeNotifier initialized');

    // wczytaj motyw asynchronicznie po starcie
    Future.microtask(() async {
      try {
        await _loadTheme();
      } catch (e, s) {
        _logger.e('⚠️ Failed to load theme', error: e, stackTrace: s);
      }
    });

    return ThemeMode.system;
  }

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> _loadTheme() async {
    await _initPrefs();

    final themeString = _prefs?.getString(_themeKey);
    _logger.i('🪶 Loaded theme from prefs: $themeString');

    if (themeString == null) {
      state = ThemeMode.system;
      await _saveTheme(ThemeMode.system);
      return;
    }

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
    await _initPrefs();
    await _prefs?.setString(_themeKey, mode.name);
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
