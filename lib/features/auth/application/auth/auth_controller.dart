import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/theme/theme_notifier.dart';
import 'package:obywatel_plus/core/errors/app_exception.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_error_provider.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_service.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';
import 'package:obywatel_plus/features/auth/domain/auth_response.dart';

class AuthController extends Notifier<AuthState> {
  late final Ref _ref;
  late final AuthService _authService;
  late final SessionService _sessionService;

  @override
  AuthState build() {
    _authService = ref.read(authServiceProvider);
    _sessionService = ref.read(sessionServiceProvider);

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

    await ref.read(securityServiceProvider.notifier).init();
    state = AuthState.authenticated(userId: userId);
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.authenticating();

    try {
      final result = await _authService.login(email, password);

      result.map(
        twoFaRequired: (r) {
          state = AuthState.twoFaRequired(
            email: email,
            tempToken: r.twoFaToken,
          );
        },
        success: (r) async {
          await ref.read(securityServiceProvider.notifier).init();
          state = AuthState.authenticated(userId: r.userId);
        },
      );
    } catch (e) {
      // Enterprise: mapujemy wszystkie błędy do AppException
      ref
          .read(globalNotificationProvider.notifier)
          .showFromError(e is AppException ? e : AppException.fromDio(e));
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> verifyTwoFa(String code) async {
    final currentEmail = state.email;
    final currentToken = state.tempToken;

    if (currentEmail == null || currentToken == null) {
      ref
          .read(globalNotificationProvider.notifier)
          .show(
            LocaleKeys.errors_SESSION_EXPIRED,
            type: NotificationType.error,
          );
      return;
    }

    state = const AuthState.authenticating();

    try {
      final result = await _authService.verifyTwoFa(
        currentEmail,
        code,
        currentToken,
      );

      result.map(
        twoFaRequired: (_) {
          state = AuthState.twoFaRequired(
            email: currentEmail,
            tempToken: currentToken,
          );
        },
        success: (r) async {
          await ref.read(securityServiceProvider.notifier).init();
          state = AuthState.authenticated(userId: r.userId);
        },
      );
    } catch (e) {
      state = AuthState.twoFaRequired(
        email: currentEmail,
        tempToken: currentToken,
      );
      ref
          .read(globalNotificationProvider.notifier)
          .showFromError(e is AppException ? e : AppException.fromDio(e));
    }
  }

  Future<void> logout() async {
    // Wyczyść sesję w storage
    await _sessionService.clearSession();

    // Resetujemy wszystkie zależne providery
    _ref.invalidate(securityServiceProvider);
    _ref.invalidate(globalNotificationProvider);
    _ref.invalidate(themeProvider);
    _ref.invalidate(authControllerProvider);
    _ref.invalidate(sessionServiceProvider);

    // Ustawiamy stan auth
    state = const AuthState.unauthenticated();
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
