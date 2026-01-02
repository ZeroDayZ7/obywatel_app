import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/notifications/domain/notification_model.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/crypto_keys_dao.dart';
import 'daos/notifications_dao.dart';
import 'tables/crypto_keys.dart';
import 'tables/notifications.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [CryptoKeys, Notifications],
  daos: [CryptoKeysDao, NotificationsDao],
)
class AppDatabase extends _$AppDatabase {
  final SecureStorageService storage;

  AppDatabase(this.storage) : super(_openConnection(storage));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(notifications, notifications.deletedAt);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> clearDatabase() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
}

QueryExecutor _openConnection(SecureStorageService storage) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_encrypted.sqlite'));

    String? encryptionKey = await storage.read(key: StorageKeys.databaseKey);

    if (encryptionKey == null) {
      final values = List<int>.generate(
        32,
        (i) => Random.secure().nextInt(256),
      );
      encryptionKey = base64Url.encode(values);
      await storage.write(key: StorageKeys.databaseKey, value: encryptionKey);
    }

    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        rawDb.execute("PRAGMA key = '$encryptionKey';");
      },
    );
  });
}
