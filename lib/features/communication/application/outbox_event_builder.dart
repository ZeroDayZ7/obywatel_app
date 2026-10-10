import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:uuid/uuid.dart';

String buildOutboxEventIdForMessage({required Message message}) {
  final value = message.id.trim();
  if (value.isEmpty) {
    return const Uuid().v7();
  }
  return value;
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
  final payloadContent = message.content.trim().isNotEmpty
      ? message.content
      : ciphertext;
  final safeOutboxEventId =
      outboxEventId ?? buildOutboxEventIdForMessage(message: message);

  final nestedPayload = {
    'event_id': safeOutboxEventId,
    'idempotency_key': safeOutboxEventId,
    'message_id': message.id,
    'event_type': 'SEND_MESSAGE',
    'conversation_id': message.conversationId,
    'sender_device_id': deviceId,
    'device_id': deviceId,
    'ciphertext': ciphertext,
    'type': signalType,
    'content': payloadContent,
    'created_at': createdAt,
    'outbox_event_id': safeOutboxEventId,
  };

  final event = {
    'event_id': safeOutboxEventId,
    'idempotency_key': safeOutboxEventId,
    'message_id': message.id,
    'event_type': 'SEND_MESSAGE',
    'conversation_id': message.conversationId,
    'sender_device_id': deviceId,
    'device_id': deviceId,
    'payload': nestedPayload,
    'type': signalType,
    'created_at': createdAt,
    'outbox_event_id': safeOutboxEventId,
  };

  debugPrint('[OUTBOX-FLOW-1] buildOutboxEventPayload start');
  debugPrint(
    '[OUTBOX-FLOW-1.1] conversation_id=${message.conversationId} signal_type=$signalType ciphertext_len=${ciphertext.length}',
  );
  debugPrint('=== OUTBOX EVENT DEBUG ===');
  debugPrint(jsonEncode(event));
  debugPrint('========================');

  return event;
}
