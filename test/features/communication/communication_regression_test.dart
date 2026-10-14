import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/crypto/drift_signal_protocol_store.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/clients/app_websocket_client.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/communication/application/chat_sync_service.dart';
import 'package:obywatel_plus/features/communication/application/e2ee_crypto_service.dart';
import 'package:obywatel_plus/features/communication/application/messaging_activation_controller.dart';
import 'package:obywatel_plus/features/communication/application/sync_status.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_ws_client.dart';
import 'package:obywatel_plus/features/communication/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/communication/data/dtos/messaging_activation_dto.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
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
  Future<List<ConversationDto>> getConversations() async => const <ConversationDto>[];
}

class TestChatRepository extends ChatsRepositoryImpl {
  TestChatRepository({
    required ChatsApiClient apiClient,
    required AppDatabase db,
    required AppLogger logger,
    required DeviceInfoService deviceInfoService,
    required E2eeCryptoService cryptoService,
    required SecureStorageService secureStorage,
    this.pendingMessagesFactory,
  }) : super(
          apiClient,
          db,
          logger,
          'user-1',
          deviceInfoService,
          cryptoService,
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

  group('MessagingActivationState.copyWith', () {
    test('copyWith keeps previous values unless a value is explicitly provided', () {
      const initial = MessagingActivationState(
        status: null,
        terms: null,
        errorMessage: 'old error',
      );

      final updated = initial.copyWith();

      expect(updated.status, isNull);
      expect(updated.terms, isNull);
      expect(updated.errorMessage, 'old error');
    });

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
    test('currentStatus and callback signal syncing while async flush is in progress', () async {
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
        secureStorage: secureStorage,
        pendingMessagesFactory: () async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return <Message>[];
        },
      );

      final statuses = <SyncStatus>[];
      final service = ChatSyncService(
        chatsApiClient,
        ChatsWsClient(
          AppWebSocketClient(logger: logger),
          logger,
          deviceInfoService,
        ),
        repository,
        logger,
        deviceInfoService,
        statuses.add,
      );

      final future = service.syncPendingData();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(service.currentStatus, SyncStatus.syncing);
      expect(statuses.last, SyncStatus.syncing);

      await future;
      expect(service.currentStatus, SyncStatus.idle);
      expect(statuses, contains(SyncStatus.idle));
    });

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
        secureStorage: secureStorage,
      );
      repository.pendingMessagesFactory = () async {
        throw StateError('boom');
      };

      final statuses = <SyncStatus>[];
      final service = ChatSyncService(
        chatsApiClient,
        ChatsWsClient(
          AppWebSocketClient(logger: logger),
          logger,
          deviceInfoService,
        ),
        repository,
        logger,
        deviceInfoService,
        statuses.add,
      );

      await service.syncPendingData();

      expect(service.currentStatus, SyncStatus.error);
      expect(statuses, contains(SyncStatus.error));
    });

    test('valid UUID conversationId is sent while unresolved local IDs stay queued', () async {
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

      final service = ChatSyncService(
        chatsApiClient,
        ChatsWsClient(
          AppWebSocketClient(logger: logger),
          logger,
          deviceInfoService,
        ),
        repository,
        logger,
        deviceInfoService,
        (_) {},
      );

      await service.syncPendingData();

      expect(chatsApiClient.sentBatches, isNotEmpty);
      expect(chatsApiClient.sentBatches.single, hasLength(1));
      expect(
        chatsApiClient.sentBatches.single.first['conversationId'],
        '123e4567-e89b-42d3-a456-426614174000',
      );
    });
  });
}
