import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/features/auth/domain/auth_user.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState.initial() = _Initial;
  const factory AuthState.locked() = _Locked;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.authenticating() = _Authenticating;

  const factory AuthState.twoFaRequired({
    required String email,
    required String tempToken,
  }) = _TwoFaRequired;

  const factory AuthState.partiallyAuthenticated({
    required String setupToken,
    required String challenge,
  }) = _PartiallyAuthenticated;

  const factory AuthState.authenticated({
    required AuthUser user,
    @Default(false) bool isDeviceTrusted,
  }) = _Authenticated;

  bool get isInitial => this is _Initial;
  bool get isLocked => this is _Locked;
  bool get isUnauthenticated => this is _Unauthenticated;
  bool get isLoading => this is _Authenticating;
  bool get isTwoFaRequired => this is _TwoFaRequired;
  bool get isPartiallyAuthenticated => this is _PartiallyAuthenticated;
  bool get isAuthenticated => this is _Authenticated;

  String? get email => maybeMap(
        twoFaRequired: (state) => state.email,
        authenticated: (state) => state.user.email,
        orElse: () => null,
      );

  String? get tempToken =>
      maybeMap(twoFaRequired: (state) => state.tempToken, orElse: () => null);

  // Getter zwraca ID tylko dla w pełni uwierzytelnionego użytkownika
  String? get userId => maybeMap(
        authenticated: (state) => state.user.id,
        orElse: () => null,
      );

  List<String> get roles => maybeMap(
        authenticated: (state) => [state.user.role],
        orElse: () => const [],
      );

  List<String> get permissions => maybeMap(
        authenticated: (state) => state.user.permissions,
        orElse: () => const [],
      );

  bool hasPermission(String permission) {
    return maybeMap(
      authenticated: (state) =>
          state.user.role == 'root' || state.user.hasPermission(permission),
      orElse: () => false,
    );
  }

  bool hasRole(String role) {
    return maybeMap(
      authenticated: (state) =>
          state.user.role == 'root' || state.user.hasRole(role),
      orElse: () => false,
    );
  }
}