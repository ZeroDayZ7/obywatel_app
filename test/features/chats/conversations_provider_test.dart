import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/domain/chats/conversation.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/conversations_provider.dart';

void main() {
  group('Conversations provider message merging', () {
    test(
      'does not duplicate a message already present in the local conversation state',
      () {
        final existing = Message(
          id: 'msg-1',
          conversationId: 'conv-1',
          senderId: 'user-a',
          content: 'hello',
          encryptedPayload: 'ciphertext',
          isMine: true,
          createdAt: DateTime.utc(2026, 1, 1, 12, 0),
          status: 'sent',
          isEncrypted: true,
        );

        final conversation = Conversation(
          id: 'conv-1',
          type: 'direct',
          title: 'Peer',
          messages: [existing],
        );

        final merged = Conversations.mergeIncomingMessageIntoConversation(
          conversation,
          existing,
        );

        expect(
          merged
              .where((message) => message != null && message.id == 'msg-1')
              .length,
          1,
        );
      },
    );

    test(
      'deduplicates logical duplicates that share sender and timestamp but differ by local/server id',
      () {
        final localPending = Message(
          id: 'client-uuid-1',
          conversationId: 'conv-1',
          senderId: 'user-a',
          content: 'hello',
          encryptedPayload: 'ciphertext-a',
          isMine: true,
          createdAt: DateTime.utc(2026, 1, 1, 12, 0),
          status: 'pending',
          isEncrypted: true,
        );

        final serverSent = Message(
          id: 'server-uuid-1',
          conversationId: 'conv-1',
          senderId: 'user-a',
          content: 'hello',
          encryptedPayload: 'ciphertext-a',
          isMine: true,
          createdAt: DateTime.utc(2026, 1, 1, 12, 0, 1),
          status: 'sent',
          isEncrypted: true,
        );

        final conversation = Conversation(
          id: 'conv-1',
          type: 'direct',
          title: 'Peer',
          messages: [localPending],
        );

        final merged = Conversations.mergeIncomingMessageIntoConversation(
          conversation,
          serverSent,
        );

        expect(
          merged
              .where(
                (message) => message != null && message.content == 'hello',
              )
              .length,
          1,
        );
        expect(
          merged.any((message) => message != null && message.status == 'sent'),
          isTrue,
        );
      },
    );
  });
}
