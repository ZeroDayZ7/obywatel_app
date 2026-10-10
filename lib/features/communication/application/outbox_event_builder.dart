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
  final safeOutboxEventId =
      outboxEventId ?? buildOutboxEventIdForMessage(message: message);

  final payload = {
    'event_id': safeOutboxEventId,
    'idempotency_key': safeOutboxEventId,
    'message_id': message.id,
    'event_type': 'SEND_MESSAGE',
    'conversation_id': message.conversationId,
    'sender_device_id': deviceId,
    'ciphertext': ciphertext,
    'type': signalType,
    'content': '',
    'created_at': createdAt,
    'outbox_event_id': safeOutboxEventId,
  };

  debugPrint('=== OUTBOX EVENT DEBUG ===');
  debugPrint(jsonEncode(payload));
  debugPrint('========================');

  return payload;
}
