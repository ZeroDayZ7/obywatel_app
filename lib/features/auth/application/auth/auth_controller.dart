import 'dart:convert';
import 'dart:io';

import 'package:fresh_dio/fresh_dio.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/crypto/crypto_service.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_notification_provider.dart';
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

  static const String _logModule = 'AUTH';

  @override
  AuthState build() {
    _log.i('Inicjalizacja AuthController...', module: _logModule);
    Future.microtask(() => _checkInitialSession());
    return const AuthState.initial();
  }

  /// Sprawdza przy starcie aplikacji, czy w SecureStorage znajduje się zapisany refreshToken
  Future<void> _checkInitialSession() async {
    _log.d(
      'Sprawdzanie początkowego stanu sesji na urządzeniu...',
      module: _logModule,
    );

    try {
      final refreshToken = await _sessionService.getRefreshToken();
      final hasSession = refreshToken != null && refreshToken.isNotEmpty;

      if (!hasSession) {
        _log.i(
          'Brak zapisanej sesji na urządzeniu -> AuthState.unauthenticated',
          module: _logModule,
        );
        state = const AuthState.unauthenticated();
        return;
      }

      _log.i(
        'Zapisana sesja odnaleziona na dysku -> AuthState.locked()',
        module: _logModule,
      );
      state = const AuthState.locked();
    } catch (e, stack) {
      _log.e(
        'Błąd podczas odczytu sesji z dysku -> zmiana stanu na unauthenticated',
        error: e,
        stackTrace: stack,
        module: _logModule,
      );
      state = const AuthState.unauthenticated();
    }
  }

  /// Metoda wywoływana po wprowadzeniu prawidłowego PIN-u przez użytkownika
  Future<bool> unlockWithPinAndValidateSession() async {
    _log.i(
      'Rozpoczęcie procedury odblokowywania PIN-em...',
      module: _logModule,
    );

    state = const AuthState.authenticating();

    try {
      // 1. Odblokowujemy lokalny skarbiec PIN-em
      _log.d(
        '1/3 Odblokowywanie lokalnego skarbca (securityService)...',
        module: _logModule,
      );
      await ref.read(securityServiceProvider.notifier).unlockApp();

      // 2. Weryfikujemy dostępność refreshTokena na dysku
      final refreshToken = await _sessionService.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        _log.w('Brak refresh_token na dysku. Sesja wygasła.');
        await logout();
        return false;
      }

      // 3. Pobieranie danych sesji z API (/auth/me)
      _log.d(
        '2/3 Pobieranie danych sesji z API (/auth/me)...',
        module: _logModule,
      );
      final user = await _authService.fetchAuthMe();

      state = AuthState.authenticated(user: user, isDeviceTrusted: true);

      _log.i(
        '✅ Sesja pomyślnie odblokowana i zweryfikowana.',
        module: _logModule,
      );
      return true;
    } catch (e, stack) {
      _log.e(
        '❌ Błąd podczas odświeżania sesji po podaniu PIN-u. Wylogowywanie...',
        error: e,
        stackTrace: stack,
        module: _logModule,
      );

      await logout();
      return false;
    }
  }

  Future<void> _handleAuthResponse(AuthResponse result, String email) async {
    final logger = ref.read(appLoggerProvider);

    await result.when(
      twoFaRequired: (token) {
        state = AuthState.twoFaRequired(email: email, tempToken: token);
      },
      preTrust: (setupToken, challenge, isTrusted, userId) async {
        state = AuthState.partiallyAuthenticated(
          setupToken: setupToken,
          challenge: challenge,
          userId: userId,
        );

        final pending = PendingSession(setupToken: setupToken, userId: userId);
        logger.i('Pending session created: $pending');
        ref.read(pendingSessionProvider.notifier).update(pending);

        // KLUCZOWA POPRAWKA: Wrzucamy tymczasowy setupToken do Fresh Dio,
        // aby zapytania takie jak /register-device wysyłały go w Authorization: Bearer
        await ref
            .read(authFreshProvider)
            .setToken(
              OAuth2Token(
                accessToken: setupToken,
                refreshToken: '',
              ),
            );

        if (isTrusted) {
          logger.i(
            '🛡️ Urządzenie jest zaufane... Uruchamiam automatyczną weryfikację podpisu...',
          );
          await verifyDeviceSignature();
        } else {
          logger.w('📱 Nowe urządzenie. Wymagany ręczny setup bezpieczeństwa.');
        }
      },
      // FIX 1: Dostosowano parametry (tylko accessToken i refreshToken)
      fullSuccess: (accessToken, refreshToken) async {
        try {
          logger.i('✅ Weryfikacja zakończona sukcesem. Zapisywanie sesji...');

          // 1. Zapis na dysku refreshTokena
          await _sessionService.saveSession(refreshToken: refreshToken);

          // 2. Wrzucenie tokena do Fresh (RAM)
          await ref
              .read(authFreshProvider)
              .setToken(
                OAuth2Token(
                  accessToken: accessToken,
                  refreshToken: refreshToken,
                ),
              );

          ref.read(pendingSessionProvider.notifier).clear();

          // FIX 2: Hydratacja profilu użytkownika osobnym strzałem na /auth/me
          logger.i('🔄 Pobieranie profilu użytkownika z /auth/me...');
          final user = await _authService.fetchAuthMe();

          state = AuthState.authenticated(user: user, isDeviceTrusted: true);

          logger.i('🚀 Użytkownik w pełni uwierzytelniony.');
        } catch (e) {
          logger.e('❌ Błąd podczas finalizacji sesji: $e');
          _handleError(e);
          setUnauthenticated();
        }
      },
    );
  }

  Future<void> dumpRamState(Ref ref, AppLogger log) async {
    final authState = ref.read(authControllerProvider);
    final securityState = ref.read(securityServiceProvider);
    final pendingSession = ref.read(pendingSessionProvider);
    final freshToken = await ref.read(authFreshProvider).token;

    log.i('''
🧠 ===== AKTUALNY STAN PAMIĘCI RAM =====
1. AuthState: $authState
2. SecurityState: $securityState
3. Fresh OAuth2Token (RAM):
   • AccessToken: ${freshToken?.accessToken ?? 'BRAK'}
   • RefreshToken: ${freshToken?.refreshToken ?? 'BRAK'}
4. PendingSession: $pendingSession
========================================
''', module: 'DIAGNOSTICS');
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
      setUnauthenticated();
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

      await _handleAuthResponse(result, currentEmail);
    } catch (e) {
      codeBytes.fillRange(0, codeBytes.length, 0);
      state = AuthState.twoFaRequired(
        email: currentEmail,
        tempToken: currentToken,
      );
      _handleError(e);
    } finally {
      codeBytes.fillRange(0, codeBytes.length, 0);
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

    await _handleAuthResponse(response, '');
  }

  Future<void> logout() async {
    try {
      final refreshToken = await _sessionService.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _authService.logout(refreshToken);
      }
    } finally {
      await _sessionService.clearSession();
      await ref.read(authFreshProvider).clearToken();
      ref.invalidate(securityServiceProvider);
      ref.invalidate(appDatabaseProvider);
      ref.invalidate(notificationsControllerProvider);
      setUnauthenticated();
    }
  }

  Future<void> verifyDeviceSignature() async {
    await state.maybeMap(
      partiallyAuthenticated: (s) async {
        try {
          final crypto = ref.read(cryptoServiceProvider.notifier);
          final signature = await crypto.signWithActiveKey(s.challenge);

          final result = await _authService.verifyDevice(
            setupToken: s.setupToken,
            signature: signature,
          );

          await _handleAuthResponse(result, '');
        } catch (e) {
          _log.e('Błąd podczas weryfikacji urządzenia: $e', module: 'AUTH');
          _handleError(e);
          setUnauthenticated();
        }
      },
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
