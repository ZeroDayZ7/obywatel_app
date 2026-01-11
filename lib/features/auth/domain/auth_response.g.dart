// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TwoFaRequired _$TwoFaRequiredFromJson(Map<String, dynamic> json) =>
    _TwoFaRequired(
      twoFaToken: json['twoFaToken'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$TwoFaRequiredToJson(_TwoFaRequired instance) =>
    <String, dynamic>{
      'twoFaToken': instance.twoFaToken,
      'runtimeType': instance.$type,
    };

_PreTrust _$PreTrustFromJson(Map<String, dynamic> json) => _PreTrust(
  setupToken: json['setupToken'] as String,
  challenge: json['challenge'] as String,
  isTrusted: json['isTrusted'] as bool? ?? false,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$PreTrustToJson(_PreTrust instance) => <String, dynamic>{
  'setupToken': instance.setupToken,
  'challenge': instance.challenge,
  'isTrusted': instance.isTrusted,
  'runtimeType': instance.$type,
};

_FullSuccess _$FullSuccessFromJson(Map<String, dynamic> json) => _FullSuccess(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  user: UserProfile.fromJson(json['user'] as Map<String, dynamic>),
  rbac: RbacData.fromJson(json['rbac'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$FullSuccessToJson(_FullSuccess instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
      'rbac': instance.rbac,
      'runtimeType': instance.$type,
    };
