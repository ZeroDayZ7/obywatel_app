import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messages/date_divider.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messages/message_bubble.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messages/message_list.dart';

void main() {
  group('MessageList ordering and date dividers', () {
    testWidgets('renders the provided message order without re-sorting', (
      tester,
    ) async {
      final messages = [
        Message(
          id: 'msg-200',
          conversationId: 'conversation-1',
          senderId: 'user-2',
          content: 'third',
          isMine: false,
          createdAt: DateTime(2024, 1, 2, 9, 0),
          status: 'sent',
        ),
        Message(
          id: 'msg-100',
          conversationId: 'conversation-1',
          senderId: 'user-1',
          content: 'first',
          isMine: true,
          createdAt: DateTime(2024, 1, 1, 9, 0),
          status: 'sent',
        ),
        Message(
          id: 'msg-300',
          conversationId: 'conversation-1',
          senderId: 'user-2',
          content: 'last',
          isMine: false,
          createdAt: DateTime(2024, 1, 3, 9, 0),
          status: 'sent',
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: MessageList(messages: messages)),
        ),
      );

      final renderedIds = tester
          .widgetList<MessageBubble>(find.byType(MessageBubble))
          .map((bubble) => bubble.message.id)
          .toList();

      expect(renderedIds, ['msg-200', 'msg-100', 'msg-300']);
      expect(find.byType(DateDivider), findsNWidgets(3));
    });

    testWidgets('keeps the upstream chronological contract and date division', (
      tester,
    ) async {
      final messages = [
        Message(
          id: 'msg-010',
          conversationId: 'conversation-1',
          senderId: 'user-1',
          content: 'older',
          isMine: true,
          createdAt: DateTime(2024, 1, 1, 9, 0),
          status: 'sent',
        ),
        Message(
          id: 'msg-020',
          conversationId: 'conversation-1',
          senderId: 'user-2',
          content: 'same-day tie-breaker',
          isMine: false,
          createdAt: DateTime(2024, 1, 1, 9, 0),
          status: 'sent',
        ),
        Message(
          id: 'msg-030',
          conversationId: 'conversation-1',
          senderId: 'user-1',
          content: 'new day',
          isMine: true,
          createdAt: DateTime(2024, 1, 2, 9, 0),
          status: 'sent',
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: MessageList(messages: messages)),
        ),
      );

      final renderedIds = tester
          .widgetList<MessageBubble>(find.byType(MessageBubble))
          .map((bubble) => bubble.message.id)
          .toList();

      expect(renderedIds, ['msg-010', 'msg-020', 'msg-030']);
      expect(find.byType(DateDivider), findsNWidgets(2));
      expect(find.text('01.01.2024'), findsOneWidget);
      expect(find.text('02.01.2024'), findsOneWidget);
    });
  });
}
