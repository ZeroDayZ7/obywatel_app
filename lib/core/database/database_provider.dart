import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:obywatel_plus/core/database/daos/chats_dao.dart';
import 'package:obywatel_plus/core/database/daos/crypto_keys_dao.dart';
import 'package:obywatel_plus/core/database/daos/notifications_dao.dart';
import 'package:obywatel_plus/core/database/daos/outbox_dao.dart';
import 'package:obywatel_plus/core/database/daos/sync_state_dao.dart';
import 'package:obywatel_plus/core/database/daos/user_documents_dao.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

Future<void> deleteLocalDatabaseFiles() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final dbPath = p.join(dbFolder.path, 'obywatel_plus_encrypted.sqlite');

  for (final suffix in ['', '-wal', '-shm', '-journal']) {
    final file = File('$dbPath$suffix');
    if (await file.exists()) {
      await file.delete();
    }
  }
}

class DatabaseKeyCodec {
  const DatabaseKeyCodec._();

  static String encodeKeyBytes(List<int> bytes) {
    if (bytes.length != 32) {
      throw const FormatException(
        'Database encryption key must be exactly 32 bytes.',
      );
    }
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  static List<int> decodeHexKey(String rawValue) {
    final normalized = rawValue.trim();
    if (normalized.isEmpty) {
      throw const FormatException('Database encryption key is empty.');
    }
    if (normalized.length % 2 != 0) {
      throw const FormatException(
        'Database encryption key hex must have an even number of characters.',
      );
    }

    final decoded = <int>[];
    for (var index = 0; index < normalized.length; index += 2) {
      final byteString = normalized.substring(index, index + 2);
      try {
        decoded.add(int.parse(byteString, radix: 16));
      } on FormatException {
        throw FormatException(
          'Database encryption key contains invalid hex: $byteString',
        );
      }
    }

    if (decoded.length != 32) {
      throw FormatException(
        'Database encryption key must decode to exactly 32 bytes, got ${decoded.length} bytes.',
      );
    }
    return decoded;
  }
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  ref.keepAlive();

  final storage = ref.watch(secureStorageProvider);

  final executor = LazyDatabase(() async {
    String? encryptionKey = await storage.read(key: StorageKeys.databaseKey);

    if (encryptionKey == null) {
      final values = List<int>.generate(
        32,
        (i) => Random.secure().nextInt(256),
      );

      encryptionKey = DatabaseKeyCodec.encodeKeyBytes(values);

      await storage.write(key: StorageKeys.databaseKey, value: encryptionKey);
    }

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

@riverpod
UserDocumentsDao userDocumentsDao(Ref ref) {
  return ref.watch(appDatabaseProvider).userDocumentsDao;
}

@riverpod
ChatsDao chatsDao(Ref ref) {
  return ref.watch(appDatabaseProvider).chatsDao;
}

@riverpod
SyncStateDao syncStateDao(Ref ref) {
  return ref.watch(appDatabaseProvider).syncStateDao;
}

@riverpod
OutboxDao outboxDao(Ref ref) {
  return ref.watch(appDatabaseProvider).outboxDao;
}