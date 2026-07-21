// lib/features/auth/domain/models/auth_user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

@freezed
sealed class AuthUser with _$AuthUser {
  const factory AuthUser({
    @JsonKey(name: 'user_id') required String id,
    required String email,
    @JsonKey(name: 'display_name') required String displayName,
    required String status,
    required String role,
    @Default([]) List<String> permissions,
    @JsonKey(name: 'last_login') String? lastLogin,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}

extension AuthUserX on AuthUser {
  bool hasPermission(String permission) => permissions.contains(permission);
  bool hasRole(String targetRole) => role == targetRole || role == 'root';
}
