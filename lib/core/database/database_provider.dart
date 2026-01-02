import 'package:obywatel_plus/core/database/daos/crypto_keys_dao.dart';
import 'package:obywatel_plus/core/database/daos/notifications_dao.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  // Zmienione z AppDatabaseRef na Ref
  final storage = ref.watch(secureStorageProvider);
  final db = AppDatabase(storage);
  ref.onDispose(() => db.close());
  return db;
}

@riverpod
NotificationsDao notificationsDao(Ref ref) {
  // Zmienione na Ref
  return ref.watch(appDatabaseProvider).notificationsDao;
}

@riverpod
CryptoKeysDao cryptoKeysDao(Ref ref) {
  // Zmienione na Ref
  return ref.watch(appDatabaseProvider).cryptoKeysDao;
}
