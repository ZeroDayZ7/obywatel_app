import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/crypto/drift_signal_protocol_store.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/communication/application/e2ee_crypto_service.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/communication/data/dtos/message_dto.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';

class _SpyAppDatabase extends AppDatabase {
  _SpyAppDatabase() : super(NativeDatabase.memory());

  bool transactionCalled = false;

  @override
  Future<T> transaction<T>(
    Future<T> Function() action, {
    bool? requireNew,
  }) async {
    transactionCalled = true;
    return super.transaction(action, requireNew: requireNew ?? false);
  }
}

class _RollbackAfterPartialWriteDatabase extends AppDatabase {
  _RollbackAfterPartialWriteDatabase() : super(NativeDatabase.memory());

  @override
  Future<T> transaction<T>(
    Future<T> Function() action, {
    bool? requireNew,
  }) async {
    return super.transaction(() async {
      await into(messages).insert(
        MessagesCompanion(
          id: const Value('seed-message'),
          conversationId: const Value('seed-conversation'),
          senderId: const Value('user-1'),
          senderDeviceId: const Value('device-1'),
          encryptedPayload: Value(utf8.encode('seed')),
          content: const Value('seed-content'),
          type: const Value('text'),
          status: const Value('sent'),
          createdAt: Value(DateTime.utc(2024, 3, 1)),
          updatedAt: Value(DateTime.utc(2024, 3, 1)),
          version: Value(BigInt.one),
        ),
      );

      await action();
      throw StateError('forced rollback after partial write');
    });
  }
}

class _FakeChatsApiClient extends ChatsApiClient {
  _FakeChatsApiClient(this.payload)
    : super(
        ApiClient(
          dio: Dio(),
          storage: SecureStorageService(
            const FlutterSecureStorage(),
            AppLogger(),
          ),
          logger: AppLogger(),
        ),
      );

  final Map<String, dynamic> payload;

  @override
  Future<Map<String, dynamic>> syncDelta({
    int lastKnownContactVersion = 0,
    int lastKnownMessageVersion = 0,
  }) async {
    return payload;
  }
}

ChatsRepositoryImpl _createRepository(
  AppDatabase db, {
  ChatsApiClient? apiClient,
}) {
  final logger = AppLogger();
  final storage = SecureStorageService(const FlutterSecureStorage(), logger);
  final deviceInfo = DeviceInfoService(logger);
  final cryptoService = E2eeCryptoService(
    storage,
    logger,
    ApiClient(dio: Dio(), storage: storage, logger: logger),
    deviceInfo,
    DriftSignalProtocolStore(db, logger: logger),
  );

  return ChatsRepositoryImpl(
    apiClient ??
        ChatsApiClient(ApiClient(dio: Dio(), storage: storage, logger: logger)),
    db,
    logger,
    'user-1',
    deviceInfo,
    cryptoService,
    storage,
  );
}

