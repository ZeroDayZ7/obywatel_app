import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:obywatel_plus/core/database/daos/crypto_keys_dao.dart';
import 'package:obywatel_plus/core/database/daos/notifications_dao.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final storage = ref.watch(secureStorageProvider);

  // Tworzymy LazyDatabase, który zajmie się asynchronicznym przygotowaniem klucza
  final executor = LazyDatabase(() async {
    // 1. Pobieramy klucz ze Storage (w głównym wątku - bezpiecznie)
    String? encryptionKey = await storage.read(key: StorageKeys.databaseKey);

    // 2. Jeśli klucza brak, generujemy go raz i zapisujemy
    if (encryptionKey == null) {
      final values = List<int>.generate(
        32,
        (i) => Random.secure().nextInt(256),
      );
      encryptionKey = base64Url.encode(values);
      await storage.write(key: StorageKeys.databaseKey, value: encryptionKey);
    }

    // 3. Zwracamy executor, który odpala SQL w tle, przekazując TYLKO Stringa
    return openConnection(encryptionKey);
  });

  final db = AppDatabase(executor);

  ref.onDispose(() => db.close());
  return db;
}

@riverpod
NotificationsDao notificationsDao(Ref ref) {
  return ref.watch(appDatabaseProvider).notificationsDao;
}

@riverpod
CryptoKeysDao cryptoKeysDao(Ref ref) {
  return ref.watch(appDatabaseProvider).cryptoKeysDao;
}
