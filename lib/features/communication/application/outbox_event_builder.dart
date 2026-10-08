import 'package:obywatel_plus/features/communication/domain/chats/message.dart';

String buildOutboxEventIdForMessage(Message message) {
  final value = message.id;
  return value.startsWith('evt-') ? value : 'evt-$value';
}

Map<String, dynamic> buildOutboxEventPayload(
  Message message,
  String deviceId, {
  String? encryptedContent,
  String? outboxEventId,
}) {
  final createdAt = message.createdAt.toUtc().toIso8601String();
  final payloadContent = encryptedContent ?? message.content;
  final safeOutboxEventId = outboxEventId ?? buildOutboxEventIdForMessage(message);

  return {
    'event_id': safeOutboxEventId,
    'message_id': message.id,
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
      'outbox_event_id': safeOutboxEventId,
    },
    'created_at': createdAt,
    'outbox_event_id': safeOutboxEventId,
  };
}
