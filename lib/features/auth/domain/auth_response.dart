import 'package:freezed_annotation/freezed_annotation.dart';

import 'auth_models.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

@freezed
sealed class AuthResponse with _$AuthResponse {
  const factory AuthResponse.twoFaRequired({required String twoFaToken}) =
      _TwoFaRequired;

  const factory AuthResponse.preTrust({
    required String accessToken,
    required String challenge,
    @Default(false) bool isTrusted,
  }) = _PreTrust;

  const factory AuthResponse.fullSuccess({
    required String accessToken,
    required String refreshToken,
    required UserProfile user,
    required RbacData rbac,
  }) = _FullSuccess;

  // TA LINIA JEST KLUCZOWA - bez niej json_serializable ignoruje ten plik
  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  // Twoja własna logika mapowania
  factory AuthResponse.fromMap(Map<String, dynamic> data) {
    if (data['2fa_required'] == true) {
      return AuthResponse.twoFaRequired(
        twoFaToken: data['two_fa_token']?.toString() ?? '',
      );
    }

    final isTrusted = data['is_trusted'] as bool? ?? false;
    final refreshToken = data['refresh_token']?.toString();

    if (isTrusted && refreshToken != null && refreshToken.isNotEmpty) {
      return AuthResponse.fullSuccess(
        accessToken: data['access_token']?.toString() ?? '',
        refreshToken: refreshToken,
        user: UserProfile.fromJson(data['user'] as Map<String, dynamic>),
        rbac: RbacData.fromJson(data['rbac'] as Map<String, dynamic>),
      );
    }

    return AuthResponse.preTrust(
      accessToken: data['access_token']?.toString() ?? '',
      challenge: data['challenge']?.toString() ?? '',
      isTrusted: isTrusted,
    );
  }
}
