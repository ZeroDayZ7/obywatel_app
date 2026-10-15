// lib/features/communication/data/dtos/message_envelope.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_envelope.freezed.dart';
part 'message_envelope.g.dart';

@freezed
abstract class MessageEnvelope with _$MessageEnvelope {
  const factory MessageEnvelope({
    String? messageId,
    String? conversationId,
    String? senderUserId,
    String? senderDeviceId,
    String? recipientUserId,
    String? recipientDeviceId,
    String? ciphertext,
    int? type,
    String? nonce,
    DateTime? createdAt,
    DateTime? expiresAt,
    @Default(1) int version,
  }) = _MessageEnvelope;

  factory MessageEnvelope.fromJson(Map<String, dynamic> json) =>
      _$MessageEnvelopeFromJson(json);
}