// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) => _MessageDto(
  id: json['id'] as String,
  conversationId: json['conversationId'] as String,
  senderId: json['senderId'] as String,
  senderDeviceId: json['senderDeviceId'] as String?,
  type: json['type'] as String,
  sequence: (json['sequence'] as num?)?.toInt() ?? 0,
  version: (json['version'] as num?)?.toInt() ?? 1,
  encryptedPayload: json['encryptedPayload'] as String? ?? '',
  nonce: json['nonce'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$MessageDtoToJson(_MessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'senderId': instance.senderId,
      'senderDeviceId': instance.senderDeviceId,
      'type': instance.type,
      'sequence': instance.sequence,
      'version': instance.version,
      'encryptedPayload': instance.encryptedPayload,
      'nonce': instance.nonce,
      'createdAt': instance.createdAt.toIso8601String(),
    };
