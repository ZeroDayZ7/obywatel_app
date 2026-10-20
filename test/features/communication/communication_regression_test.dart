import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/crypto/drift_signal_protocol_store.dart';
import 'package:obywatel_plus/core/crypto/symmetric_crypto.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/clients/app_websocket_client.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/communication/application/chat_sync_service.dart';
import 'package:obywatel_plus/features/communication/application/e2ee_crypto_service.dart';
import 'package:obywatel_plus/features/communication/application/messaging_activation_controller.dart';
import 'package:obywatel_plus/features/communication/application/outbox/outbox_processor.dart';
import 'package:obywatel_plus/features/communication/application/sync_status.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/communication/data/dtos/messaging_activation_dto.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_utils.dart';
import 'package:obywatel_plus/features/communication/domain/chats/conversation.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';

class TestChatApiClient extends ChatsApiClient {
  TestChatApiClient({required ApiClient client}) : super(client);

  List<List<Map<String, dynamic>>> sentBatches = <List<Map<String, dynamic>>>[];

  @override
  Future<void> sendOutboxBatch(List<Map<String, dynamic>> payload) async {
    sentBatches.add(payload);
  }

  @override
  Future<List<ConversationDto>> getConversations() async =>
      const <ConversationDto>[];
}

class TestChatRepository extends ChatsRepositoryImpl {
  TestChatRepository({
    required ChatsApiClient apiClient,
    required AppDatabase db,
    required AppLogger logger,
    required DeviceInfoService deviceInfoService,
    required E2eeCryptoService cryptoService,
    required SymmetricCrypto symmetricCrypto,
    required SecureStorageService secureStorage,
    this.pendingMessagesFactory,
  }) : super(
         apiClient,
         db,
         logger,
         'user-1',
         deviceInfoService,
         cryptoService,
         symmetricCrypto,
         secureStorage,
       );

  Future<List<Message>> Function()? pendingMessagesFactory;
  List<String> clearedIds = <String>[];
  List<Map<String, dynamic>> lastSyncedDelta = const <Map<String, dynamic>>[];

  @override
  Future<List<Message>> getPendingOutboxMessages() async {
    if (pendingMessagesFactory != null) {
      return pendingMessagesFactory!();
    }
    return const <Message>[];
  }

  @override
  Future<List<Map<String, dynamic>>> syncDeltaFromRemote({
    int lastKnownContactVersion = 0,
    int lastKnownMessageVersion = 0,
  }) async {
    return lastSyncedDelta;
  }

  @override
  Future<List<Conversation>> saveConversationsFromRemote(
    List<ConversationDto> dtos,
  ) async {
    return const <Conversation>[];
  }

  @override
  Future<void> clearSentOutboxMessages(List<String> messageIds) async {
    clearedIds.addAll(messageIds);
  }
}

