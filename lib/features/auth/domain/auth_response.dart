import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

@freezed
sealed class AuthResponse with _$AuthResponse {
  const factory AuthResponse.twoFaRequired({@Default('') String twoFaToken}) =
      _TwoFaRequired;

  const factory AuthResponse.preTrust({
    @Default('') String setupToken,
    @Default('') String challenge,
  }) = _PreTrust;

  // Pełny sukces - zaufane urządzenie, posiada refreshToken
  const factory AuthResponse.fullSuccess({
    @Default('') String accessToken,
    @Default('') String refreshToken,
  }) = _FullSuccess;

  // Nowy stan: Pośredni / Tymczasowy - krótkotrwały dostęp bez refreshTokena
  const factory AuthResponse.temporarySuccess({
    @Default('') String accessToken,
  }) = _TemporarySuccess;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  factory AuthResponse.fromMap(Map<String, dynamic> data) {
    final explicitType = data['type']?.toString();

    // 1. Krok 2FA
    if (explicitType == '2FA_REQUIRED' || data.containsKey('two_fa')) {
      final twoFa = data['two_fa'] is Map<String, dynamic>
          ? data['two_fa'] as Map<String, dynamic>
          : null;
      return AuthResponse.twoFaRequired(
        twoFaToken:
            twoFa?['two_fa_token']?.toString() ??
            data['two_fa_token']?.toString() ??
            '',
      );
    }

    // 2. PreTrust (Konfiguracja urządzenia)
    if (explicitType == 'PRE_TRUST' || data.containsKey('pre_trust')) {
      final preTrustData = data['pre_trust'] is Map<String, dynamic>
          ? data['pre_trust'] as Map<String, dynamic>
          : null;
      return AuthResponse.preTrust(
        setupToken:
            preTrustData?['setup_token']?.toString() ??
            data['setup_token']?.toString() ??
            '',
        challenge:
            preTrustData?['challenge']?.toString() ??
            data['challenge']?.toString() ??
            '',
      );
    }

    // 3. Pełny sukces (obługa odpowiedzi typu {"success": true, "access_token": "..."})
    final isSuccessBool = data['success'] == true;
    if (explicitType == 'SUCCESS' ||
        (isSuccessBool &&
            data.containsKey('access_token') &&
            data.containsKey('refresh_token'))) {
      final successObj = data['success'] is Map<String, dynamic>
          ? data['success'] as Map<String, dynamic>
          : null;

      return AuthResponse.fullSuccess(
        accessToken:
            successObj?['access_token']?.toString() ??
            data['access_token']?.toString() ??
            '',
        refreshToken:
            successObj?['refresh_token']?.toString() ??
            data['refresh_token']?.toString() ??
            '',
      );
    }

    // 4. Sesja tymczasowa
    if (explicitType == 'TEMPORARY_SUCCESS' ||
        explicitType == 'PARTIAL_SUCCESS' ||
        (isSuccessBool && data.containsKey('access_token'))) {
      final successObj = data['temporary_success'] is Map<String, dynamic>
          ? data['temporary_success'] as Map<String, dynamic>
          : (data['success'] is Map<String, dynamic>
                ? data['success'] as Map<String, dynamic>
                : null);

      return AuthResponse.temporarySuccess(
        accessToken:
            successObj?['access_token']?.toString() ??
            data['access_token']?.toString() ??
            '',
      );
    }

    throw ArgumentError('Nieznany typ odpowiedzi autoryzacyjnej: $data');
  }
}
