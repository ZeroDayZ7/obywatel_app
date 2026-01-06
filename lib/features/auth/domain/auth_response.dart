import 'package:freezed_annotation/freezed_annotation.dart';

import 'auth_models.dart'; // Tu trzymamy UserProfile i RbacData

part 'auth_response.freezed.dart';

@freezed
sealed class AuthResponse with _$AuthResponse {
  /// 1. Krok: Wymagane 2FA (email/hasło poprawne)
  const factory AuthResponse.twoFaRequired({required String twoFaToken}) =
      _TwoFaRequired;

  /// 2. Krok: Sukces 2FA (Twój fiber.Map)
  /// Urządzenie nie jest zaufane (is_trusted: false).
  /// Mamy tylko AccessToken i Challenge do podpisania.
  const factory AuthResponse.preTrust({
    required String accessToken,
    required String challenge,
    @Default(false) bool isTrusted,
  }) = _PreTrust;

  /// 3. Krok: Pełny sukces (Po RegisterDevice)
  /// Tu otrzymujemy zagnieżdżony JSON z danymi usera i RBAC.
  const factory AuthResponse.fullSuccess({
    required String accessToken,
    required String refreshToken,
    required UserProfile user,
    required RbacData rbac,
  }) = _FullSuccess;
}
