import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messages/message_list.dart';

void main() {
  Message message({
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

  group('MessageList', () {
    testWidgets('renders date separators only at actual day boundaries', (
      tester,
    ) async {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final twoDaysAgo = now.subtract(const Duration(days: 2));

      final messages = [
        message(id: 'older', createdAt: twoDaysAgo, content: 'older message'),
        message(
          id: 'yesterday',
          createdAt: yesterday,
          content: 'yesterday message',
        ),
        message(
          id: 'today',
          createdAt: now,
          content: 'today message',
          isMine: true,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: MessageList(messages: messages)),
        ),
      );

      final expectedTwoDaysAgo =
          '${twoDaysAgo.day.toString().padLeft(2, '0')}.${twoDaysAgo.month.toString().padLeft(2, '0')}.${twoDaysAgo.year}';

      expect(find.text('older message'), findsOneWidget);
      expect(find.text('yesterday message'), findsOneWidget);
      expect(find.text('today message'), findsOneWidget);
      expect(find.text('Dzisiaj'), findsOneWidget);
      expect(find.text('Wczoraj'), findsOneWidget);
      expect(find.text(expectedTwoDaysAgo), findsOneWidget);
    });

    testWidgets('keeps stable rendering when older messages are prepended', (
      tester,
    ) async {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));
      final twoDaysAgo = today.subtract(const Duration(days: 2));

      final initialMessages = [
        message(id: 'current', createdAt: yesterday, content: 'current'),
        message(id: 'new', createdAt: today, content: 'new', isMine: true),
      ];

      final updatedMessages = [
        message(id: 'oldest', createdAt: twoDaysAgo, content: 'oldest'),
        ...initialMessages,
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: MessageList(messages: initialMessages)),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: MessageList(messages: updatedMessages)),
        ),
      );

      expect(find.text('oldest'), findsOneWidget);
      expect(find.text('new'), findsOneWidget);
      expect(find.text('current'), findsOneWidget);
      expect(find.byType(MessageList), findsOneWidget);
    });

    testWidgets(
      'supports appending newer messages without losing existing rows',
      (tester) async {
        final baseTime = DateTime.now();

        final messages = [
          message(id: 'first', createdAt: baseTime, content: 'first'),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageList(messages: messages)),
          ),
        );

        final nextMessages = [
          ...messages,
          message(
            id: 'second',
            createdAt: baseTime.add(const Duration(minutes: 1)),
            content: 'second',
            isMine: true,
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageList(messages: nextMessages)),
          ),
        );

        expect(find.text('first'), findsOneWidget);
        expect(find.text('second'), findsOneWidget);
      },
    );
  });
}
