// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
  id: _readUserId(json, 'id') as String,
  email: _readEmail(json, 'email') as String? ?? '',
  displayName: _readDisplayName(json, 'displayName') as String? ?? '',
  status: json['status'] as String? ?? 'ACTIVE',
  role: json['role'] as String? ?? 'CITIZEN',
  permissions:
      (_readPermissions(json, 'permissions') as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  lastLogin: json['last_login'] as String?,
);

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'displayName': instance.displayName,
  'status': instance.status,
  'role': instance.role,
  'permissions': instance.permissions,
  'last_login': instance.lastLogin,
};
