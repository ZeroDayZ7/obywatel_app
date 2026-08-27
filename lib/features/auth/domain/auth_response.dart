import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

@freezed
sealed class AuthResponse with _$AuthResponse {
  const factory AuthResponse.twoFaRequired({
    @Default('') String twoFaToken,
  }) = _TwoFaRequired;

  const factory AuthResponse.preTrust({
    @Default('') String setupToken,
    @Default('') String challenge,
  }) = _PreTrust;

  const factory AuthResponse.fullSuccess({
    @Default('') String accessToken,
    @Default('') String refreshToken,
  }) = _FullSuccess;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  factory AuthResponse.fromMap(Map<String, dynamic> data) {
    final type = data['type']?.toString();

    // 1. Krok 2FA
    if (type == '2FA_REQUIRED') {
      final twoFa = data['two_fa'] as Map<String, dynamic>?;
      return AuthResponse.twoFaRequired(
        twoFaToken: twoFa?['two_fa_token']?.toString() ?? '',
      );
    }

    // 2. Pełny sukces (Logowanie/Zaufane urządzenie)
    if (type == 'SUCCESS') {
      final success = data['success'] as Map<String, dynamic>?;
      return AuthResponse.fullSuccess(
        accessToken: success?['access_token']?.toString() ?? '',
        refreshToken: success?['refresh_token']?.toString() ?? '',
      );
    }

    // 3. PreTrust (Konfiguracja nowego urządzenia)
    if (type == 'PRE_TRUST') {
      final preTrustData = data['pre_trust'] as Map<String, dynamic>?;

      return AuthResponse.preTrust(
        setupToken: preTrustData?['setup_token']?.toString() ?? '',
        challenge: preTrustData?['challenge']?.toString() ?? '',
      );
    }

    throw ArgumentError('Nieznany typ odpowiedzi autoryzacyjnej: $type');
  }
}