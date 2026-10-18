import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/storage/local_attachment_store.dart';
import 'package:obywatel_plus/core/storage/local_attachment_store_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/features/communication/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/chats/conversation.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/domain/outbox/outbox_event.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/chats_repository.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messages/message_bubble.dart';

class _CountingAttachmentStore extends LocalAttachmentStore {
  _CountingAttachmentStore() : _thumbnails = <String, Uint8List>{};

  final Map<String, Uint8List> _thumbnails;
  int readThumbnailCalls = 0;

  @override
  Future<Uint8List?> readThumbnail(String attachmentId) async {
    readThumbnailCalls += 1;
    return _thumbnails[attachmentId];
  }

  @override
  Future<void> saveThumbnail({
    required String attachmentId,
    required Uint8List bytes,
  }) async {
    _thumbnails[attachmentId] = Uint8List.fromList(bytes);
  }
}

class _FakeSecureStorage extends SecureStorageService {
  _FakeSecureStorage() : super(const FlutterSecureStorage(), AppLogger());
}

class _PreviewRepository implements ChatsRepository {
  const _PreviewRepository();

  @override
  Stream<List<Conversation>> watchConversations() => const Stream.empty();

  @override
  Stream<List<Message>> watchMessagesForConversation(String conversationId) =>
      const Stream.empty();

  @override
  Future<List<Conversation>> getConversations() async => const <Conversation>[];

  @override
  Future<String> resolvePeerUserIdForConversation(String conversationId) async =>
      '';

  @override
  Future<String> ensureSelfConversation() async => '';

  @override
  Future<String> ensureConversationForContact(
    String contactUserId, {
    String? title,
  }) async => '';

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
  Future<Map<String, dynamic>?> getAttachmentMetadata(String attachmentId) async =>
      null;

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
  Future<List<Message>> getPendingOutboxMessages() async => const <Message>[];

  @override
  Future<List<OutboxEvent>> getRetryEligibleOutboxEvents({
    DateTime? referenceTime,
  }) async => const <OutboxEvent>[];

  @override
  Future<void> deleteInvalidOutboxEvents(List<String> ids) async {}

  @override
  Future<OutboxEvent?> getOutboxEventById(String id) async => null;

  @override
  Future<void> scheduleOutboxRetry(
    String id, {
    required int retryCount,
    DateTime? referenceTime,
  }) async {}

  @override
  Future<List<Map<String, dynamic>>> syncDeltaFromRemote({
    int lastKnownContactVersion = 0,
    int lastKnownMessageVersion = 0,
  }) async => const <Map<String, dynamic>>[];

  @override
  Future<void> clearSentOutboxMessages(List<String> messageIds) async {}

  @override
  Future<List<Conversation>> saveConversationsFromRemote(
    List<ConversationDto> dtos,
  ) async => const <Conversation>[];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'rebuilding the same attachment widget does not trigger the same thumbnail read twice',
    (tester) async {
      const attachmentId = 'aaa11111-1111-4111-8111-111111111111';
      final store = _CountingAttachmentStore();
      await store.saveThumbnail(
        attachmentId: attachmentId,
        bytes: Uint8List.fromList(<int>[1, 2, 3, 4]),
      );
      store.readThumbnailCalls = 0;

      final message = Message(
        id: 'msg-1',
        conversationId: 'conversation-1',
        senderId: 'user-1',
        content: '',
        isMine: true,
        createdAt: DateTime.utc(2026, 1, 1),
        status: 'sent',
        isEncrypted: false,
        attachmentId: attachmentId,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localAttachmentStoreProvider.overrideWithValue(store),
            secureStorageProvider.overrideWithValue(_FakeSecureStorage()),
            chatsRepositoryProvider.overrideWithValue(const _PreviewRepository()),
          ],
          child: MaterialApp(home: MessageBubble(message: message)),
        ),
      );
      await tester.pump();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localAttachmentStoreProvider.overrideWithValue(store),
            secureStorageProvider.overrideWithValue(_FakeSecureStorage()),
            chatsRepositoryProvider.overrideWithValue(const _PreviewRepository()),
          ],
          child: MaterialApp(home: MessageBubble(message: message)),
        ),
      );
      await tester.pump();

      expect(store.readThumbnailCalls, 1,
          reason: 'The same attachmentId should reuse the shared preview future after the first render.');
    },
  );

  testWidgets(
    'parallel widgets for one attachment share the same preview request',
    (tester) async {
      const attachmentId = 'bbb22222-2222-4222-8222-222222222222';
      final store = _CountingAttachmentStore();
      await store.saveThumbnail(
        attachmentId: attachmentId,
        bytes: Uint8List.fromList(<int>[10, 20, 30]),
      );
      final message = Message(
        id: 'msg-2',
        conversationId: 'conversation-1',
        senderId: 'user-1',
        content: '',
        isMine: true,
        createdAt: DateTime.utc(2026, 1, 2),
        status: 'sent',
        isEncrypted: false,
        attachmentId: attachmentId,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localAttachmentStoreProvider.overrideWithValue(store),
            secureStorageProvider.overrideWithValue(_FakeSecureStorage()),
            chatsRepositoryProvider.overrideWithValue(const _PreviewRepository()),
          ],
          child: MaterialApp(
            home: Column(
              children: [
                MessageBubble(message: message),
                MessageBubble(message: message),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(store.readThumbnailCalls, 1,
          reason: 'The same attachmentId must be coalesced across parallel widget instances.');
    },
  );

  testWidgets(
    'different attachment ids remain independent',
    (tester) async {
      final store = _CountingAttachmentStore();
      await store.saveThumbnail(
        attachmentId: 'ccc33333-3333-4333-8333-333333333333',
        bytes: Uint8List.fromList(<int>[1, 2, 3]),
      );
      await store.saveThumbnail(
        attachmentId: 'ddd44444-4444-4444-8444-444444444444',
        bytes: Uint8List.fromList(<int>[4, 5, 6]),
      );
      final first = Message(
        id: 'msg-3',
        conversationId: 'conversation-1',
        senderId: 'user-1',
        content: '',
        isMine: true,
        createdAt: DateTime.utc(2026, 1, 3),
        status: 'sent',
        isEncrypted: false,
        attachmentId: 'ccc33333-3333-4333-8333-333333333333',
      );
      final second = Message(
        id: 'msg-4',
        conversationId: 'conversation-1',
        senderId: 'user-1',
        content: '',
        isMine: true,
        createdAt: DateTime.utc(2026, 1, 4),
        status: 'sent',
        isEncrypted: false,
        attachmentId: 'ddd44444-4444-4444-8444-444444444444',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localAttachmentStoreProvider.overrideWithValue(store),
            secureStorageProvider.overrideWithValue(_FakeSecureStorage()),
            chatsRepositoryProvider.overrideWithValue(const _PreviewRepository()),
          ],
          child: MaterialApp(
            home: Column(
              children: [
                MessageBubble(message: first),
                MessageBubble(message: second),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(store.readThumbnailCalls, 2,
          reason: 'Different attachmentIds should not share one preview task.');
    },
  );
}
