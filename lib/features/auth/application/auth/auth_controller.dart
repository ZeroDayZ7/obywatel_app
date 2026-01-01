import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/errors/app_exception.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_error_provider.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_service.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/auth/domain/auth_response.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';

class AuthController extends Notifier<AuthState> {
  late final AuthService _authService;
  late final SessionService _sessionService;

  @override
  AuthState build() {
    _authService = ref.read(authServiceProvider);
    _sessionService = ref.read(sessionServiceProvider);

    // REAKCJA: Słuchamy zmian w security
    ref.listen(securityServiceProvider, (previous, next) async {
      final current = state;

      await current.maybeMap(
        authenticated: (auth) async {
          if (next.isSetupCompleted && auth.accessToken != null) {
            try {
              await _sessionService.saveSession(
                accessToken: auth.accessToken!,
                refreshToken: auth.refreshToken!,
                userId: auth.userId,
              );

              state = AuthState.authenticated(userId: auth.userId);

              ref
                  .read(appLoggerProvider)
                  .i('✅ Session persisted and RAM cleared');
            } catch (e) {
              ref.read(appLoggerProvider).e('❌ Storage error: $e');
            }
          }
        },
        orElse: () async {}, // Nic nie rób, jeśli stan to np. initial
      );
    });

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
      // Przekazujemy bajty dalej
      final result = await _authService.login(email, passwordBytes);

      // Ważne: Czyścimy bajty po powrocie z serwisu
      passwordBytes.fillRange(0, passwordBytes.length, 0);

      result.when(
        twoFaRequired: (token) {
          state = AuthState.twoFaRequired(email: email, tempToken: token);
        },
        success: (accessToken, refreshToken, userId) async {
          // Inicjujemy sprawdzenie security (czy jest PIN itp.)
          await ref.read(securityServiceProvider.notifier).init();

          // Ustawiamy stan z tokenami w RAM.
          // ref.listen powyżej zajmie się ich zapisem, gdy security powie 'gotowe'.
          state = AuthState.authenticated(
            userId: userId,
            accessToken: accessToken,
            refreshToken: refreshToken,
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
    final currentEmail = state.email;
    final currentToken = state.tempToken;

    if (currentEmail == null || currentToken == null) {
      _showError(LocaleKeys.errors_SESSION_EXPIRED);
      return;
    }

    // 1. Konwersja na bajty
    final List<int> codeBytes = code.codeUnits.toList();

    state = const AuthState.authenticating();

    try {
      final result = await _authService.verifyTwoFa(
        currentEmail,
        codeBytes, // 🔥 Przekazujemy bajty
        currentToken,
      );

      // 2. Zerowanie bajtów po sukcesie
      codeBytes.fillRange(0, codeBytes.length, 0);

      result.when(
        twoFaRequired: (token) {
          state = AuthState.twoFaRequired(
            email: currentEmail,
            tempToken: token,
          );
        },
        success: (accessToken, refreshToken, userId) async {
          await ref.read(securityServiceProvider.notifier).init();
          state = AuthState.authenticated(
            userId: userId,
            accessToken: accessToken,
            refreshToken: refreshToken,
          );
        },
      );
    } catch (e) {
      // 3. Zerowanie bajtów w przypadku błędu
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
      ref.invalidate(sessionServiceProvider);
      state = const AuthState.unauthenticated();
    }
  }

  void _handleError(Object e) {
    ref
        .read(globalNotificationProvider.notifier)
        .showFromError(e is AppException ? e : AppException.fromDio(e));
  }

  void _showError(String key) {
    ref
        .read(globalNotificationProvider.notifier)
        .show(AppNotification(messageKey: key, type: NotificationType.error));
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
