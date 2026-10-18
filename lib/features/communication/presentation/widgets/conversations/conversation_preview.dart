import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/communication/domain/chats/conversation.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';

class ConversationPreview extends StatelessWidget {
  final Conversation conversation;

  const ConversationPreview({super.key, required this.conversation});

  static Message? _lastMessage(Conversation conversation) {
    final messages = conversation.messages ?? const <Message?>[];
    for (var index = messages.length - 1; index >= 0; index--) {
      final message = messages[index];
      if (message != null) {
        return message;
      }
    }
    return null;
  }

  static String previewTextForConversation(Conversation conversation) {
    final lastMessage = _lastMessage(conversation);
    if (lastMessage == null) {
      return 'Brak podglądu';
    }

    final content = lastMessage.content.trim();
    if (content.isNotEmpty) {
      return content;
    }

    if ((lastMessage.attachmentId ?? '').trim().isNotEmpty) {
      return '📎 Załącznik';
    }

    return 'Wiadomość zaszyfrowana';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final previewText = previewTextForConversation(conversation);

    return Row(
      children: [
        Icon(Icons.shield_outlined, size: 14, color: colorScheme.primary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            previewText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
