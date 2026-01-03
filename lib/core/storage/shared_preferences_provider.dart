import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_provider.g.dart';

/// Provider dla instancji SharedPreferences (używany przy inicjalizacji)
@riverpod
Future<SharedPreferences> sharedPreferencesInstance(Ref ref) {
  return SharedPreferences.getInstance();
}

/// Aktywny serwis (wymaga override w ProviderScope w main.dart po załadowaniu instancji)
@riverpod
SharedPreferencesService activePrefs(Ref ref) {
  throw UnimplementedError(
    'Pamiętaj o override activePrefsProvider w bootstrapie!',
  );
}

class SharedPreferencesService {
  final SharedPreferences _prefs;
  final AppLogger _logger;

  SharedPreferencesService(this._prefs, this._logger);

  /// Read a string value from SharedPreferences
  String? read(String key) => _prefs.getString(key);

  /// Read a boolean value from SharedPreferences
  bool? readBool(String key) => _prefs.getBool(key);

  /// Write a string value to SharedPreferences
  Future<void> write(String key, String value) async {
    await _prefs.setString(key, value);
  }

  /// Write a boolean value to SharedPreferences
  Future<void> writeBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  /// Remove a value from SharedPreferences
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  /// Clear all values in SharedPreferences
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  /// Debug: print all key-value pairs using AppLogger
  Future<void> debugPrintAll() async {
    final keys = _prefs.getKeys();
    if (keys.isEmpty) {
      _logger.d(
        '===== SharedPreferences: no entries. =====',
        module: 'Storage',
      );
    } else {
      _logger.d(
        '===== SharedPreferences contains ${keys.length} entries =====',
        module: 'Storage',
      );
      for (final key in keys) {
        final value = _prefs.get(key);
        _logger.d('• $key: $value', module: 'Storage');
      }
    }
  }
}
