// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) => _MessageDto(
  id: json['id'] as String,
  conversationId: json['conversation_id'] as String,
  senderId: json['sender_id'] as String,
  senderDeviceId: json['sender_device_id'] as String?,
  type: json['type'] as String,
  sequence: (json['sequence'] as num?)?.toInt() ?? 0,
  version: (json['version'] as num?)?.toInt() ?? 1,
  encryptedPayload: json['encrypted_payload'] as String? ?? '',
  nonce: json['nonce'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MessageDtoToJson(_MessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'sender_id': instance.senderId,
      'sender_device_id': instance.senderDeviceId,
      'type': instance.type,
      'sequence': instance.sequence,
      'version': instance.version,
      'encrypted_payload': instance.encryptedPayload,
      'nonce': instance.nonce,
      'created_at': instance.createdAt.toIso8601String(),
    };
