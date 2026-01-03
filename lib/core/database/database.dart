import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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
  AppDatabase(super.executor);

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

/// Funkcja tworząca połączenie. Klucz szyfrujący jest przekazywany jako prosty String,
/// co pozwala na bezpieczne przesłanie go do tła (Isolate).
QueryExecutor openConnection(String encryptionKey) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_encrypted.sqlite'));

    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        // Używamy PRAGMA key dla SQLCipher
        rawDb.execute("PRAGMA key = '$encryptionKey';");
      },
    );
  });
}
