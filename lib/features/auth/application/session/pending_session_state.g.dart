// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_session_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PendingSession _$PendingSessionFromJson(Map<String, dynamic> json) =>
    _PendingSession(
      accessToken: json['accessToken'] as String?,
      setupToken: json['setupToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      rbac: json['rbac'] == null
          ? null
          : RbacData.fromJson(json['rbac'] as Map<String, dynamic>),
      devicePublicKey: json['devicePublicKey'] as String?,
    );

Map<String, dynamic> _$PendingSessionToJson(_PendingSession instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'setupToken': instance.setupToken,
      'refreshToken': instance.refreshToken,
      'userId': instance.userId,
      'userName': instance.userName,
      'rbac': instance.rbac,
      'devicePublicKey': instance.devicePublicKey,
    };
