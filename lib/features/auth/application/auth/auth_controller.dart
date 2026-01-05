import 'package:fresh_dio/fresh_dio.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_error_provider.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_service.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/auth/domain/auth_response.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';
import 'package:obywatel_plus/features/notifications/domain/notifications_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  AuthService get _authService => ref.read(authServiceProvider);
  SessionService get _sessionService => ref.read(sessionServiceProvider);

  @override
  AuthState build() {
    // Inicjalizujemy odtwarzanie sesji przy startowaniu providera
    _restoreSession();
    return const AuthState.initial();
  }

  Future<void> _restoreSession() async {
    final hasSession = await _sessionService.hasSession();
    if (!hasSession) {
      state = const AuthState.unauthenticated();
      return;
    }

    final userId = await _sessionService.getUserId();
    if (userId == null) {
      state = const AuthState.unauthenticated();
      return;
    }

    // Jeśli sesja istnieje, inicjujemy security (blokada PIN)
    await ref.read(securityServiceProvider.notifier).init();
    state = AuthState.authenticated(userId: userId);
  }

  Future<void> login(String email, List<int> passwordBytes) async {
    state = const AuthState.authenticating();
    try {
      final result = await _authService.login(email, passwordBytes);
      passwordBytes.fillRange(0, passwordBytes.length, 0);

      result.when(
        twoFaRequired: (token) {
          state = AuthState.twoFaRequired(email: email, tempToken: token);
        },
        success:
            (
              accessToken,
              refreshToken,
              userId,
              challenge,
              isDeviceTrusted,
            ) async {
              // 1. ZAPISUJEMY (Blokujemy wykonanie)
              await _sessionService.saveSession(
                accessToken: accessToken,
                refreshToken: refreshToken,
                userId: userId,
              );
              await ref.read(securityServiceProvider.notifier).init();
              state = AuthState.authenticated(
                userId: userId,
                accessToken: accessToken,
                refreshToken: refreshToken,
                challenge: challenge,
                isDeviceTrusted: isDeviceTrusted,
              );
            },
      );
    } catch (e) {
      passwordBytes.fillRange(0, passwordBytes.length, 0);
      _handleError(e);
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> verifyTwoFa(String code) async {
    final currentEmail = state.maybeMap(
      twoFaRequired: (s) => s.email,
      orElse: () => null,
    );
    final currentToken = state.maybeMap(
      twoFaRequired: (s) => s.tempToken,
      orElse: () => null,
    );

    if (currentEmail == null || currentToken == null) {
      _showError(LocaleKeys.errors_SESSION_EXPIRED);
      return;
    }

    final List<int> codeBytes = code.codeUnits.toList();
    state = const AuthState.authenticating();

    try {
      final result = await _authService.verifyTwoFa(
        currentEmail,
        codeBytes,
        currentToken,
      );
      codeBytes.fillRange(0, codeBytes.length, 0);

      result.when(
        twoFaRequired: (token) => state = AuthState.twoFaRequired(
          email: currentEmail,
          tempToken: token,
        ),
        success:
            (
              accessToken,
              refreshToken,
              userId,
              challenge,
              isDeviceTrusted,
            ) async {
              // 1. Tworzymy obiekt tokena z parametrów, które przyszły z sukcesu
              final oAuthToken = OAuth2Token(
                accessToken: accessToken,
                refreshToken: refreshToken,
              );
              // 2. Pobieramy fresh i ustawiamy w nim nowo utworzony token
              final dio = ref.read(authDioProvider);
              final fresh = dio.interceptors
                  .whereType<Fresh<OAuth2Token>>()
                  .first;

              await fresh.setToken(oAuthToken);
              // 3. Zapisujemy w sesji i aktualizujemy stan
              await _sessionService.saveSession(
                userId: userId,
                accessToken: accessToken,
                refreshToken: refreshToken,
              );
              await ref.read(securityServiceProvider.notifier).unlockManually();
              state = AuthState.authenticated(
                userId: userId,
                accessToken: accessToken,
                refreshToken: refreshToken,
                challenge: challenge,
                isDeviceTrusted: isDeviceTrusted,
              );
            },
      );
    } catch (e) {
      codeBytes.fillRange(0, codeBytes.length, 0);
      state = AuthState.twoFaRequired(
        email: currentEmail,
        tempToken: currentToken,
      );
      _handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } finally {
      await _sessionService.clearSession();
      ref.invalidate(securityServiceProvider);
      ref.invalidate(appDatabaseProvider);
      ref.invalidate(notificationsControllerProvider);
      state = const AuthState.unauthenticated();
    }
  }

  void _handleError(Object e) {
    // Po prostu przekaż błąd dalej. Notifier zajmie się mapowaniem na AppFailure.
    ref.read(globalNotificationProvider.notifier).showFromError(e);
  }

  void _showError(String key) {
    ref
        .read(globalNotificationProvider.notifier)
        .show(AppNotification(messageKey: key, type: NotificationType.error));
  }
}
