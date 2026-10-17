import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/communication/application/outbox/outbox_processor.dart';
import 'package:obywatel_plus/features/communication/application/outbox/outbox_transport_client.dart';
import 'package:obywatel_plus/features/communication/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/communication/domain/chats/conversation.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/domain/outbox/outbox_event.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/chats_repository.dart';
import 'package:uuid/uuid.dart';

class FakeDeviceInfoService extends DeviceInfoService {
  FakeDeviceInfoService() : super(AppLogger());

  @override
  Future<String> getOrCreateDeviceId() async => 'app-device-id';
}

class EmptyDeviceInfoService extends DeviceInfoService {
  EmptyDeviceInfoService() : super(AppLogger());

  @override
  Future<String> getOrCreateDeviceId() async => '';
}

class FakeTransportClient implements OutboxTransportClient {
  FakeTransportClient({this.fail = false});

  final bool fail;
  final List<List<Map<String, dynamic>>> calls = <List<Map<String, dynamic>>>[];

  @override
  Future<void> sendOutboxBatch(List<Map<String, dynamic>> payload) async {
    calls.add(payload);
    if (fail) {
      throw Exception('network');
    }
  }
}

class FakeChatsRepository implements ChatsRepository {
  FakeChatsRepository({
    this.pendingMessages = const <Message>[],
    this.retryEvents = const <OutboxEvent>[],
  });

  List<Message> pendingMessages;
  List<OutboxEvent> retryEvents;
  final List<String> deletedOutboxIds = <String>[];
  final List<String> clearedMessageIds = <String>[];
  final Map<String, OutboxEvent> outboxById = <String, OutboxEvent>{};
  final Map<String, int> scheduledRetries = <String, int>{};

  @override
  Stream<List<Conversation>> watchConversations() => const Stream.empty();

  @override
  Stream<List<Message>> watchMessagesForConversation(String conversationId) =>
      const Stream.empty();

  @override
  Future<List<Conversation>> getConversations() async => const <Conversation>[];

  @override
  Future<String> resolvePeerUserIdForConversation(
    String conversationId,
  ) async => 'peer-user';

  @override
  Future<String> ensureSelfConversation() async => const Uuid().v4();

  @override
  Future<String> ensureConversationForContact(
    String contactUserId, {
    String? title,
  }) async => const Uuid().v4();

  @override
  Future<void> ensureE2eeSessionForContact(String contactUserId) async {}

  @override
  Future<List<Message>> getMessageHistory(
    String conversationId, {
    String? beforeId,
    int limit = 50,
  }) async => const <Message>[];

  @override
  Future<void> sendMessage({
    required String conversationId,
    required String content,
    String? attachmentId,
  }) async {}

  @override
  Future<Map<String, dynamic>?> getAttachmentMetadata(String attachmentId) async => null;

  @override
  Future<void> saveAttachmentMetadata({
    required String attachmentId,
    String? messageId,
    String? originalFileName,
    String? mimeType,
    int sizeBytes = 0,
    String sha256 = '',
    String? localFilePath,
    String? thumbnailPath,
    String status = 'ready',
    bool isAvailableLocally = false,
    bool hasThumbnail = false,
  }) async {}

  @override
  Stream<Message> get incomingMessagesStream => const Stream.empty();

  @override
  Future<List<Message>> getPendingOutboxMessages() async => pendingMessages;

  @override
  Future<List<OutboxEvent>> getRetryEligibleOutboxEvents({
    DateTime? referenceTime,
  }) async => retryEvents;

  @override
  Future<void> deleteInvalidOutboxEvents(List<String> ids) async {
    deletedOutboxIds.addAll(ids);
  }

  @override
  Future<OutboxEvent?> getOutboxEventById(String id) async => outboxById[id];

  @override
  Future<void> scheduleOutboxRetry(
    String id, {
    required int retryCount,
    DateTime? referenceTime,
  }) async {
    scheduledRetries[id] = retryCount;
  }

  @override
  Future<List<Map<String, dynamic>>> syncDeltaFromRemote({
    int lastKnownContactVersion = 0,
    int lastKnownMessageVersion = 0,
  }) async => const <Map<String, dynamic>>[];

  @override
  Future<void> clearSentOutboxMessages(List<String> messageIds) async {
    clearedMessageIds.addAll(messageIds);
  }

