// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
  id: json['user_id'] as String,
  email: json['email'] as String,
  displayName: json['display_name'] as String,
  status: json['status'] as String,
  role: json['role'] as String,
  permissions:
      (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  lastLogin: json['last_login'] as String?,
);

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
  'user_id': instance.id,
  'email': instance.email,
  'display_name': instance.displayName,
  'status': instance.status,
  'role': instance.role,
  'permissions': instance.permissions,
  'last_login': instance.lastLogin,
};
