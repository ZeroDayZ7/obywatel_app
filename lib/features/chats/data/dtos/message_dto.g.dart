// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) => _MessageDto(
  id: json['ID'] as String,
  conversationId: json['ConversationID'] as String,
  senderId: json['SenderID'] as String,
  senderDeviceId: json['SenderDeviceID'] as String?,
  type: json['Type'] as String,
  sequence: (json['Sequence'] as num?)?.toInt() ?? 0,
  version: (json['Version'] as num?)?.toInt() ?? 1,
  encryptedPayload: json['EncryptedPayload'] as String? ?? '',
  nonce: json['Nonce'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MessageDtoToJson(_MessageDto instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'ConversationID': instance.conversationId,
      'SenderID': instance.senderId,
      'SenderDeviceID': instance.senderDeviceId,
      'Type': instance.type,
      'Sequence': instance.sequence,
      'Version': instance.version,
      'EncryptedPayload': instance.encryptedPayload,
      'Nonce': instance.nonce,
      'created_at': instance.createdAt.toIso8601String(),
    };
