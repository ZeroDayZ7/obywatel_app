import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart'; // <-- Tutaj jest debugPrint
import 'package:obywatel_plus/core/database/daos/chats_dao.dart';
import 'package:obywatel_plus/core/database/daos/contacts_dao.dart';
import 'package:obywatel_plus/core/database/daos/crypto_keys_dao.dart';
import 'package:obywatel_plus/core/database/daos/notifications_dao.dart';
import 'package:obywatel_plus/core/database/daos/outbox_dao.dart';
import 'package:obywatel_plus/core/database/daos/sync_state_dao.dart';
import 'package:obywatel_plus/core/database/daos/user_documents_dao.dart';
import 'package:obywatel_plus/core/database/tables/contacts.dart';
import 'package:obywatel_plus/core/database/tables/conversation_members.dart';
import 'package:obywatel_plus/core/database/tables/conversations.dart';
import 'package:obywatel_plus/core/database/tables/crypto_keys.dart';
import 'package:obywatel_plus/core/database/tables/messages.dart';
import 'package:obywatel_plus/core/database/tables/messaging_activation_states.dart';
import 'package:obywatel_plus/core/database/tables/notifications.dart';
import 'package:obywatel_plus/core/database/tables/outbox_events.dart';
import 'package:obywatel_plus/core/database/tables/signal_identity_keys.dart';
import 'package:obywatel_plus/core/database/tables/signal_local_identity.dart';
import 'package:obywatel_plus/core/database/tables/signal_pre_keys.dart';
import 'package:obywatel_plus/core/database/tables/signal_sessions.dart';
import 'package:obywatel_plus/core/database/tables/signal_signed_pre_keys.dart';
import 'package:obywatel_plus/core/database/tables/sync_state.dart';
import 'package:obywatel_plus/core/database/tables/user_documents.dart';
import 'package:obywatel_plus/features/notifications/domain/notification_model.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    CryptoKeys,
    Notifications,
    UserDocuments,
    Contacts,
    Conversations,
    ConversationMembers,
    Messages,
    MessagingActivationStates,
    OutboxEvents,
    SyncState,
    SignalLocalIdentity,
    SignalIdentityKeys,
    SignalPreKeys,
    SignalSignedPreKeys,
    SignalSessions,
  ],
  daos: [
    CryptoKeysDao,
    NotificationsDao,
    UserDocumentsDao,
    ContactsDao,
    ChatsDao,
    OutboxDao,
    SyncStateDao,
  ],
)
class DatabaseSecurityException implements Exception {
  final String message;

  const DatabaseSecurityException(this.message);

  @override
  String toString() => 'DatabaseSecurityException: $message';
}

bool shouldAutoResetCorruptedDatabase(
  Object error, {
  required bool isDebugMode,
}) {
  final normalized = error.toString().toLowerCase();

  return isDebugMode &&
      (normalized.contains('code 26') || normalized.contains('not a database'));
}

class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Brak migracji – czysty start od wersji 1
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> clearSignalStore() async {
    await transaction(() async {
      await delete(signalLocalIdentity).go();
      await delete(signalIdentityKeys).go();
      await delete(signalPreKeys).go();
      await delete(signalSignedPreKeys).go();
      await delete(signalSessions).go();
    });
  }

  Future<void> clearDatabase() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }

  Future<void> dumpDatabaseTables() async {
    debugPrint('=== [DATABASE DUMP] START ===');
    for (final table in allTables) {
      try {
        final rows = await select(table).get();
        debugPrint('Tabela [${table.actualTableName}] - Liczba wierszy: ${rows.length}');
        for (final row in rows) {
          debugPrint('  -> $row');
        }
      } catch (e) {
        debugPrint('Tabela [${table.actualTableName}] - Błąd odczytu: $e');
      }
    }
    debugPrint('=== [DATABASE DUMP] END ===');
  }
}

QueryExecutor openConnection(String encryptionKey) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'obywatel_plus_encrypted.sqlite'));

    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        final cipher = rawDb.select('PRAGMA cipher;');

        if (cipher.isEmpty) {
          throw UnsupportedError('SQLite3MultipleCiphers is unavailable.');
        }

        final safeKey = encryptionKey.replaceAll('\'', '\'\'');
        
        rawDb.execute('PRAGMA hexkey = \'$safeKey\';');

        try {
          rawDb.select('SELECT count(*) FROM sqlite_master;');
        } catch (e) {
          final shouldReset = shouldAutoResetCorruptedDatabase(
            e,
            isDebugMode: kDebugMode,
          );

          if (shouldReset) {
            debugPrint(
              '[DATABASE-SECURITY] ⚠️ Stary plik bazy jest niekompatybilny. Usuwam plik i tworzę świeżą bazę (debug mode).',
            );

            try {
              rawDb.close();
            } catch (_) {}

            if (file.existsSync()) {
              file.deleteSync();
            }

            rawDb.execute('PRAGMA hexkey = \'$safeKey\';');
            rawDb.select('SELECT count(*) FROM sqlite_master;');
            debugPrint('[DATABASE-SECURITY] ✅ Świeża zaszyfrowana baza została zainicjalizowana.');
            return;
          }

          throw const DatabaseSecurityException(
            'Encrypted database cannot be opened because the key is invalid or the database is corrupt. Automatic reset is disabled in production to prevent data loss.',
          );
        }

        // debugPrint('[DATABASE-SECURITY] Cipher available; database key verified.');
      },
    );
  });
}