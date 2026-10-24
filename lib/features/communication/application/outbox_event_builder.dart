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

Map<String, dynamic> messageToOutboxJson(
  Message message,
  String deviceId, {
  required int signalType,
  String? messageId,
  String? outboxEventId,
}) {
  final resolvedMessageId = (messageId != null && messageId.trim().isNotEmpty)
      ? messageId
      : message.id;
  final resolvedEventId =
      (outboxEventId != null && outboxEventId.trim().isNotEmpty)
      ? outboxEventId
      : message.id;

  return buildOutboxEventPayload(
    message.copyWith(id: resolvedMessageId),
    deviceId,
    encryptedContent: message.encryptedPayload,
    outboxEventId: resolvedEventId,
    signalType: signalType,
  );
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
  required int signalType,
  String? encryptedContent,
  String? outboxEventId,
}) {
  final sanitizedAppDeviceId = appDeviceId.trim();
  if (sanitizedAppDeviceId.isEmpty) {
    throw StateError(
      'App device UUID is required for SEND_MESSAGE outbox payload; never pass a numeric Signal device ID here',
    );
  }

  if (signalType <= 0) {
    throw StateError(
      'SEND_MESSAGE outbox payload requires a valid positive signalType. Missing or invalid signal type must not be silently defaulted.',
    );
  }

  final createdAt = message.createdAt.toUtc().toIso8601String();
  final ciphertext = (encryptedContent ?? message.encryptedPayload).trim();
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
    'messageId': message.id,
    'eventType': 'SEND_MESSAGE',
    'conversationId': normalizedConversationId,
    'senderDeviceId': sanitizedAppDeviceId,
    'attachmentId': normalizedAttachmentId.isEmpty
        ? null
        : normalizedAttachmentId,
    'ciphertext': ciphertext,
    'type': signalType,
    'createdAt': createdAt,
  };
}
