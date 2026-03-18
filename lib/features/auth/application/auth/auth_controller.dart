import 'dart:convert';
import 'dart:io';

import 'package:fresh_dio/fresh_dio.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/crypto/crypto_service.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_error_provider.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_service.dart';
import 'package:obywatel_plus/features/auth/application/session/pending_session_provider.dart';
import 'package:obywatel_plus/features/auth/application/session/pending_session_state.dart';
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
  AppLogger get _log => ref.read(appLoggerProvider);

  @override
  AuthState build() {
    _restoreSession();
    return const AuthState.initial();
  }

  Future<void> _restoreSession() async {
    final session = await _sessionService.getSessionDetails();

    if (session == null) {
      state = const AuthState.unauthenticated();
      return;
    }

    // Tutaj dostęp do:
    // session.userId
    // session.accessToken
    state = AuthState.authenticated(userId: session.userId);
  }

  Future<void> _handleAuthResponse(AuthResponse result, String email) async {
    final logger = ref.read(appLoggerProvider);

    await result.when(
      twoFaRequired: (token) {
        state = AuthState.twoFaRequired(email: email, tempToken: token);
      },
      preTrust: (setupToken, challenge, isTrusted, userId) async {
        // 1. Najpierw ustawiamy stan partiallyAuthenticated
        state = AuthState.partiallyAuthenticated(
          setupToken: setupToken,
          challenge: challenge,
          userId: userId,
        );

        // 2. Aktualizujemy PendingSession dla zachowania spójności
        final pending = PendingSession(setupToken: setupToken, userId: userId);
        logger.i('Pending session created: $pending');
        ref.read(pendingSessionProvider.notifier).update(pending);

        // 3. LOGIKA AUTOMATYCZNEJ WERYFIKACJI (Silent Auth)
        if (isTrusted) {
          logger.i(
            '🛡️ Urządzenie jest zaufane (isTrusted: true). Uruchamiam automatyczną weryfikację podpisu...',
          );

          await verifyDeviceSignature();
        } else {
          logger.w(
            '📱 Nowe urządzenie lub brak zaufania. Wymagany ręczny setup bezpieczeństwa.',
          );
        }
      },
      fullSuccess: (accessToken, refreshToken, user, rbac) async {
        try {
          logger.i(
            '✅ Weryfikacja zakończona sukcesem. Zapisywanie sesji dla: ${user.userId}',
          );

          await _sessionService.saveSession(
            accessToken: accessToken,
            refreshToken: refreshToken,
            userId: user.userId,
          );

          await ref
              .read(authFreshProvider)
              .setToken(
                OAuth2Token(
                  accessToken: accessToken,
                  refreshToken: refreshToken,
                ),
              );

          state = AuthState.authenticated(
            userId: user.userId,
            accessToken: accessToken,
            refreshToken: refreshToken,
            isDeviceTrusted: true,
          );

          logger.i('🚀 Użytkownik w pełni uwierzytelniony.');
        } catch (e) {
          logger.e('❌ Błąd podczas finalizacji sesji: $e');
          _handleError(e);
          state = const AuthState.unauthenticated();
        }
      },
    );
  }

  Future<void> login(String email, List<int> passwordBytes) async {
    state = const AuthState.authenticating();
    try {
      final result = await _authService.login(email, passwordBytes);

      passwordBytes.fillRange(0, passwordBytes.length, 0);

      await _handleAuthResponse(result, email);
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

      await _handleAuthResponse(result, currentEmail);
    } catch (e) {
      ref.read(globalNotificationProvider.notifier).showFromError(e);
      codeBytes.fillRange(0, codeBytes.length, 0);
      state = AuthState.twoFaRequired(
        email: currentEmail,
        tempToken: currentToken,
      );
      _handleError(e);
    }
  }

  Future<void> registerTrustedDevice() async {
    final pending = ref.read(pendingSessionProvider);
    final deviceService = ref.read(deviceInfoServiceProvider);
    final authService = ref.read(authServiceProvider);
    final crypto = ref.read(cryptoServiceProvider.notifier);

    final publicKeyBytes = await crypto.generateAndHoldKeyPair();

    final fingerprint = await deviceService.getFingerprint();
    final encryptedName = await deviceService.getEncryptedMarketingName();

    final challenge = state.maybeMap(
      partiallyAuthenticated: (s) => s.challenge,
      orElse: () => throw Exception('Brak challenge'),
    );

    final signature = await crypto.signWithActiveKey(challenge);

    final response = await authService.registerTrustedDevice(
      fingerprint: fingerprint,
      publicKey: base64Encode(publicKeyBytes),
      encryptedName: encryptedName,
      platform: Platform.operatingSystem,
      signature: signature,
      accessToken: pending?.setupToken,
    );

    await _handleAuthResponse(response, "");
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

  Future<void> verifyDeviceSignature() async {
    // Używamy mapOrNull, który wykona kod TYLKO dla stanu partiallyAuthenticated
    await state.maybeMap(
      partiallyAuthenticated: (s) async {
        try {
          // final deviceService = ref.read(deviceInfoServiceProvider);

          // if (!deviceService.isUnlocked) {
          //   _log.e('Skarbiec jest zablokowany - wymagany PIN', module: 'AUTH');
          //   state = const AuthState.error(code: 'VAULT_LOCKED');
          //   return;
          // }

          // 1. Podpisujemy challenge (s.challenge jest dostępne bezpośrednio)
          final crypto = ref.read(cryptoServiceProvider.notifier);
          final signature = await crypto.signWithActiveKey(s.challenge);

          // 2. Wysyłamy do backendu (s.setupToken jest dostępne bezpośrednio)
          final result = await _authService.verifyDevice(
            setupToken: s.setupToken,
            signature: signature,
          );

          // 3. Obsługujemy odpowiedź
          await _handleAuthResponse(result, "");
        } catch (e) {
          _log.e('Błąd podczas weryfikacji urządzenia: $e', module: 'AUTH');
          _handleError(e);
          state = const AuthState.unauthenticated();
        }
      },
      // Dla wszystkich innych stanów nie rób nic
      orElse: () async {
        _log.w('Próba weryfikacji podpisu w złym stanie: ${state.runtimeType}');
      },
    );
  }

  void _handleError(Object e) {
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

  void setUnauthenticated() {
    state = const AuthState.unauthenticated();
  }
}
