// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageRecord _$MessageRecordFromJson(Map<String, dynamic> json) =>
    _MessageRecord(
      id: json['id'] as String?,
      messageId: json['messageId'] as String?,
      conversationId: json['conversationId'] as String?,
      senderUserId: json['senderUserId'] as String?,
      senderDeviceId: json['senderDeviceId'] as String?,
      recipientUserId: json['recipientUserId'] as String?,
      recipientDeviceId: json['recipientDeviceId'] as String?,
      ciphertext: json['ciphertext'] as String?,
      type: json['type'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      isDelivered: json['isDelivered'] as bool? ?? false,
      version: (json['version'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$MessageRecordToJson(_MessageRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'messageId': instance.messageId,
      'conversationId': instance.conversationId,
      'senderUserId': instance.senderUserId,
      'senderDeviceId': instance.senderDeviceId,
      'recipientUserId': instance.recipientUserId,
      'recipientDeviceId': instance.recipientDeviceId,
      'ciphertext': instance.ciphertext,
      'type': instance.type,
      'createdAt': instance.createdAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'isDelivered': instance.isDelivered,
      'version': instance.version,
    };
