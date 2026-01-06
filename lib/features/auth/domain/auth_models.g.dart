// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  userId: json['uid'] as String,
  role: json['role'] as String,
  displayName: json['displayName'] as String,
  lastLogin: json['lastLogin'] as String,
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'uid': instance.userId,
      'role': instance.role,
      'displayName': instance.displayName,
      'lastLogin': instance.lastLogin,
    };

_RbacData _$RbacDataFromJson(Map<String, dynamic> json) => _RbacData(
  permissions: (json['permissions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  workContext: json['workContext'] as String?,
);

Map<String, dynamic> _$RbacDataToJson(_RbacData instance) => <String, dynamic>{
  'permissions': instance.permissions,
  'workContext': instance.workContext,
};
