// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) => _MessageDto(
  id: json['id'] as String,
  conversationId: json['conversation_id'] as String,
  senderId: json['sender_id'] as String,
  encryptedPayload: json['encrypted_payload'] as String,
  nonce: json['nonce'] as String,
  sequenceNumber: (json['sequence_number'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MessageDtoToJson(_MessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'sender_id': instance.senderId,
      'encrypted_payload': instance.encryptedPayload,
      'nonce': instance.nonce,
      'sequence_number': instance.sequenceNumber,
      'created_at': instance.createdAt.toIso8601String(),
    };
