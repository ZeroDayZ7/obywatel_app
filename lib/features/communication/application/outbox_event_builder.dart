import 'package:obywatel_plus/features/communication/domain/chats/message.dart';

Map<String, dynamic> buildOutboxEventPayload(
  Message message,
  String deviceId, {
  String? encryptedContent,
}) {
  final createdAt = message.createdAt.toUtc().toIso8601String();
  final payloadContent = encryptedContent ?? message.content;

  return {
    'event_id': message.id,
    'event_type': 'SEND_MESSAGE',
    'conversation_id': message.conversationId,
    'device_id': deviceId,
    'payload': {
      'message_id': message.id,
      'conversation_id': message.conversationId,
      'sender_id': message.senderId,
      'content': payloadContent,
      'created_at': createdAt,
      'is_encrypted': true,
    },
    'created_at': createdAt,
  };
}
