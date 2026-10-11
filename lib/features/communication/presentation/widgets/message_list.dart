import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/communication/domain/models/message.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/date_divider.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/message_bubble.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;
  final ScrollController? controller;

  const MessageList({
    super.key,
    required this.messages,
    this.controller,
  });

  List<Message> get _orderedMessages {
    final ordered = [...messages];
    ordered.sort((left, right) {
      final timeCompare = left.createdAt.compareTo(right.createdAt);
      if (timeCompare != 0) return timeCompare;
      return left.id.compareTo(right.id);
    });
    return ordered;
  }

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
    final orderedMessages = _orderedMessages;

    return ListView.builder(
      controller: controller,
      reverse: false,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: orderedMessages.length,
      itemBuilder: (context, index) {
        final message = orderedMessages[index];
        final previousMessage = index > 0 ? orderedMessages[index - 1] : null;

        final showDivider = _shouldShowDateDivider(message, previousMessage);

        return Column(
          children: [
            if (showDivider) DateDivider(date: message.createdAt),
            MessageBubble(message: message),
          ],
        );
      },
    );
  }
}
