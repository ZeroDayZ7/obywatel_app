// hive_storage_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'hive_storage_service.dart';

final hiveStorageProvider = Provider<HiveStorageService>((ref) {
  return HiveStorageService(boxName: 'secureData');
});
