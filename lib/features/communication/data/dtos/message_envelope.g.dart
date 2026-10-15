// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_envelope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageEnvelope _$MessageEnvelopeFromJson(Map<String, dynamic> json) =>
    _MessageEnvelope(
      messageId: json['messageId'] as String?,
      conversationId: json['conversationId'] as String?,
      senderUserId: json['senderUserId'] as String?,
      senderDeviceId: json['senderDeviceId'] as String?,
      recipientUserId: json['recipientUserId'] as String?,
      recipientDeviceId: json['recipientDeviceId'] as String?,
      ciphertext: json['ciphertext'] as String?,
      type: (json['type'] as num?)?.toInt(),
      nonce: json['nonce'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      version: (json['version'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$MessageEnvelopeToJson(_MessageEnvelope instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'conversationId': instance.conversationId,
      'senderUserId': instance.senderUserId,
      'senderDeviceId': instance.senderDeviceId,
      'recipientUserId': instance.recipientUserId,
      'recipientDeviceId': instance.recipientDeviceId,
      'ciphertext': instance.ciphertext,
      'type': instance.type,
      'nonce': instance.nonce,
      'createdAt': instance.createdAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'version': instance.version,
    };
