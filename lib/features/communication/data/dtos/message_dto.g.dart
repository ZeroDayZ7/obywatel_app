// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

String _safeStringFromJson(Object? value) => value?.toString() ?? '';
String? _safeNullableStringFromJson(Object? value) => value?.toString();

_MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) => _MessageDto(
  id: _safeStringFromJson(json['id']),
  conversationId: _safeStringFromJson(json['conversationId']),
  senderId: _safeStringFromJson(json['senderId']),
  senderDeviceId: _safeNullableStringFromJson(json['senderDeviceId']),
  type: _safeStringFromJson(json['type']),
  sequence: (json['sequence'] as num?)?.toInt() ?? 0,
  version: (json['version'] as num?)?.toInt() ?? 1,
  encryptedPayload: _safeNullableStringFromJson(json['encryptedPayload']) ?? '',
  nonce: _safeNullableStringFromJson(json['nonce']),
  createdAt: json['createdAt'] == null
      ? DateTime.fromMillisecondsSinceEpoch(0)
      : DateTime.parse(json['createdAt'] as String),
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
