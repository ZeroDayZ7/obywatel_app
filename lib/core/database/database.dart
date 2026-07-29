import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:obywatel_plus/core/database/daos/crypto_keys_dao.dart';
import 'package:obywatel_plus/core/database/daos/notifications_dao.dart';
import 'package:obywatel_plus/core/database/daos/user_documents_dao.dart';
import 'package:obywatel_plus/core/database/tables/crypto_keys.dart';
import 'package:obywatel_plus/core/database/tables/notifications.dart';
import 'package:obywatel_plus/core/database/tables/user_documents.dart';
import 'package:obywatel_plus/features/notifications/domain/notification_model.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [CryptoKeys, Notifications, UserDocuments],
  daos: [CryptoKeysDao, NotificationsDao, UserDocumentsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(notifications, notifications.deletedAt);
      }
      if (from < 3) {
        await m.createTable(userDocuments);
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

QueryExecutor openConnection(String encryptionKey) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'obywatel_plus_encrypted.sqlite'));

    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        rawDb.execute("PRAGMA key = '$encryptionKey';");
      },
    );
  });
}
