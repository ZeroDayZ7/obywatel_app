import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/crypto/drift_signal_protocol_store.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/chats/application/e2ee_crypto_service.dart';
import 'package:obywatel_plus/features/chats/application/outbox_event_builder.dart';
import 'package:obywatel_plus/features/chats/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/chats/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/chats/data/dtos/message_dto.dart';
import 'package:obywatel_plus/features/chats/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/chats/domain/models/message.dart';

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

  test('device identity should stay stable per installation', () async {
    const secureStorage = FlutterSecureStorage();
    await secureStorage.deleteAll();

    final deviceInfoService = DeviceInfoService(logger);
    final firstDeviceId = await deviceInfoService.getOrCreateDeviceId();
    final secondDeviceId = await deviceInfoService.getOrCreateDeviceId();

    expect(firstDeviceId, isNotEmpty);
    expect(secondDeviceId, equals(firstDeviceId));
  });

  test('outbox event payload should match backend contract and keep ciphertext nested', () {
    final message = Message(
      id: 'event-123',
      conversationId: 'conv-123',
      senderId: 'user-123',
      content: 'ciphertext-payload',
      isMine: true,
      createdAt: DateTime.utc(2024, 1, 1, 10, 0),
    );

    final event = buildOutboxEventPayload(message, 'device-abc');

    expect(event['event_id'], 'event-123');
    expect(event['event_type'], 'SEND_MESSAGE');
    expect(event['payload'], isA<Map<String, dynamic>>());
    expect((event['payload'] as Map<String, dynamic>)['content'], 'ciphertext-payload');
    expect(event['device_id'], 'device-abc');
  });

  test('encryption should fail hard when no session key exists', () async {
    final secureStorage = SecureStorageService(
      const FlutterSecureStorage(),
      logger,
    );
    final crypto = E2eeCryptoService(
      secureStorage,
      logger,
      ApiClient(
        dio: Dio(),
        storage: secureStorage,
        logger: logger,
      ),
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
      final apiClient = ChatsApiClient(
        ApiClient(
          dio: Dio(),
          storage: SecureStorageService(
            const FlutterSecureStorage(),
            logger,
          ),
          logger: logger,
        ),
      );

      final repository = ChatsRepositoryImpl(
        apiClient,
        database,
        logger,
        'user-123',
        DeviceInfoService(logger),
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
      final firstMessage = firstConversation.messages?.firstWhere((m) => m != null);

      expect(conversations, isNotEmpty);
      expect(firstConversation.id, 'conv-1');
      expect(firstConversation.messages, isNotEmpty);
      expect(firstMessage, isNotNull);
      expect(firstMessage!.content, 'hello');
    },
  );
}
