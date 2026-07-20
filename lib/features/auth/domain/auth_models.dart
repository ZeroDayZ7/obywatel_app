import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

@freezed
sealed class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'last_login') required String lastLogin,
    required String role,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

@freezed
sealed class RbacData with _$RbacData {
  const factory RbacData({
    required List<String> permissions,
    String? workContext,
  }) = _RbacData;

  factory RbacData.fromJson(Map<String, dynamic> json) =>
      _$RbacDataFromJson(json);
}
