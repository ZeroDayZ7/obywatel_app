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

    state = AuthState.authenticated(userId: userId);
  }

  Future<void> login(String email, List<int> passwordBytes) async {
    state = const AuthState.authenticating();
    try {
      final result = await _authService.login(email, passwordBytes);
      // Czyszczenie hasła z pamięci natychmiast po użyciu
      passwordBytes.fillRange(0, passwordBytes.length, 0);

      // Używamy ujednoliconej obsługi wyniku
      await _handleAuthResponse(result, email);
    } catch (e) {
      passwordBytes.fillRange(0, passwordBytes.length, 0);
      _handleError(e);
      state = const AuthState.unauthenticated();
    }
  }

  /// Wspólna logika dla login i verifyTwoFa
  Future<void> _handleAuthResponse(AuthResponse result, String email) async {
    await result.when(
      twoFaRequired: (token) {
        state = AuthState.twoFaRequired(email: email, tempToken: token);
      },
      preTrust: (setupToken, challenge, isTrusted) async {
        ref
            .read(authFreshProvider)
            .setToken(OAuth2Token(accessToken: setupToken, refreshToken: null));

        state = AuthState.partiallyAuthenticated(
          setupToken: setupToken,
          challenge: challenge,
        );
      },
      fullSuccess: (accessToken, refreshToken, user, rbac) async {
        // Pełny sukces - urządzenie jest zaufane, mamy komplet danych
        await _sessionService.saveSession(
          accessToken: accessToken,
          refreshToken: refreshToken,
          userId: user.userId,
        );

        // Inicjalizacja usług zależnych od sesji
        await ref.read(securityServiceProvider.notifier).init();

        state = AuthState.authenticated(
          userId: user.userId,
          accessToken: accessToken,
          refreshToken: refreshToken,
          isDeviceTrusted: true,
        );
      },
    );
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

      await _handleAuthResponse(result, currentEmail);
    } catch (e, stack) {
      print("❌ BŁĄD WE FLUTTERZE: $e");
      print("❌ STACKTRACE: $stack");
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
      final refreshToken = await _sessionService.getRefreshToken();
      await _authService.logout(refreshToken);
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

  void cancelTwoFa() {
    state = const AuthState.unauthenticated();
  }

  void _showError(String key) {
    ref
        .read(globalNotificationProvider.notifier)
        .show(AppNotification(messageKey: key, type: NotificationType.error));
  }
}
