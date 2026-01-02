// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSession _$UserSessionFromJson(Map<String, dynamic> json) => _UserSession(
  id: (json['id'] as num).toInt(),
  deviceName: json['device_name_encrypted'] as String,
  platform: json['platform'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  fingerprint: json['fingerprint'] as String,
  location: json['location'] as String?,
  isCurrent: json['isCurrent'] as bool? ?? false,
);

Map<String, dynamic> _$UserSessionToJson(_UserSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'device_name_encrypted': instance.deviceName,
      'platform': instance.platform,
      'created_at': instance.createdAt.toIso8601String(),
      'fingerprint': instance.fingerprint,
      'location': instance.location,
      'isCurrent': instance.isCurrent,
    };
