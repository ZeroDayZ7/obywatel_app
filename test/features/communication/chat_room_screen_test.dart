import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/chats/conversation.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/domain/outbox/outbox_event.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/chats_repository.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/active_chat_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/screens/chat_room_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messages/message_list.dart';

class _FakeChatsRepository implements ChatsRepository {
  _FakeChatsRepository(this._messageStream);

  final Stream<List<Message>> _messageStream;

  @override
  Stream<List<Conversation>> watchConversations() => const Stream.empty();

  @override
  Stream<List<Message>> watchMessagesForConversation(String conversationId) =>
      _messageStream;

  @override
  Future<List<Conversation>> getConversations() async => const <Conversation>[];

  @override
  Future<String> resolvePeerUserIdForConversation(
    String conversationId,
  ) async => 'peer-user';

  @override
  Future<String> ensureSelfConversation() async => 'self';

  @override
  Future<String> ensureConversationForContact(
    String contactUserId, {
    String? title,
  }) async => 'contact';

  @override
  Future<void> ensureE2eeSessionForContact(String contactUserId) async {}

  @override
  Future<List<Message>> getMessageHistory(
    String conversationId, {
    String? beforeId,
    int limit = 50,
  }) async => const <Message>[];

  @override
  Future<void> markConversationAsRead(String conversationId) async {}

  @override
  Future<void> sendMessage({
    required String conversationId,
    required String content,
    String? attachmentId,
  }) async {}

  @override
  Future<Map<String, dynamic>?> getAttachmentMetadata(
    String attachmentId,
  ) async => null;

  @override
  Future<String?> getAttachmentKey(String attachmentId) async => null;

  @override
  Future<void> saveAttachmentKey({
    required String attachmentId,
    required String attachmentKey,
  }) async {}

  @override
  Future<void> deleteAttachmentKey(String attachmentId) async {}

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

Message _message({
  required String id,
  required DateTime createdAt,
  required String content,
  bool isMine = false,
}) {
  return Message(
    id: id,
    conversationId: 'conversation-1',
    senderId: isMine ? 'me' : 'other',
    content: content,
    isMine: isMine,
    createdAt: createdAt,
  );
}

void main() {
  testWidgets('initial history does not show unread badge', (tester) async {
    final stream = Stream<List<Message>>.value([
      _message(
        id: 'm1',
        createdAt: DateTime(2024, 1, 1, 9, 0),
        content: 'initial message',
      ),
    ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chatsRepositoryProvider.overrideWith(
            (ref) => _FakeChatsRepository(stream),
          ),
          chatE2eeSessionStatusProvider(
            'conversation-1',
          ).overrideWith((ref) => Future.value(E2eeSessionUiStatus.ready)),
        ],
        child: const MaterialApp(
          home: ChatRoomScreen(
            conversationId: 'conversation-1',
            title: 'Room title',
          ),
        ),
      ),
    );

    await tester.pump();

    expect(
      find.text('Brak wiadomości. Rozpocznij konwersację.'),
      isNot(findsOneWidget),
    );
    expect(find.textContaining('Nowe wiadomości'), isNot(findsOneWidget));
    expect(find.byType(MessageList), findsOneWidget);
  });

  testWidgets('empty initial provider state does not create unread badge', (
    tester,
  ) async {
    final stream = Stream<List<Message>>.value(const <Message>[]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chatsRepositoryProvider.overrideWith(
            (ref) => _FakeChatsRepository(stream),
          ),
          chatE2eeSessionStatusProvider(
            'conversation-1',
          ).overrideWith((ref) => Future.value(E2eeSessionUiStatus.ready)),
        ],
        child: const MaterialApp(
          home: ChatRoomScreen(
            conversationId: 'conversation-1',
            title: 'Room title',
          ),
        ),
      ),
    );

    await tester.pump();

    expect(
      find.text('Brak wiadomości. Rozpocznij konwersację.'),
      findsOneWidget,
    );
    expect(find.textContaining('Nowe wiadomości'), isNot(findsOneWidget));
  });
}
