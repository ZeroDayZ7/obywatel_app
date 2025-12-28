// lib/features/auth/domain/auth_response.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response.freezed.dart';

@freezed
sealed class AuthResponse with _$AuthResponse {
  // 2FA required response
  const factory AuthResponse.twoFaRequired({
    required String twoFaToken,
  }) = _TwoFaRequired;

  // Successful login response
  const factory AuthResponse.success({
    required String accessToken,
    required String refreshToken,
    required String userId,
  }) = _Success;
}