void main() {
  group('ChatsRepositoryImpl atomic sync', () {
    test(
      'saveConversationsFromRemote persists conversation, members and messages',
      () async {
        final db = AppDatabase(NativeDatabase.memory());
        addTearDown(db.close);

        final repo = _createRepository(db);
        final conversationId = 'conv-atomic';

        final result = await repo.saveConversationsFromRemote([
          ConversationDto(
            id: conversationId,
            type: 'direct',
            title: 'Atomic test',
            members: [
              ConversationMemberDto(
                id: 'member-1',
                conversationId: conversationId,
                userId: 'user-1',
                role: 'member',
                lastReadSequence: 0,
              ),
            ],
            messages: [
              MessageDto(
                id: 'msg-1',
                conversationId: conversationId,
                senderId: 'user-2',
                senderDeviceId: 'device-2',
                type: 'text',
                encryptedPayload: 'ciphertext',
                createdAt: DateTime.utc(2024, 1, 1),
              ),
            ],
          ),
        ]);

        expect(result, hasLength(1));
        final conversations = await db.select(db.conversations).get();
        final members = await db.select(db.conversationMembers).get();
        final messages = await db.select(db.messages).get();

        expect(conversations, hasLength(1));
        expect(members, hasLength(1));
        expect(messages, hasLength(1));
        expect(messages.single.content, isEmpty);
      },
    );

    test(
      'syncDeltaFromRemote persists messages and checkpoint inside the same Drift transaction',
      () async {
        final db = _SpyAppDatabase();
        addTearDown(db.close);

        final repo = _createRepository(
          db,
          apiClient: _FakeChatsApiClient({
            'updatedContacts': <Map<String, dynamic>>[],
            'newMessages': [
              {
                'id': 'msg-remote',
                'conversationId': 'conv-delta',
                'senderId': 'user-2',
                'senderDeviceId': 'device-2',
                'type': 'text',
                'sequence': 1,
                'version': 1,
                'encryptedPayload': '',
                'createdAt': DateTime.utc(2024, 2, 1).toIso8601String(),
              },
            ],
          }),
        );

        await repo.syncDeltaFromRemote();

        expect(db.transactionCalled, isTrue);
        final messages = await db.select(db.messages).get();
        final checkpoint = await db.syncStateDao.getForUser('user-1');
        expect(messages, hasLength(1));
        expect(checkpoint?.lastKnownMessageVersion, BigInt.one);
      },
    );

    test(
      'a rollback after a partial write leaves no records and keeps checkpoint unchanged',
      () async {
        final db = _RollbackAfterPartialWriteDatabase();
        addTearDown(db.close);

        await db.syncStateDao.upsertCheckpoint(
          userId: 'user-1',
          lastKnownMessageVersion: BigInt.from(7),
          lastKnownContactVersion: BigInt.from(9),
        );

        final repo = _createRepository(
          db,
          apiClient: _FakeChatsApiClient({
            'updatedContacts': <Map<String, dynamic>>[],
            'newMessages': [
              {
                'id': 'msg-rollback',
                'conversationId': 'conv-rollback',
                'senderId': 'user-2',
                'senderDeviceId': 'device-2',
                'type': 'text',
                'sequence': 1,
                'version': 1,
                'encryptedPayload': '',
                'createdAt': DateTime.utc(2024, 2, 1).toIso8601String(),
              },
            ],
          }),
        );

        expect(() => repo.syncDeltaFromRemote(), throwsStateError);

        final messages = await db.select(db.messages).get();
        final checkpoint = await db.syncStateDao.getForUser('user-1');
        expect(messages, isEmpty);
        expect(checkpoint?.lastKnownMessageVersion, BigInt.from(7));
        expect(checkpoint?.lastKnownContactVersion, BigInt.from(9));
      },
    );

    test(
      'replaying the same delta does not create duplicate rows and keeps existing plaintext when decrypt is empty',
      () async {
        final db = AppDatabase(NativeDatabase.memory());
        addTearDown(db.close);

        await db
            .into(db.messages)
            .insert(
              MessagesCompanion(
                id: const Value('msg-idempotent'),
                conversationId: const Value('conv-idempotent'),
                senderId: const Value('user-2'),
                senderDeviceId: const Value('device-2'),
                encryptedPayload: Value(utf8.encode('ciphertext')),
                content: const Value('existing plaintext'),
                type: const Value('text'),
                status: const Value('sent'),
                createdAt: Value(DateTime.utc(2024, 2, 1)),
                updatedAt: Value(DateTime.utc(2024, 2, 1)),
                version: Value(BigInt.one),
              ),
            );

        final repo = _createRepository(
          db,
          apiClient: _FakeChatsApiClient({
            'updatedContacts': <Map<String, dynamic>>[],
            'newMessages': [
              {
                'id': 'msg-idempotent',
                'conversationId': 'conv-idempotent',
                'senderId': 'user-2',
                'senderDeviceId': 'device-2',
                'type': 'text',
                'sequence': 1,
                'version': 1,
                'encryptedPayload': '',
                'createdAt': DateTime.utc(2024, 2, 1).toIso8601String(),
              },
            ],
          }),
        );

        await repo.syncDeltaFromRemote();
        await repo.syncDeltaFromRemote();

        final messages = await db.select(db.messages).get();
        final checkpoint = await db.syncStateDao.getForUser('user-1');
        expect(messages, hasLength(1));
        expect(messages.single.id, 'msg-idempotent');
        expect(messages.single.content, 'existing plaintext');
        expect(checkpoint?.lastKnownMessageVersion, BigInt.one);
      },
    );
  });
}
