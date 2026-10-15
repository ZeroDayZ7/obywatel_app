import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:uuid/uuid.dart';

String _normalizeUuidString(String value, {String? fallback}) {
  final trimmed = value.trim();
  if (trimmed.isNotEmpty && Uuid.isValidUUID(fromString: trimmed)) {
    return trimmed;
  }
  return fallback ?? const Uuid().v7();
}

String buildOutboxEventIdForMessage({required Message message}) {
  return _normalizeUuidString(message.id, fallback: const Uuid().v7());
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
  String appDeviceId, {
  String? encryptedContent,
  String? outboxEventId,
  int signalType = 1,
}) {
  final sanitizedAppDeviceId = appDeviceId.trim();
  if (sanitizedAppDeviceId.isEmpty) {
    throw StateError(
      'App device UUID is required for SEND_MESSAGE outbox payload; never pass a numeric Signal device ID here',
    );
  }

  final createdAt = message.createdAt.toUtc().toIso8601String();
  final ciphertext = (encryptedContent ?? message.encryptedPayload).trim();
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
  final normalizedAttachmentId = (message.attachmentId ?? '').trim();

  if (normalizedConversationId == null || normalizedConversationId.isEmpty) {
    throw StateError(
      'SEND_MESSAGE outbox payload requires a valid conversation UUID and ciphertext. Refusing to create an invalid outbox record.',
    );
  }

  if (ciphertext.isEmpty) {
    throw StateError(
      'SEND_MESSAGE outbox payload requires a non-empty ciphertext. Refusing to create an invalid outbox record.',
    );
  }

  return {
    'eventId': safeOutboxEventId,
    'idempotencyKey': safeOutboxEventId,
    'messageId': safeMessageId,
    'eventType': 'SEND_MESSAGE',
    'conversationId': normalizedConversationId,
    'senderDeviceId': sanitizedAppDeviceId,
    'attachmentId': normalizedAttachmentId.isEmpty ? null : normalizedAttachmentId,
    'ciphertext': ciphertext,
    'type': signalType,
    'createdAt': createdAt,
  };
}
