// lib/features/auth/domain/models/auth_user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

Object? _readUserId(Map<dynamic, dynamic> json, String key) {
  return json['user_id'] ?? json['id'] ?? '';
}

Object? _readDisplayName(Map<dynamic, dynamic> json, String key) {
  return json['display_name'] ?? json['username'] ?? '';
}

Object? _readPermissions(Map<dynamic, dynamic> json, String key) {
  final val = json['permissions'];
  if (val is List) {
    return val.map((e) => e.toString()).toList();
  }
  return <String>[];
}

Object? _readEmail(Map<dynamic, dynamic> json, String key) {
  return json['email'] ?? json['username'] ?? '';
}

@freezed
sealed class AuthUser with _$AuthUser {
  const factory AuthUser({
    @JsonKey(readValue: _readUserId) required String id,
    @JsonKey(readValue: _readEmail) @Default('') String email,
    @JsonKey(readValue: _readDisplayName) @Default('') String displayName,
    @Default('ACTIVE') String status,
    @Default('CITIZEN') String role,
    @JsonKey(readValue: _readPermissions) @Default([]) List<String> permissions,
    @JsonKey(name: 'last_login') String? lastLogin,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}

extension AuthUserX on AuthUser {
  bool hasPermission(String permission) => permissions.contains(permission);
  bool hasRole(String targetRole) => role == targetRole || role == 'root';
}