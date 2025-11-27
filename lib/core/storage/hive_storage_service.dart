import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HiveStorageService {
  final String boxName;
  late final Box _box;

  HiveStorageService({required this.boxName});

  /// Initialize Hive box
  Future<void> init() async {
    _box = await Hive.openBox(boxName);
  }

  /// Write a value
  Future<void> write(String key, dynamic value) async {
    await _box.put(key, value);
  }

  /// Read a value
  dynamic read(String key) {
    return _box.get(key);
  }

  /// Delete a value
  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  /// Clear all values
  Future<void> clearAll() async {
    await _box.clear();
  }

  /// Debug: print all key-value pairs
  void debugPrintAll() {
    if (_box.isEmpty) {
      debugPrint('HiveStorage: no entries.');
    } else {
      debugPrint('HiveStorage contains ${_box.length} entries:');
      for (final key in _box.keys) {
        debugPrint('$key: ${_box.get(key)}');
      }
    }
  }
}

final hiveStorageProvider = Provider<HiveStorageService>((ref) {
  return HiveStorageService(boxName: 'secureData');
});
