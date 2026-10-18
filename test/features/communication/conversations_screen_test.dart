import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/domain/chats/conversation.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/conversations/conversation_preview.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/conversations/conversation_tile.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/conversations/conversation_time_formatter.dart';

void main() {
  Message message({
    required String id,
    required String content,
    required DateTime createdAt,
    String encryptedPayload = '',
    String? attachmentId,
  }) {
    return Message(
      id: id,
      conversationId: 'conversation-1',
      senderId: 'user-1',
      content: content,
      encryptedPayload: encryptedPayload,
      attachmentId: attachmentId,
      isMine: true,
      createdAt: createdAt,
    );
  }

  group('Conversation helpers', () {
    test('uses the newest safe message as preview', () {
      final conversation = Conversation(
        id: 'conversation-1',
        type: 'direct',
        messages: [
          message(
            id: 'old-message',
            content: 'old preview',
            createdAt: DateTime(2024, 1, 1, 9, 0),
          ),
          message(
            id: 'new-message',
            content: 'latest preview',
            createdAt: DateTime(2024, 1, 1, 10, 0),
          ),
        ],
      );

      expect(
        ConversationPreview.previewTextForConversation(conversation),
        'latest preview',
      );
    });

    test('does not expose encrypted payload as readable preview', () {
      final conversation = Conversation(
        id: 'conversation-1',
        type: 'direct',
        messages: [
          message(
            id: 'encrypted',
            content: '',
            encryptedPayload: 'ciphertext',
            createdAt: DateTime(2024, 1, 1, 10, 0),
          ),
        ],
      );

      expect(
        ConversationPreview.previewTextForConversation(conversation),
        'Wiadomość zaszyfrowana',
      );
    });

    test('returns neutral placeholder for missing updatedAt', () {
      expect(ConversationTimeFormatter.formatTime(null), '—');
    });
  });

  group('ConversationTile', () {
    testWidgets('renders short conversation ids safely', (tester) async {
      final conversation = Conversation(
        id: 'abc',
        type: 'direct',
        messages: const [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ConversationTile(conversation: conversation)),
        ),
      );

      expect(find.text('Konwersacja #abc'), findsOneWidget);
    });

    testWidgets('invokes tap callback when selected', (tester) async {
      var tapped = false;
      final conversation = Conversation(
        id: 'conversation-1',
        type: 'direct',
        title: 'Alpha',
        messages: const [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConversationTile(
              conversation: conversation,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });

    testWidgets('keeps list rendering stable after updates', (tester) async {
      final first = Conversation(
        id: 'conversation-1',
        type: 'direct',
        title: 'First',
        messages: const [],
      );
      final second = Conversation(
        id: 'conversation-2',
        type: 'direct',
        title: 'Second',
        messages: const [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                ConversationTile(key: ValueKey(first.id), conversation: first),
                ConversationTile(
                  key: ValueKey(second.id),
                  conversation: second,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                ConversationTile(key: ValueKey(first.id), conversation: first),
                ConversationTile(
                  key: ValueKey(second.id),
                  conversation: second,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
    });
  });
}
