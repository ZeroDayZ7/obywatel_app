import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messages/date_divider.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messages/message_bubble.dart';

class MessageList extends StatelessWidget {
  const MessageList({super.key, required this.messages, this.controller});

  final List<Message> messages;
  final ScrollController? controller;

  bool _shouldShowDateDivider(Message current, Message? previous) {
    if (previous == null) return true;
    final currentDate = DateTime(
      current.createdAt.year,
      current.createdAt.month,
      current.createdAt.day,
    );
    final previousDate = DateTime(
      previous.createdAt.year,
      previous.createdAt.month,
      previous.createdAt.day,
    );
    return currentDate != previousDate;
  }

  @override
  Widget build(BuildContext context) {
    final orderedMessages = [...messages]
      ..sort((a, b) {
        final createdAtOrder = a.createdAt.compareTo(b.createdAt);
        if (createdAtOrder != 0) {
          return createdAtOrder;
        }
        return a.id.compareTo(b.id);
      });

    return ListView.builder(
      controller: controller,
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: orderedMessages.length,
      itemBuilder: (context, index) {
        final renderedIndex = orderedMessages.length - 1 - index;
        final message = orderedMessages[renderedIndex];
        final previousMessage = renderedIndex == 0
            ? null
            : orderedMessages[renderedIndex - 1];
        final showDivider = _shouldShowDateDivider(message, previousMessage);

        return Column(
          key: ValueKey('message-list-row-${message.id}'),
          children: [
            if (showDivider) DateDivider(date: message.createdAt),
            MessageBubble(message: message),
          ],
        );
      },
    );
  }
}
