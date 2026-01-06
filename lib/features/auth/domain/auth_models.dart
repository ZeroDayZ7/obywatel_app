import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

@freezed
sealed class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(name: 'uid') required String userId,
    required String role,
    required String displayName,
    required String lastLogin,
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
