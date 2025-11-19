// features/chat/models/chat_message.dart
enum MessageStatus { sent, delivered, read }

class ChatMessage {
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final MessageStatus status;
  final String? imageUrl;

  ChatMessage({
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.status = MessageStatus.sent,
    this.imageUrl,
  });
}
