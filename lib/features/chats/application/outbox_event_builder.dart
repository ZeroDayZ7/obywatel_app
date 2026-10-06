import 'package:obywatel_plus/features/chats/domain/models/message.dart';

Map<String, dynamic> buildOutboxEventPayload(Message message, String deviceId) {
  final createdAt = message.createdAt.toUtc().toIso8601String();

  return {
    'event_id': message.id,
    'event_type': 'SEND_MESSAGE',
    'conversation_id': message.conversationId,
    'device_id': deviceId,
    'payload': {
      'message_id': message.id,
      'conversation_id': message.conversationId,
      'sender_id': message.senderId,
      'content': message.content,
      'created_at': createdAt,
      'is_encrypted': true,
    },
    'created_at': createdAt,
  };
}
