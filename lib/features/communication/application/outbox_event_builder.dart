import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:uuid/uuid.dart';

String _normalizeUuidString(String value, {String? fallback}) {
  final trimmed = value.trim();
  if (trimmed.isNotEmpty && Uuid.isValidUUID(fromString: trimmed)) {
    return trimmed;
  }
  return fallback ?? const Uuid().v4();
}

String buildOutboxEventIdForMessage({required Message message}) {
  return _normalizeUuidString(message.id, fallback: const Uuid().v4());
}

String? _normalizeConversationIdForServer(String conversationId) {
  final trimmed = conversationId.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  return Uuid.isValidUUID(fromString: trimmed) ? trimmed : null;
}

Map<String, dynamic> buildOutboxEventPayload(
  Message message,
  String deviceId, {
  String? encryptedContent,
  String? outboxEventId,
  int signalType = 1,
}) {
  final createdAt = message.createdAt.toUtc().toIso8601String();
  final ciphertext = encryptedContent ?? message.encryptedPayload;
  final safeMessageId = _normalizeUuidString(
    message.id,
    fallback: const Uuid().v4(),
  );
  final safeOutboxEventId = _normalizeUuidString(
    outboxEventId ?? message.id,
    fallback: const Uuid().v4(),
  );
  final normalizedConversationId = _normalizeConversationIdForServer(
    message.conversationId,
  );

  final nestedPayload = {
    'event_id': safeOutboxEventId,
    'idempotency_key': safeOutboxEventId,
    'message_id': safeMessageId,
    'event_type': 'SEND_MESSAGE',
    'conversation_id': normalizedConversationId,
    'sender_device_id': deviceId,
    'device_id': deviceId,
    'ciphertext': ciphertext,
    'type': signalType,
    'created_at': createdAt,
    'outbox_event_id': safeOutboxEventId,
  };

  return {
    'event_id': safeOutboxEventId,
    'idempotency_key': safeOutboxEventId,
    'message_id': safeMessageId,
    'event_type': 'SEND_MESSAGE',
    'conversation_id': normalizedConversationId,
    'sender_device_id': deviceId,
    'device_id': deviceId,
    'payload': nestedPayload,
    'type': signalType,
    'created_at': createdAt,
    'outbox_event_id': safeOutboxEventId,
  };
}
