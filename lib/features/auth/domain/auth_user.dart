import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

Object? _readUserId(Map<dynamic, dynamic> json, String key) {
  return json['user_id'] ?? json['id'] ?? '';
}

Object? _readUsername(Map<dynamic, dynamic> json, String key) {
  return json['username'] ?? json['display_name'] ?? json['email'] ?? '';
}

Object? _readEmail(Map<dynamic, dynamic> json, String key) {
  return json['email'] ?? json['username'] ?? '';
}

Object? _readDisplayName(Map<dynamic, dynamic> json, String key) {
  return json['display_name'] ?? json['username'] ?? json['email'] ?? '';
}

Object? _readPermissions(Map<dynamic, dynamic> json, String key) {
  final val = json['permissions'];
  if (val is List) {
    return val.map((e) => e.toString()).toList();
  }
  return <String>[];
}

Object? _readLastLogin(Map<dynamic, dynamic> json, String key) {
  return json['last_login'] ?? json['last_login_at'] ?? json['lastLogin'] ?? '';
}

Map<String, dynamic> _normalizeAuthUserJson(Map<String, dynamic> json) {
  final normalized = Map<String, dynamic>.from(json);
  final email = (normalized['email'] ?? normalized['username'] ?? '').toString();
  final username =
      (normalized['username'] ?? normalized['display_name'] ?? email).toString();
  final displayName =
      (normalized['display_name'] ?? normalized['username'] ?? email).toString();

  if (normalized['email'] == null || normalized['email'].toString().isEmpty) {
    normalized['email'] = email;
  }
  normalized['username'] = username;
  normalized['display_name'] = displayName;

  if (normalized['last_login'] == null && normalized['last_login_at'] != null) {
    normalized['last_login'] = normalized['last_login_at'];
  }

  return normalized;
}

@freezed
sealed class AuthUser with _$AuthUser {
  const AuthUser._();

  const factory AuthUser({
    @JsonKey(readValue: _readUserId) required String id,
    @JsonKey(readValue: _readUsername) @Default('') String username,
    @JsonKey(readValue: _readEmail) @Default('') String email,
    @JsonKey(readValue: _readDisplayName) @Default('') String displayName,
    @Default('ACTIVE') String status,
    @Default('CITIZEN') String role,
    @JsonKey(readValue: _readPermissions) @Default([]) List<String> permissions,
    @JsonKey(readValue: _readLastLogin, name: 'last_login') String? lastLogin,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(_normalizeAuthUserJson(json));
}

extension AuthUserX on AuthUser {
  String get resolvedDisplayName =>
      displayName.trim().isNotEmpty
          ? displayName.trim()
          : (username.trim().isNotEmpty
              ? username.trim()
              : email.trim().isNotEmpty
                  ? email.trim()
                  : '');

  bool hasPermission(String permission) => permissions.contains(permission);
  bool hasRole(String targetRole) => role == targetRole || role == 'root';
}
