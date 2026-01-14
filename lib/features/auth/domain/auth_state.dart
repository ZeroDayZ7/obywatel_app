import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState.initial() = _Initial;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.authenticating() = _Authenticating;
  const factory AuthState.twoFaRequired({
    required String email,
    required String tempToken,
  }) = _TwoFaRequired;
  const factory AuthState.partiallyAuthenticated({
    required String setupToken,
    required String challenge,
    required String userId,
  }) = _PartiallyAuthenticated;
  const factory AuthState.authenticated({
    required String userId,
    String? accessToken,
    String? refreshToken,
    @Default(false) bool isDeviceTrusted,
  }) = _Authenticated;
  const factory AuthState.error({required String code}) = _Error;

  bool get isInitial => this is _Initial;
  bool get isUnauthenticated => this is _Unauthenticated;
  bool get isLoading => this is _Authenticating;
  bool get isTwoFaRequired => this is _TwoFaRequired;
  bool get isPartiallyAuthenticated => this is _PartiallyAuthenticated;
  bool get isAuthenticated => this is _Authenticated;
  bool get isError => this is _Error;

  String? get email =>
      maybeMap(twoFaRequired: (state) => state.email, orElse: () => null);

  String? get tempToken =>
      maybeMap(twoFaRequired: (state) => state.tempToken, orElse: () => null);

  String? get errorCode =>
      maybeMap(error: (state) => state.code, orElse: () => null);

  String? get userId => maybeMap(
    partiallyAuthenticated: (state) => state.userId,
    authenticated: (state) => state.userId,
    orElse: () => null,
  );
}
