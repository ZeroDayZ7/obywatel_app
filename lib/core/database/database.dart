import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 9;

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
      if (from < 4) {
        await m.createTable(contacts);
        await m.createTable(conversations);
        await m.createTable(conversationMembers);
        await m.createTable(messages);
        await m.createTable(outboxEvents);
      }
      if (from < 5) {
        await m.createTable(syncState);
      }
      if (from < 6) {
        await m.createTable(signalLocalIdentity);
        await m.createTable(signalIdentityKeys);
        await m.createTable(signalPreKeys);
        await m.createTable(signalSignedPreKeys);
        await m.createTable(signalSessions);
      }
      if (from < 7) {
        await m.addColumn(contacts, contacts.syncState);
        await m.addColumn(contacts, contacts.direction);
        await m.addColumn(contacts, contacts.changeSequence);
        await m.addColumn(outboxEvents, outboxEvents.entityType);
        await m.addColumn(outboxEvents, outboxEvents.entityId);
        await m.addColumn(outboxEvents, outboxEvents.attemptCount);
        await m.addColumn(outboxEvents, outboxEvents.updatedAt);
      }
      if (from < 8) {
        await m.addColumn(messages, messages.status);
      }
      if (from < 9) {
        await m.addColumn(outboxEvents, outboxEvents.outboxEventId);
        await m.addColumn(outboxEvents, outboxEvents.nextAttemptAt);
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
