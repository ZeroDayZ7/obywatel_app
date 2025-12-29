import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';

/// Provider bazy danych (Singleton)
final databaseProvider = Provider<AppDatabase>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return AppDatabase(storage);
});

/// Przykład providera dla konkretnego DAO
final cryptoKeysDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).cryptoKeysDao;
});
