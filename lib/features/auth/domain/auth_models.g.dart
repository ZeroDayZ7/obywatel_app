// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  userId: json['user_id'] as String,
  displayName: _readDisplayName(json, 'displayName') as String,
  lastLogin: _readLastLogin(json, 'lastLogin') as String? ?? '',
  role: json['role'] as String? ?? 'CITIZEN',
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'displayName': instance.displayName,
      'lastLogin': instance.lastLogin,
      'role': instance.role,
    };

_RbacData _$RbacDataFromJson(Map<String, dynamic> json) => _RbacData(
  permissions:
      (_readPermissions(json, 'permissions') as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  workContext: json['workContext'] as String?,
);

Map<String, dynamic> _$RbacDataToJson(_RbacData instance) => <String, dynamic>{
  'permissions': instance.permissions,
  'workContext': instance.workContext,
};
