import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

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

Object? _readLastLogin(Map<dynamic, dynamic> json, String key) {
  return json['last_login'] ?? json['last_login_at'] ?? '';
}

@freezed
sealed class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(readValue: _readDisplayName) required String displayName,
    @JsonKey(readValue: _readLastLogin) @Default('') String lastLogin,
    @Default('CITIZEN') String role,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

@freezed
sealed class RbacData with _$RbacData {
  const factory RbacData({
    @JsonKey(readValue: _readPermissions) @Default([]) List<String> permissions,
    String? workContext,
  }) = _RbacData;

  factory RbacData.fromJson(Map<String, dynamic> json) =>
      _$RbacDataFromJson(json);
}