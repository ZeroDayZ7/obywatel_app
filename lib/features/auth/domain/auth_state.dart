import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  /// App start / session not checked yet
  const factory AuthState.initial() = _Initial;

  /// User is logged out
  const factory AuthState.unauthenticated() = _Unauthenticated;

  /// Login / refresh / verify in progress
  const factory AuthState.authenticating() = _Authenticating;

  /// 2FA required after correct credentials
  const factory AuthState.twoFaRequired({
    required String email,
    required String tempToken,
  }) = _TwoFaRequired;

  /// Fully authenticated session
  const factory AuthState.authenticated({
    required String userId,
    String? accessToken,
    String? refreshToken,
    String? challenge,
    @Default(false) bool isDeviceTrusted,
  }) = _Authenticated;

  /// Error state (optional – często lepiej przez global error handler)
  const factory AuthState.error({required String code}) = _Error;
}

/// ✅ Enterprise getter / helper
extension AuthStateX on AuthState {
  bool get isLoading =>
      maybeMap(authenticating: (_) => true, orElse: () => false);

  String? get email =>
      maybeMap(twoFaRequired: (state) => state.email, orElse: () => null);

  String? get tempToken =>
      maybeMap(twoFaRequired: (state) => state.tempToken, orElse: () => null);

  String? get errorCode =>
      maybeMap(error: (state) => state.code, orElse: () => null);
}
