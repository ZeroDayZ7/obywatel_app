import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class SharedPreferencesService {
  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

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

  /// Debug: print all key-value pairs in SharedPreferences
  Future<void> debugPrintAll() async {
    final keys = _prefs.getKeys();
    if (keys.isEmpty) {
      debugPrint('🟢 SharedPreferences: no entries.');
    } else {
      debugPrint('🟢 SharedPreferences contains ${keys.length} entries:');
      for (final key in keys) {
        final value = _prefs.get(key);
        debugPrint('• $key: $value');
      }
    }
  }
}
