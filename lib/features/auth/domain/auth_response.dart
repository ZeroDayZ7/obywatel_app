// lib/features/auth/domain/auth_response.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response.freezed.dart';

@freezed
sealed class AuthResponse with _$AuthResponse {
  // Sukces po 2FA: mamy tokeny w RAM i challenge do podpisania
  const factory AuthResponse.success({
    required String accessToken,
    required String refreshToken,
    required String userId,
    String? challenge,
    @Default(false) bool isDeviceTrusted,
  }) = _Success;

  // 2FA wymagane (pierwszy krok logowania)
  const factory AuthResponse.twoFaRequired({required String twoFaToken}) =
      _TwoFaRequired;
}