  @override
  Future<List<Conversation>> saveConversationsFromRemote(
    List<ConversationDto> dtos,
  ) async => const <Conversation>[];
}

void main() {
  const conversationId = '11111111-1111-4111-8111-111111111111';

  test(
    'OutboxMessageEvent accepts canonical payload and rejects invalid signal type',
    () {
      final payload = <String, dynamic>{
        'messageId': const Uuid().v4(),
        'conversationId': conversationId,
        'ciphertext': 'ciphertext-abc',
        'eventId': const Uuid().v4(),
        'senderDeviceId': 'app-device-id',
        'type': 2,
        'createdAt': DateTime.now().toUtc().toIso8601String(),
      };

      final event = OutboxMessageEvent.fromJson(payload);
      expect(event.signalType, 2);
      expect(event.conversationId, conversationId);

      expect(
        () => OutboxMessageEvent.fromJson({...payload, 'type': '0'}),
        throwsA(isA<FormatException>()),
      );
    },
  );

  test(
    'OutboxProcessor clears only messages that were successfully built and sent',
    () async {
      final messageAId = const Uuid().v4();
      final messageBId = const Uuid().v4();
      final messageA = Message(
        id: messageAId,
        conversationId: conversationId,
        senderId: 'user-1',
        content: 'hello-a',
        encryptedPayload: 'ciphertext-a',
        isMine: true,
        createdAt: DateTime.now().toUtc(),
      );
      final messageB = Message(
        id: messageBId,
        conversationId: conversationId,
        senderId: 'user-1',
        content: 'hello-b',
        encryptedPayload: 'ciphertext-b',
        isMine: true,
        createdAt: DateTime.now().toUtc(),
      );

      final repository = FakeChatsRepository(
        pendingMessages: <Message>[messageA, messageB],
        retryEvents: <OutboxEvent>[
          OutboxEvent(
            id: messageAId,
            payload: jsonEncode({
              'messageId': messageAId,
              'conversationId': conversationId,
              'ciphertext': 'ciphertext-a',
              'eventId': const Uuid().v4(),
              'senderDeviceId': 'app-device-id',
              'type': 2,
              'createdAt': DateTime.now().toUtc().toIso8601String(),
            }),
            conversationId: conversationId,
            retryCount: 0,
          ),
          OutboxEvent(
            id: messageBId,
            payload: jsonEncode({
              'messageId': messageBId,
              'conversationId': conversationId,
              'ciphertext': 'ciphertext-b',
              'eventId': const Uuid().v4(),
              'senderDeviceId': 'app-device-id',
              'type': 2,
              'createdAt': DateTime.now().toUtc().toIso8601String(),
            }),
            conversationId: conversationId,
            retryCount: 0,
          ),
        ],
      );

      final transport = FakeTransportClient();
      final processor = OutboxProcessor(
        repository,
        transport,
        AppLogger(),
        FakeDeviceInfoService(),
      );

      await processor.processPending();

      expect(transport.calls, isNotEmpty);
      expect(
        repository.clearedMessageIds,
        containsAll(<String>[messageAId, messageBId]),
      );
      expect(repository.deletedOutboxIds, isEmpty);
    },
  );

  test(
    'OutboxProcessor does not retry or confirm invalid outbox data',
    () async {
      final messageId = const Uuid().v4();
      final repository = FakeChatsRepository(
        pendingMessages: <Message>[
          Message(
            id: messageId,
            conversationId: conversationId,
            senderId: 'user-1',
            content: 'hello',
            encryptedPayload: 'ciphertext-abc',
            isMine: true,
            createdAt: DateTime.now().toUtc(),
          ),
        ],
        retryEvents: <OutboxEvent>[
          OutboxEvent(
            id: messageId,
            payload: jsonEncode({
              'messageId': messageId,
              'conversationId': conversationId,
              'ciphertext': 'ciphertext-abc',
              'eventId': const Uuid().v4(),
              'senderDeviceId': 'app-device-id',
              'type': 'invalid',
              'createdAt': DateTime.now().toUtc().toIso8601String(),
            }),
            conversationId: conversationId,
            retryCount: 0,
          ),
        ],
      );

      final transport = FakeTransportClient();
      final processor = OutboxProcessor(
        repository,
        transport,
        AppLogger(),
        FakeDeviceInfoService(),
      );

      await processor.processPending();

      expect(transport.calls, isEmpty);
      expect(repository.clearedMessageIds, isEmpty);
      expect(repository.scheduledRetries, isEmpty);
    },
  );

  test(
    'OutboxProcessor skips payload build failures without deleting or retrying',
    () async {
      final messageId = const Uuid().v4();
      final repository = FakeChatsRepository(
        pendingMessages: <Message>[
          Message(
            id: messageId,
            conversationId: conversationId,
            senderId: 'user-1',
            content: 'hello',
            encryptedPayload: 'ciphertext-abc',
            isMine: true,
            createdAt: DateTime.now().toUtc(),
          ),
        ],
        retryEvents: <OutboxEvent>[
          OutboxEvent(
            id: messageId,
            payload: jsonEncode({
              'messageId': messageId,
              'conversationId': conversationId,
              'ciphertext': 'ciphertext-abc',
              'eventId': const Uuid().v4(),
              'senderDeviceId': 'app-device-id',
              'type': 2,
              'createdAt': DateTime.now().toUtc().toIso8601String(),
            }),
            conversationId: conversationId,
            retryCount: 0,
          ),
        ],
      );

      final transport = FakeTransportClient();
      final processor = OutboxProcessor(
        repository,
        transport,
        AppLogger(),
        EmptyDeviceInfoService(),
      );

      await processor.processPending();

      expect(transport.calls, isEmpty);
      expect(repository.clearedMessageIds, isEmpty);
      expect(repository.deletedOutboxIds, isEmpty);
      expect(repository.scheduledRetries, isEmpty);
    },
  );

  test(
    'OutboxProcessor schedules retry only for attempted transport entries',
    () async {
      final messageId = const Uuid().v4();
      final repository = FakeChatsRepository(
        pendingMessages: <Message>[
          Message(
            id: messageId,
            conversationId: conversationId,
            senderId: 'user-1',
            content: 'hello',
            encryptedPayload: 'ciphertext-abc',
            isMine: true,
            createdAt: DateTime.now().toUtc(),
          ),
        ],
        retryEvents: <OutboxEvent>[
          OutboxEvent(
            id: messageId,
            payload: jsonEncode({
              'messageId': messageId,
              'conversationId': conversationId,
              'ciphertext': 'ciphertext-abc',
              'eventId': const Uuid().v4(),
              'senderDeviceId': 'app-device-id',
              'type': 2,
              'createdAt': DateTime.now().toUtc().toIso8601String(),
            }),
            conversationId: conversationId,
            retryCount: 0,
          ),
        ],
      );
      repository.outboxById[messageId] = repository.retryEvents.first;
      final transport = FakeTransportClient(fail: true);
      final processor = OutboxProcessor(
        repository,
        transport,
        AppLogger(),
        FakeDeviceInfoService(),
      );

      await expectLater(processor.processPending(), throwsException);

      expect(repository.clearedMessageIds, isEmpty);
      expect(repository.scheduledRetries[messageId], 1);
    },
  );

  test(
    'OutboxProcessor no-ops when pending queue is empty even if retry rows exist',
    () async {
      final messageId = const Uuid().v4();
      final repository = FakeChatsRepository(
        pendingMessages: const <Message>[],
        retryEvents: <OutboxEvent>[
          OutboxEvent(
            id: messageId,
            payload: jsonEncode({
              'messageId': messageId,
              'conversationId': conversationId,
              'ciphertext': 'ciphertext-abc',
              'eventId': const Uuid().v4(),
              'senderDeviceId': 'app-device-id',
              'type': 2,
              'createdAt': DateTime.now().toUtc().toIso8601String(),
            }),
            conversationId: conversationId,
            retryCount: 0,
          ),
        ],
      );

      final transport = FakeTransportClient();
      final processor = OutboxProcessor(
        repository,
        transport,
        AppLogger(),
        FakeDeviceInfoService(),
      );

      await processor.processPending();

      expect(transport.calls, isEmpty);
      expect(repository.clearedMessageIds, isEmpty);
      expect(repository.scheduledRetries, isEmpty);
    },
  );
}
