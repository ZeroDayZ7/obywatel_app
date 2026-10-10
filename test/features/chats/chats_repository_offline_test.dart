import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:obywatel_plus/core/crypto/drift_signal_protocol_store.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/communication/application/e2ee_crypto_service.dart';
import 'package:obywatel_plus/features/communication/application/outbox_event_builder.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/communication/data/dtos/message_dto.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:uuid/uuid.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final secureStorageValues = <String, String>{};
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
        (call) async {
          final args = call.arguments as Map<dynamic, dynamic>? ?? const {};
          switch (call.method) {
            case 'read':
              return secureStorageValues[args['key'] as String];
            case 'write':
              final key = args['key'] as String;
              final value = args['value'] as String;
              secureStorageValues[key] = value;
              return null;
            case 'delete':
              secureStorageValues.remove(args['key'] as String);
              return null;
            case 'deleteAll':
              secureStorageValues.clear();
              return null;
            case 'readAll':
              return Map<String, String>.from(secureStorageValues);
            default:
              return null;
          }
        },
      );

  late AppDatabase database;
  late AppLogger logger;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    logger = AppLogger();
  });

  tearDown(() async {
    await database.close();
  });

  Future<ChatsRepositoryImpl> createRepositoryWithSession({
    required String userId,
    required String peerId,
  }) async {
    final secureStorage = SecureStorageService(
      const FlutterSecureStorage(),
      logger,
    );
    final aliceApiClient = ApiClient(
      dio: Dio(),
      storage: secureStorage,
      logger: logger,
    );
    final aliceStore = DriftSignalProtocolStore(database);
    final aliceService = E2eeCryptoService(
      secureStorage,
      logger,
      aliceApiClient,
      DeviceInfoService(logger),
      aliceStore,
    );

    final bobDb = AppDatabase(NativeDatabase.memory());
    addTearDown(() async => bobDb.close());
    final bobStore = DriftSignalProtocolStore(bobDb);

    final bobIdentity = await bobStore.getIdentityKeyPair();
    final bobSignedPreKey = generateSignedPreKey(bobIdentity, 1);
    final bobOneTimePreKey = generatePreKeys(1, 1).first;
    await bobStore.storeSignedPreKey(bobSignedPreKey.id, bobSignedPreKey);
    await bobStore.storePreKey(bobOneTimePreKey.id, bobOneTimePreKey);

    final remoteBundle = PreKeyBundle(
      await bobStore.getLocalRegistrationId(),
      1,
      bobOneTimePreKey.id,
      bobOneTimePreKey.getKeyPair().publicKey,
      bobSignedPreKey.id,
      bobSignedPreKey.getKeyPair().publicKey,
      bobSignedPreKey.signature,
      bobIdentity.getPublicKey(),
    );

    await aliceService.initializeSessionForPeer(
      peerId,
      remoteBundle: remoteBundle,
    );

    return ChatsRepositoryImpl(
      ChatsApiClient(aliceApiClient),
      database,
      logger,
      userId,
      DeviceInfoService(logger),
      aliceService,
    );
  }

  test(
    'local first: sendMessage stores ciphertext in Drift and keeps UI plaintext from local flow',
    () async {
      final repository = await createRepositoryWithSession(
        userId: 'user-a',
        peerId: 'peer-user',
      );

      await repository.sendMessage(
        conversationId: 'peer-user',
        content: 'hello from local first',
      );

      final persisted = await database.chatsDao.getMessagesForConversation(
        'peer-user',
      );
      final pendingRows = await database.outboxDao.getPendingEvents();
      final localView = await repository
          .watchMessagesForConversation('peer-user')
          .first;

      expect(persisted, isNotEmpty);
      expect(persisted.single.status, 'pending');
      expect(
        utf8.decode(persisted.single.encryptedPayload, allowMalformed: true),
        isNot('hello from local first'),
      );
      expect(pendingRows, isNotEmpty);
      expect(localView.single.content, 'hello from local first');
    },
  );

  test(
    'local pending message keeps a null server sequence until sync assigns one',
    () async {
      final repository = await createRepositoryWithSession(
        userId: 'user-a',
        peerId: 'peer-user',
      );

      await repository.sendMessage(
        conversationId: 'peer-user',
        content: 'offline message',
      );

      final stored = await database.chatsDao.getMessagesForConversation(
        'peer-user',
      );

      expect(stored.single.status, 'pending');
      expect(stored.single.sequence, isNull);
    },
  );

  test(
    'offline: pending outbox remains after send and status stays pending',
    () async {
      final repository = await createRepositoryWithSession(
        userId: 'user-a',
        peerId: 'peer-user',
      );

      await repository.sendMessage(
        conversationId: 'peer-user',
        content: 'offline message',
      );

      final stored = await database.chatsDao.getMessagesForConversation(
        'peer-user',
      );
      final pendingRows = await database.outboxDao.getPendingEvents();

      expect(stored.single.status, 'pending');
      expect(pendingRows.length, 1);
      expect(pendingRows.single.eventType, 'SEND_MESSAGE');
    },
  );

  test(
    'restart persistence: pending message survives database reopen',
    () async {
      final tempDir = await Directory.systemTemp.createTemp('phase5_restart_');
      final dbPath = '${tempDir.path}/phase5.sqlite';
      final initialDb = AppDatabase(NativeDatabase(File(dbPath)));
      addTearDown(() async {
        await initialDb.close();
        await tempDir.delete(recursive: true);
      });

      final secureStorage = SecureStorageService(
        const FlutterSecureStorage(),
        logger,
      );
      final aliceApiClient = ApiClient(
        dio: Dio(),
        storage: secureStorage,
        logger: logger,
      );
      final aliceStore = DriftSignalProtocolStore(initialDb);
      final aliceService = E2eeCryptoService(
        secureStorage,
        logger,
        aliceApiClient,
        DeviceInfoService(logger),
        aliceStore,
      );

      final bobDb = AppDatabase(NativeDatabase.memory());
      final bobStore = DriftSignalProtocolStore(bobDb);
      final bobIdentity = await bobStore.getIdentityKeyPair();
      final bobSignedPreKey = generateSignedPreKey(bobIdentity, 1);
      final bobOneTimePreKey = generatePreKeys(1, 1).first;
      await bobStore.storeSignedPreKey(bobSignedPreKey.id, bobSignedPreKey);
      await bobStore.storePreKey(bobOneTimePreKey.id, bobOneTimePreKey);

      final remoteBundle = PreKeyBundle(
        await bobStore.getLocalRegistrationId(),
        1,
        bobOneTimePreKey.id,
        bobOneTimePreKey.getKeyPair().publicKey,
        bobSignedPreKey.id,
        bobSignedPreKey.getKeyPair().publicKey,
        bobSignedPreKey.signature,
        bobIdentity.getPublicKey(),
      );
      await aliceService.initializeSessionForPeer(
        'peer-user',
        remoteBundle: remoteBundle,
      );

      final repository = ChatsRepositoryImpl(
        ChatsApiClient(aliceApiClient),
        initialDb,
        logger,
        'user-a',
        DeviceInfoService(logger),
        aliceService,
      );

      await repository.sendMessage(
        conversationId: 'peer-user',
        content: 'persist me',
      );

      await initialDb.close();
      final reopenedDb = AppDatabase(NativeDatabase(File(dbPath)));
      addTearDown(() async => reopenedDb.close());

      final reloaded = await reopenedDb.chatsDao.getMessagesForConversation(
        'peer-user',
      );
      expect(reloaded, isNotEmpty);
      expect(reloaded.single.status, 'pending');
    },
  );

  test(
    'successful sync clears outbox and marks message sent without deleting local record',
    () async {
      final repository = await createRepositoryWithSession(
        userId: 'user-a',
        peerId: 'peer-user',
      );

      await repository.sendMessage(
        conversationId: 'peer-user',
        content: 'sync success',
      );

      final created = await database.chatsDao.getMessagesForConversation(
        'peer-user',
      );
      await repository.clearSentOutboxMessages([created.single.id]);

      final updated = await database.chatsDao.getMessagesForConversation(
        'peer-user',
      );
      final pendingRows = await database.outboxDao.getPendingEvents();

      expect(updated.single.status, 'sent');
      expect(pendingRows, isEmpty);
    },
  );

  test(
    'outbox ids are valid UUIDs for every generated message event',
    () async {
      final repository = await createRepositoryWithSession(
        userId: 'user-a',
        peerId: 'peer-user',
      );

      await repository.sendMessage(
        conversationId: 'peer-user',
        content: 'uuid outbox contract',
      );

      final original = await database.outboxDao.getPendingEvents();
      final payload =
          jsonDecode(original.single.payload) as Map<String, dynamic>;

      expect(Uuid.isValidUUID(fromString: original.single.id), isTrue);
      expect(original.single.outboxEventId, isNotNull);
      expect(
        Uuid.isValidUUID(fromString: original.single.outboxEventId!),
        isTrue,
      );
      expect(
        Uuid.isValidUUID(fromString: payload['event_id'] as String),
        isTrue,
      );
      expect(
        Uuid.isValidUUID(fromString: payload['idempotency_key'] as String),
        isTrue,
      );
      expect(
        Uuid.isValidUUID(fromString: payload['message_id'] as String),
        isTrue,
      );
      expect(
        Uuid.isValidUUID(fromString: payload['outbox_event_id'] as String),
        isTrue,
      );
    },
  );

  test('phase 6: outbox event id stays stable across retries', () async {
    final repository = await createRepositoryWithSession(
      userId: 'user-a',
      peerId: 'peer-user',
    );

    await repository.sendMessage(
      conversationId: 'peer-user',
      content: 'retry stable event',
    );

    final original = await database.outboxDao.getPendingEvents();
    final originalEvent = original.single;

    await database.outboxDao.scheduleRetry(originalEvent.id, retryCount: 1);
    await database.outboxDao.scheduleRetry(originalEvent.id, retryCount: 2);

    final row = await database.outboxDao.getRowById(originalEvent.id);
    expect(row, isNotNull);
    expect(row!.outboxEventId, isNotEmpty);
    expect(row.outboxEventId, equals(originalEvent.outboxEventId));
    expect(row.retryCount, equals(2));
  });

  test('phase 6: retry eligibility is gated by nextAttemptAt', () async {
    final repository = await createRepositoryWithSession(
      userId: 'user-a',
      peerId: 'peer-user',
    );

    await repository.sendMessage(
      conversationId: 'peer-user',
      content: 'retry later',
    );

    final row = (await database.outboxDao.getPendingEvents()).single;
    final now = DateTime.now();
    await database.outboxDao.scheduleRetry(
      row.id,
      retryCount: 1,
      referenceTime: now.subtract(const Duration(seconds: 1)),
    );

    final eligibleNow = await database.outboxDao.getRetryEligibleEvents(
      referenceTime: now,
    );
    final futureOnly = await database.outboxDao.getRetryEligibleEvents(
      referenceTime: now.add(const Duration(minutes: 5)),
    );

    expect(eligibleNow, isNotEmpty);
    expect(futureOnly, isNotEmpty);
  });

  test('phase 6: exponential backoff moves nextAttemptAt forward', () async {
    final repository = await createRepositoryWithSession(
      userId: 'user-a',
      peerId: 'peer-user',
    );

    await repository.sendMessage(
      conversationId: 'peer-user',
      content: 'backoff test',
    );

    final row = (await database.outboxDao.getPendingEvents()).single;
    final firstAttempt = DateTime.now();
    await database.outboxDao.scheduleRetry(
      row.id,
      retryCount: 1,
      referenceTime: firstAttempt,
    );
    final afterFirst = await database.outboxDao.getRowById(row.id);

    final secondAttempt = DateTime.now().add(const Duration(minutes: 1));
    await database.outboxDao.scheduleRetry(
      row.id,
      retryCount: 2,
      referenceTime: secondAttempt,
    );
    final afterSecond = await database.outboxDao.getRowById(row.id);

    expect(afterFirst, isNotNull);
    expect(afterSecond, isNotNull);
    expect(
      afterSecond!.nextAttemptAt!.isAfter(afterFirst!.nextAttemptAt!),
      isTrue,
    );
  });

  test(
    'ciphertext is stored in Drift and plaintext is not persisted as outgoing payload',
    () async {
      final repository = await createRepositoryWithSession(
        userId: 'user-a',
        peerId: 'peer-user',
      );

      await repository.sendMessage(
        conversationId: 'peer-user',
        content: 'secret message',
      );

      final persisted = await database.chatsDao.getMessagesForConversation(
        'peer-user',
      );
      final storedText = utf8.decode(
        persisted.single.encryptedPayload,
        allowMalformed: true,
      );

      expect(storedText, isNot('secret message'));
      expect(storedText, isNotEmpty);
    },
  );

  test('device identity should stay stable per installation', () async {
    const secureStorage = FlutterSecureStorage();
    await secureStorage.deleteAll();

    final deviceInfoService = DeviceInfoService(logger);
    final firstDeviceId = await deviceInfoService.getOrCreateDeviceId();
    final secondDeviceId = await deviceInfoService.getOrCreateDeviceId();

    expect(firstDeviceId, isNotEmpty);
    expect(secondDeviceId, equals(firstDeviceId));
  });

  test(
    'outbox event payload should match backend contract and keep ciphertext nested',
    () {
      final message = Message(
        id: const Uuid().v4(),
        conversationId: 'conv-123',
        senderId: 'user-123',
        content: 'ciphertext-payload',
        isMine: true,
        createdAt: DateTime.utc(2024, 1, 1, 10, 0),
      );

      final event = buildOutboxEventPayload(message, 'device-abc');
      final payload = event['payload'] as Map<String, dynamic>;

      expect(Uuid.isValidUUID(fromString: event['event_id'] as String), isTrue);
      expect(
        Uuid.isValidUUID(fromString: event['idempotency_key'] as String),
        isTrue,
      );
      expect(
        Uuid.isValidUUID(fromString: event['message_id'] as String),
        isTrue,
      );
      expect(
        Uuid.isValidUUID(fromString: payload['event_id'] as String),
        isTrue,
      );
      expect(
        Uuid.isValidUUID(fromString: payload['idempotency_key'] as String),
        isTrue,
      );
      expect(
        Uuid.isValidUUID(fromString: payload['message_id'] as String),
        isTrue,
      );
      expect(event['event_type'], 'SEND_MESSAGE');
      expect(payload['content'], 'ciphertext-payload');
      expect(event['device_id'], 'device-abc');
    },
  );

  test('outbox builder strips local composite conversation ids before server sync', () {
    final message = Message(
      id: const Uuid().v4(),
      conversationId:
          'a2f6b8c9-1122-4a55-8822-b98765432101:c3d4e5f6-3344-5b66-9933-a12345678902',
      senderId: 'user-123',
      content: 'siema',
      isMine: true,
      createdAt: DateTime.utc(2024, 1, 1, 10, 0),
    );

    final event = buildOutboxEventPayload(message, 'device-abc');
    final payload = event['payload'] as Map<String, dynamic>;

    expect(event['conversation_id'], isNull);
    expect(payload['conversation_id'], isNull);
  });

  test('encryption should fail hard when no session key exists', () async {
    final secureStorage = SecureStorageService(
      const FlutterSecureStorage(),
      logger,
    );
    final crypto = E2eeCryptoService(
      secureStorage,
      logger,
      ApiClient(dio: Dio(), storage: secureStorage, logger: logger),
      DeviceInfoService(logger),
      DriftSignalProtocolStore(database),
    );

    await expectLater(
      crypto.encryptMessage('missing-session-conversation', 'plain text'),
      throwsA(isA<EncryptionFailureException>()),
    );
  });

  test(
    'repository should persist remote conversations to local db and expose them via stream',
    () async {
      final secureStorage = SecureStorageService(
        const FlutterSecureStorage(),
        logger,
      );
      final apiClient = ChatsApiClient(
        ApiClient(dio: Dio(), storage: secureStorage, logger: logger),
      );
      final crypto = E2eeCryptoService(
        secureStorage,
        logger,
        ApiClient(dio: Dio(), storage: secureStorage, logger: logger),
        DeviceInfoService(logger),
        DriftSignalProtocolStore(database),
      );

      final repository = ChatsRepositoryImpl(
        apiClient,
        database,
        logger,
        'user-123',
        DeviceInfoService(logger),
        crypto,
      );

      await repository.saveConversationsFromRemote([
        ConversationDto(
          id: 'conv-1',
          type: 'direct',
          title: 'Alice',
          lastSequence: 2,
          members: const [
            ConversationMemberDto(
              id: 'member-1',
              conversationId: 'conv-1',
              userId: 'me',
              role: 'admin',
              lastReadSequence: 2,
            ),
          ],
          messages: [
            MessageDto(
              id: 'msg-1',
              conversationId: 'conv-1',
              senderId: 'alice',
              senderDeviceId: 'device-1',
              type: 'text',
              sequence: 1,
              version: 1,
              encryptedPayload: 'hello',
              createdAt: DateTime(2024, 1, 1, 10, 0),
            ),
          ],
          updatedAt: DateTime(2024, 1, 1, 10, 5),
        ),
      ]);

      final conversations = await repository.watchConversations().first;
      final firstConversation = conversations.first;
      final firstMessage = firstConversation.messages?.firstWhere(
        (m) => m != null,
      );

      expect(conversations, isNotEmpty);
      expect(firstConversation.id, 'conv-1');
      expect(firstConversation.messages, isNotEmpty);
      expect(firstMessage, isNotNull);
      expect(firstMessage!.content, 'hello');
    },
  );
}