Message _makeMessage({
  required String id,
  required String conversationId,
  required String encryptedPayload,
  String status = 'pending',
}) {
  return Message(
    id: id,
    conversationId: conversationId,
    senderId: 'user-1',
    content: encryptedPayload,
    isMine: true,
    createdAt: DateTime.utc(2026, 10, 14, 12, 0, 0),
    status: status,
    isEncrypted: true,
    encryptedPayload: encryptedPayload,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final secureStorageStore = <String, String>{};
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
        (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'read':
              final key = methodCall.arguments['key'] as String?;
              return secureStorageStore[key];
            case 'write':
              final key = methodCall.arguments['key'] as String?;
              final value = methodCall.arguments['value'] as String?;
              if (key != null && value != null) {
                secureStorageStore[key] = value;
              }
              return null;
            case 'delete':
              final key = methodCall.arguments['key'] as String?;
              if (key != null) {
                secureStorageStore.remove(key);
              }
              return null;
            case 'readAll':
              return Map<String, String>.from(secureStorageStore);
            case 'deleteAll':
              secureStorageStore.clear();
              return null;
            default:
              return null;
          }
        },
      );

  group('attachment metadata persistence', () {
    test('saveAttachmentMetadata stores metadata in Drift and getAttachmentMetadata can read it back', () async {
      final db = AppDatabase(NativeDatabase.memory());
      final logger = AppLogger();
      final secureStorage = SecureStorageService(
        const FlutterSecureStorage(
          aOptions: AndroidOptions(resetOnError: false),
        ),
        logger,
      );
      final repo = ChatsRepositoryImpl(
        TestChatApiClient(client: ApiClient(dio: Dio(), storage: secureStorage, logger: logger)),
        db,
        logger,
        'user-1',
        DeviceInfoService(logger),
        E2eeCryptoService(
          secureStorage,
          logger,
          ApiClient(dio: Dio(), storage: secureStorage, logger: logger),
          DeviceInfoService(logger),
          DriftSignalProtocolStore(db, logger: logger),
        ),
        SymmetricCrypto(logger),
        secureStorage,
      );

      final messageId = 'msg-attachment-1';
      await db.into(db.messages).insert(
        MessagesCompanion(
          id: drift.Value(messageId),
          conversationId: const drift.Value('conv-1'),
          senderId: const drift.Value('user-2'),
          senderDeviceId: const drift.Value('device-2'),
          attachmentId: const drift.Value('attachment-1'),
          encryptedPayload: drift.Value(utf8.encode('ciphertext')),
          content: const drift.Value(''),
        ),
      );

      await repo.saveAttachmentMetadata(
        attachmentId: 'attachment-1',
        messageId: messageId,
        originalFileName: 'photo.png',
        mimeType: 'image/png',
        sizeBytes: 123,
        sha256: 'abc123',
        status: 'ready',
        isAvailableLocally: true,
        hasThumbnail: false,
      );

      final metadata = await repo.getAttachmentMetadata('attachment-1');
      expect(metadata, isNotNull);
      expect(metadata!['contentType'], 'image/png');
      expect(metadata['fileName'], 'photo.png');
      expect(metadata['size'], 123);
      expect(metadata['sha256'], 'abc123');
    });

    test('getAttachmentMetadata ignores SecureStorage metadata and reads only from Drift', () async {
      final db = AppDatabase(NativeDatabase.memory());
      final logger = AppLogger();
      final secureStorage = SecureStorageService(
        const FlutterSecureStorage(
          aOptions: AndroidOptions(resetOnError: false),
        ),
        logger,
      );
      final repo = ChatsRepositoryImpl(
        TestChatApiClient(client: ApiClient(dio: Dio(), storage: secureStorage, logger: logger)),
        db,
        logger,
        'user-1',
        DeviceInfoService(logger),
        E2eeCryptoService(
          secureStorage,
          logger,
          ApiClient(dio: Dio(), storage: secureStorage, logger: logger),
          DeviceInfoService(logger),
          DriftSignalProtocolStore(db, logger: logger),
        ),
        SymmetricCrypto(logger),
        secureStorage,
      );

      final attachmentId = 'attachment-drift-only';
      final driftMetadata = {
        'attachmentId': attachmentId,
        'originalFilename': 'drift.png',
        'contentType': 'image/png',
        'fileName': 'drift.png',
        'size': 321,
        'sha256': 'drift-hash',
        'status': 'ready',
        'isAvailableLocally': false,
        'hasThumbnail': false,
      };
      await db.into(db.messages).insert(
        MessagesCompanion(
          id: drift.Value('msg-drift-only'),
          conversationId: const drift.Value('conv-drift-only'),
          senderId: const drift.Value('user-2'),
          senderDeviceId: const drift.Value('device-2'),
          attachmentId: const drift.Value.absent(),
          encryptedPayload: drift.Value(utf8.encode('ciphertext')),
          content: const drift.Value(''),
          mediaHeader: drift.Value(utf8.encode(jsonEncode(driftMetadata))),
        ),
      );
      await secureStorage.write(
        key: '$attachmentId-attachment-meta',
        value: jsonEncode({'fileName': 'legacy.png', 'contentType': 'image/jpeg'}),
      );

      final metadata = await repo.getAttachmentMetadata(attachmentId);
      expect(metadata, isNotNull);
      expect(metadata!['fileName'], 'drift.png');
      expect(metadata['contentType'], 'image/png');
      expect(metadata['sha256'], 'drift-hash');
    });

    test('upload-before-message persists metadata in Drift and blocks empty overwrite', () async {
      final db = AppDatabase(NativeDatabase.memory());
      final logger = AppLogger();
      final secureStorage = SecureStorageService(
        const FlutterSecureStorage(
          aOptions: AndroidOptions(resetOnError: false),
        ),
        logger,
      );
      final repo = ChatsRepositoryImpl(
        TestChatApiClient(client: ApiClient(dio: Dio(), storage: secureStorage, logger: logger)),
        db,
        logger,
        'user-1',
        DeviceInfoService(logger),
        E2eeCryptoService(
          secureStorage,
          logger,
          ApiClient(dio: Dio(), storage: secureStorage, logger: logger),
          DeviceInfoService(logger),
          DriftSignalProtocolStore(db, logger: logger),
        ),
        SymmetricCrypto(logger),
        secureStorage,
      );

      const attachmentId = '99aa8727-ddee-4297-99f7-56e6111a9a20';
      const messageId = '01a14a4c-0a04-7e58-ae6d-7ddded22ab83';

      await repo.saveAttachmentMetadata(
        attachmentId: attachmentId,
        originalFileName: 'S (1).jpg',
        mimeType: 'image/jpeg',
        sizeBytes: 2048,
        sha256: 'hash-123',
        status: 'uploaded',
        isAvailableLocally: true,
        hasThumbnail: false,
      );

      final initialMetadata = await repo.getAttachmentMetadata(attachmentId);
      expect(initialMetadata, isNotNull);
      expect(initialMetadata!['fileName'], 'S (1).jpg');
      expect(initialMetadata['contentType'], 'image/jpeg');
      expect(initialMetadata['size'], 2048);
      expect(initialMetadata['sha256'], 'hash-123');

      await db.into(db.messages).insert(
        MessagesCompanion(
          id: drift.Value(messageId),
          conversationId: const drift.Value('conv-upload-before-message'),
          senderId: const drift.Value('user-2'),
          senderDeviceId: const drift.Value('device-2'),
          attachmentId: const drift.Value(attachmentId),
          encryptedPayload: drift.Value(utf8.encode('ciphertext')),
          content: const drift.Value(''),
        ),
      );

      await repo.saveAttachmentMetadata(
        attachmentId: attachmentId,
        messageId: messageId,
        originalFileName: '',
        mimeType: '',
        sizeBytes: 0,
        sha256: '',
        status: 'ready',
        isAvailableLocally: false,
        hasThumbnail: false,
      );

      final finalMetadata = await repo.getAttachmentMetadata(attachmentId);
      expect(finalMetadata, isNotNull);
      expect(finalMetadata!['fileName'], 'S (1).jpg');
      expect(finalMetadata['contentType'], 'image/jpeg');
      expect(finalMetadata['size'], 2048);
      expect(finalMetadata['sha256'], 'hash-123');
    });

    test('receiver keeps full attachment metadata after decrypting E2EE payload', () async {
      final payload = jsonEncode({
        'v': 1,
        'text': 'hello',
        'attachment': {
          'id': '99aa8727-ddee-4297-99f7-56e6111a9a20',
          'key': 'attachment-key',
          'size': 2048,
          'sha256': 'hash-123',
          'contentType': 'image/jpeg',
          'fileName': 'S (1).jpg',
        },
      });

      final parsed = parseDecryptedMessageContent(payload);
      expect(parsed, isNotNull);
      expect(parsed!.attachmentId, '99aa8727-ddee-4297-99f7-56e6111a9a20');
      expect(parsed.fileName, 'S (1).jpg');
      expect(parsed.contentType, 'image/jpeg');
      expect(parsed.size, 2048);
      expect(parsed.sha256, 'hash-123');
    });
  });

  group('MessagingActivationState.copyWith', () {
    test(
      'copyWith keeps previous values unless a value is explicitly provided',
      () {
        const initial = MessagingActivationState(
          status: null,
          terms: null,
          errorMessage: 'old error',
        );

        final updated = initial.copyWith();

        expect(updated.status, isNull);
        expect(updated.terms, isNull);
        expect(updated.errorMessage, 'old error');
      },
    );

    test('copyWith updates values when new ones are provided', () {
      const initial = MessagingActivationState(
        status: null,
        terms: null,
        errorMessage: null,
      );

      final updated = initial.copyWith(
        status: MessagingActivationDto(
          userId: 'user-1',
          status: 'active',
          consentAccepted: true,
          termsVersion: '1',
          currentTermsVersion: '1',
          requiresTermsAcceptance: false,
          deviceId: 'device-1',
          activatedAt: DateTime.utc(2026, 10, 14),
          createdAt: DateTime.utc(2026, 10, 14),
          updatedAt: DateTime.utc(2026, 10, 14),
        ),
        terms: MessagingTermsDto(
          version: '1',
          text: 'body',
          publishedAt: DateTime.utc(2026, 10, 14),
        ),
      );

      expect(updated.status, isNotNull);
      expect(updated.status!.status, 'active');
      expect(updated.terms, isNotNull);
      expect(updated.errorMessage, isNull);
    });

    test('explicit null clears status, terms and errorMessage', () {
      final initial = MessagingActivationState(
        status: MessagingActivationDto(
          userId: 'user-1',
          status: 'active',
          consentAccepted: true,
          termsVersion: '1',
          currentTermsVersion: '1',
          requiresTermsAcceptance: false,
          deviceId: 'device-1',
          activatedAt: DateTime.utc(2026, 10, 14),
          createdAt: DateTime.utc(2026, 10, 14),
          updatedAt: DateTime.utc(2026, 10, 14),
        ),
        terms: MessagingTermsDto(
          version: '1',
          text: 'body',
          publishedAt: DateTime.utc(2026, 10, 14),
        ),
        errorMessage: 'temporary error',
      );

      final cleared = initial.copyWith(
        status: null,
        terms: null,
        errorMessage: null,
      );

      expect(cleared.status, isNull);
      expect(cleared.terms, isNull);
      expect(cleared.errorMessage, isNull);
    });

    test('clearing errorMessage does not touch the other fields', () {
      final initial = MessagingActivationState(
        status: MessagingActivationDto(
          userId: 'user-1',
          status: 'active',
          consentAccepted: true,
          termsVersion: '1',
          currentTermsVersion: '1',
          requiresTermsAcceptance: false,
          deviceId: 'device-1',
          activatedAt: DateTime.utc(2026, 10, 14),
          createdAt: DateTime.utc(2026, 10, 14),
          updatedAt: DateTime.utc(2026, 10, 14),
        ),
        terms: MessagingTermsDto(
          version: '1',
          text: 'body',
          publishedAt: DateTime.utc(2026, 10, 14),
        ),
        errorMessage: 'persisted',
      );

      final updated = initial.copyWith(errorMessage: null);

      expect(updated.status, isNotNull);
      expect(updated.terms, isNotNull);
      expect(updated.errorMessage, isNull);
    });
  });

  group('ChatSyncService', () {
    test(
      'currentStatus and callback signal syncing while async flush is in progress',
      () async {
        final logger = AppLogger();
        final db = AppDatabase(NativeDatabase.memory());
        final secureStorage = SecureStorageService(
          const FlutterSecureStorage(),
          logger,
        );
        final apiClient = ApiClient(
          dio: Dio(),
          storage: secureStorage,
          logger: logger,
        );
        final deviceInfoService = DeviceInfoService(logger);
        final cryptoService = E2eeCryptoService(
          secureStorage,
          logger,
          apiClient,
          deviceInfoService,
          DriftSignalProtocolStore(db),
        );
        final chatsApiClient = TestChatApiClient(client: apiClient);
        final repository = TestChatRepository(
          apiClient: chatsApiClient,
          db: db,
          logger: logger,
          deviceInfoService: deviceInfoService,
          cryptoService: cryptoService,
          symmetricCrypto: SymmetricCrypto(logger),
          secureStorage: secureStorage,
          pendingMessagesFactory: () async {
            await Future<void>.delayed(const Duration(milliseconds: 50));
            return <Message>[];
          },
        );

        final statuses = <SyncStatus>[];
        final service = ChatSyncService(
          chatsApiClient,
          AppWebSocketClient(logger: logger),
          repository,
          logger,
          statuses.add,
          outboxProcessor: OutboxProcessor(
            repository,
            chatsApiClient,
            logger,
            deviceInfoService,
          ),
        );

        final future = service.syncPendingData();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(service.currentStatus, SyncStatus.syncing);
        expect(statuses.last, SyncStatus.syncing);

        await future;
        expect(service.currentStatus, SyncStatus.idle);
        expect(statuses, contains(SyncStatus.idle));
      },
    );

    test('sync fails with error status and keeps final error state', () async {
      final logger = AppLogger();
      final db = AppDatabase(NativeDatabase.memory());
      final secureStorage = SecureStorageService(
        const FlutterSecureStorage(),
        logger,
      );
      final apiClient = ApiClient(
        dio: Dio(),
        storage: secureStorage,
        logger: logger,
      );
      final deviceInfoService = DeviceInfoService(logger);
      final cryptoService = E2eeCryptoService(
        secureStorage,
        logger,
        apiClient,
        deviceInfoService,
        DriftSignalProtocolStore(db),
      );
      final chatsApiClient = TestChatApiClient(client: apiClient);
      final repository = TestChatRepository(
        apiClient: chatsApiClient,
        db: db,
        logger: logger,
        deviceInfoService: deviceInfoService,
        cryptoService: cryptoService,
        symmetricCrypto: SymmetricCrypto(logger),
        secureStorage: secureStorage,
      );
      repository.pendingMessagesFactory = () async {
        throw StateError('boom');
      };

      final statuses = <SyncStatus>[];
      final service = ChatSyncService(
        chatsApiClient,
        AppWebSocketClient(logger: logger),
        repository,
        logger,
        statuses.add,
        outboxProcessor: OutboxProcessor(
          repository,
          chatsApiClient,
          logger,
          deviceInfoService,
        ),
      );

      await service.syncPendingData();

      expect(service.currentStatus, SyncStatus.error);
      expect(statuses, contains(SyncStatus.error));
    });

    test(
      'valid UUID conversationId is sent while unresolved local IDs stay queued',
      () async {
        final logger = AppLogger();
        final db = AppDatabase(NativeDatabase.memory());
        final secureStorage = SecureStorageService(
          const FlutterSecureStorage(),
          logger,
        );
        final apiClient = ApiClient(
          dio: Dio(),
          storage: secureStorage,
          logger: logger,
        );
        final deviceInfoService = DeviceInfoService(logger);
        final cryptoService = E2eeCryptoService(
          secureStorage,
          logger,
          apiClient,
          deviceInfoService,
          DriftSignalProtocolStore(db),
        );
        final chatsApiClient = TestChatApiClient(client: apiClient);
        final repository = TestChatRepository(
          apiClient: chatsApiClient,
          db: db,
          logger: logger,
          deviceInfoService: deviceInfoService,
          cryptoService: cryptoService,
          symmetricCrypto: SymmetricCrypto(logger),
          secureStorage: secureStorage,
          pendingMessagesFactory: () async => <Message>[
            _makeMessage(
              id: '11111111-1111-4111-8111-111111111111',
              conversationId: 'a:b',
              encryptedPayload: 'abc',
            ),
            _makeMessage(
              id: '22222222-2222-4222-8222-222222222222',
              conversationId: '123e4567-e89b-42d3-a456-426614174000',
              encryptedPayload: 'payload',
            ),
          ],
        );

        await db.outboxDao.enqueueEvent(
          OutboxEventsCompanion(
            id: const drift.Value('22222222-2222-4222-8222-222222222222'),
            outboxEventId: const drift.Value(
              '77777777-7777-4777-8777-777777777777',
            ),
            eventType: const drift.Value('SEND_MESSAGE'),
            conversationId: const drift.Value(
              '123e4567-e89b-42d3-a456-426614174000',
            ),
            payload: drift.Value(
              jsonEncode({
                'eventId': '77777777-7777-4777-8777-777777777777',
                'messageId': '22222222-2222-4222-8222-222222222222',
                'conversationId': '123e4567-e89b-42d3-a456-426614174000',
                'ciphertext': 'payload',
                'type': 2,
                'createdAt': '2026-10-14T12:00:00.000Z',
              }),
            ),
            status: const drift.Value('pending'),
            retryCount: const drift.Value(0),
            attemptCount: const drift.Value(0),
            nextAttemptAt: const drift.Value.absent(),
            createdAt: drift.Value(DateTime.utc(2026, 10, 14, 12, 0, 0)),
            updatedAt: drift.Value(DateTime.utc(2026, 10, 14, 12, 0, 0)),
          ),
        );

        final service = ChatSyncService(
          chatsApiClient,
          AppWebSocketClient(logger: logger),
          repository,
          logger,
          (_) {},
          outboxProcessor: OutboxProcessor(
            repository,
            chatsApiClient,
            logger,
            deviceInfoService,
          ),
        );

        await service.syncPendingData();

        expect(chatsApiClient.sentBatches, isNotEmpty);
        expect(chatsApiClient.sentBatches.single, hasLength(1));
        expect(
          chatsApiClient.sentBatches.single.first['conversationId'],
          '123e4567-e89b-42d3-a456-426614174000',
        );
      },
    );

    test('retry preserves stored outbox event id and signal type', () async {
      final logger = AppLogger();
      final db = AppDatabase(NativeDatabase.memory());
      final secureStorage = SecureStorageService(
        const FlutterSecureStorage(),
        logger,
      );
      final apiClient = ApiClient(
        dio: Dio(),
        storage: secureStorage,
        logger: logger,
      );
      final deviceInfoService = DeviceInfoService(logger);
      final cryptoService = E2eeCryptoService(
        secureStorage,
        logger,
        apiClient,
        deviceInfoService,
        DriftSignalProtocolStore(db),
      );
      final chatsApiClient = TestChatApiClient(client: apiClient);
      final repository = ChatsRepositoryImpl(
        chatsApiClient,
        db,
        logger,
        'user-1',
        deviceInfoService,
        cryptoService,
        SymmetricCrypto(logger),
        secureStorage,
      );

      const messageId = '22222222-2222-4222-8222-222222222222';
      const eventId = '33333333-3333-4333-8333-333333333333';
      const conversationId = '123e4567-e89b-42d3-a456-426614174000';
      await db.outboxDao.enqueueEvent(
        OutboxEventsCompanion(
          id: const drift.Value(messageId),
          outboxEventId: const drift.Value(eventId),
          eventType: const drift.Value('SEND_MESSAGE'),
          conversationId: const drift.Value(conversationId),
          payload: drift.Value(
            jsonEncode({
              'eventId': eventId,
              'idempotencyKey': eventId,
              'messageId': messageId,
              'conversationId': conversationId,
              'senderDeviceId': 'device-1',
              'ciphertext': 'retry-payload',
              'type': 3,
              'createdAt': '2026-10-14T12:00:00.000Z',
            }),
          ),
          status: const drift.Value('pending'),
          retryCount: const drift.Value(0),
          attemptCount: const drift.Value(0),
          nextAttemptAt: const drift.Value.absent(),
          createdAt: drift.Value(DateTime.utc(2026, 10, 14, 12, 0, 0)),
          updatedAt: drift.Value(DateTime.utc(2026, 10, 14, 12, 0, 0)),
        ),
      );

      final service = ChatSyncService(
        chatsApiClient,
        AppWebSocketClient(logger: logger),
        repository,
        logger,
        (_) {},
        outboxProcessor: OutboxProcessor(
          repository,
          chatsApiClient,
          logger,
          deviceInfoService,
        ),
      );

      await service.syncPendingData();

      expect(chatsApiClient.sentBatches, isNotEmpty);
      expect(chatsApiClient.sentBatches.single.first['eventId'], eventId);
      expect(
        chatsApiClient.sentBatches.single.first['idempotencyKey'],
        eventId,
      );
      expect(chatsApiClient.sentBatches.single.first['messageId'], messageId);
      expect(chatsApiClient.sentBatches.single.first['type'], 3);
    });

    test(
      'malformed outbox JSON is isolated without blocking valid rows',
      () async {
        final logger = AppLogger();
        final db = AppDatabase(NativeDatabase.memory());
        final secureStorage = SecureStorageService(
          const FlutterSecureStorage(),
          logger,
        );
        final apiClient = ApiClient(
          dio: Dio(),
          storage: secureStorage,
          logger: logger,
        );
        final deviceInfoService = DeviceInfoService(logger);
        final cryptoService = E2eeCryptoService(
          secureStorage,
          logger,
          apiClient,
          deviceInfoService,
          DriftSignalProtocolStore(db),
        );
        final chatsApiClient = TestChatApiClient(client: apiClient);
        final repository = ChatsRepositoryImpl(
          chatsApiClient,
          db,
          logger,
          'user-1',
          deviceInfoService,
          cryptoService,
          SymmetricCrypto(logger),
          secureStorage,
        );

        const goodConversationId = '123e4567-e89b-42d3-a456-426614174000';
        const goodMessageId = '44444444-4444-4444-8444-444444444444';
        await db.outboxDao.enqueueEvent(
          OutboxEventsCompanion(
            id: const drift.Value('bad-entry'),
            outboxEventId: const drift.Value(
              '55555555-5555-4555-8555-555555555555',
            ),
            eventType: const drift.Value('SEND_MESSAGE'),
            conversationId: const drift.Value(goodConversationId),
            payload: const drift.Value('{not valid json'),
            status: const drift.Value('pending'),
            retryCount: const drift.Value(0),
            attemptCount: const drift.Value(0),
            nextAttemptAt: const drift.Value.absent(),
            createdAt: drift.Value(DateTime.utc(2026, 10, 14, 12, 0, 0)),
            updatedAt: drift.Value(DateTime.utc(2026, 10, 14, 12, 0, 0)),
          ),
        );
        await db.outboxDao.enqueueEvent(
          OutboxEventsCompanion(
            id: const drift.Value(goodMessageId),
            outboxEventId: const drift.Value(
              '66666666-6666-4666-8666-666666666666',
            ),
            eventType: const drift.Value('SEND_MESSAGE'),
            conversationId: const drift.Value(goodConversationId),
            payload: drift.Value(
              jsonEncode({
                'eventId': '66666666-6666-4666-8666-666666666666',
                'messageId': goodMessageId,
                'conversationId': goodConversationId,
                'ciphertext': 'valid-payload',
                'type': 1,
                'createdAt': '2026-10-14T12:00:00.000Z',
              }),
            ),
            status: const drift.Value('pending'),
            retryCount: const drift.Value(0),
            attemptCount: const drift.Value(0),
            nextAttemptAt: const drift.Value.absent(),
            createdAt: drift.Value(DateTime.utc(2026, 10, 14, 12, 0, 1)),
            updatedAt: drift.Value(DateTime.utc(2026, 10, 14, 12, 0, 1)),
          ),
        );

        final pending = await repository.getPendingOutboxMessages();

        expect(pending, hasLength(1));
        expect(pending.single.id, goodMessageId);
        expect(pending.single.conversationId, goodConversationId);
      },
    );
  });
}
