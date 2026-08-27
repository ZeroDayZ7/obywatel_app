import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/crypto/crypto_service.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/exceptions/app_exception.dart';
import 'package:obywatel_plus/core/errors/failures/app_failure.dart';
import 'package:obywatel_plus/core/errors/global_notification_provider.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
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

  Future<bool> unlockWithPinAndValidateSession() async {
    _log.i(
      '[UNLOCK-SESSION][1] Rozpoczęcie procedury odblokowywania PIN-em...',
      module: _logModule,
    );
    _log.d(
      '[UNLOCK-SESSION][1.1] Aktualny stan przed odblokowaniem: $state',
      module: _logModule,
    );

    // ⚡ SCENARIUSZ A: Jesteśmy w trakcie logowania na zaufanym urządzeniu
    // Klucz prywatny został przed chwilą załadowany do RAM w PinVerificationController.
    if (state.isPartiallyAuthenticated) {
      _log.i(
        '[UNLOCK-SESSION][2-A] Wykryto stan partiallyAuthenticated. Przechodzę do podpisu challenge\'a...',
        module: _logModule,
      );

      await verifyDeviceSignature();

      final isAuth = state.isAuthenticated;
      _log.i(
        '[UNLOCK-SESSION][2-A.1] Zakończono verifyDeviceSignature. Stan isAuthenticated: $isAuth (stan końcowy: $state)',
        module: _logModule,
      );
      return isAuth;
    }

    // ⚡ SCENARIUSZ B: Standardowe odblokowanie zapisanej sesji po uruchomieniu/zablokowaniu aplikacji
    _log.i(
      '[UNLOCK-SESSION][2-B] Przejście do standardowego odblokowania sesji. Ustawiam stan AuthState.authenticating()',
      module: _logModule,
    );
    state = const AuthState.authenticating();

    try {
      // 1. Sprawdzenie obecności tokena na dysku
      _log.i(
        '[UNLOCK-SESSION][3] Sprawdzanie obecności refresh_token w SecureStorage...',
        module: _logModule,
      );
      final refreshToken = await _sessionService.getRefreshToken();

      final tokenPresent = refreshToken != null && refreshToken.isNotEmpty;
      _log.d(
        '[UNLOCK-SESSION][3.1] Odczytany refresh_token: ${tokenPresent ? "OBECNY (len: ${refreshToken.length})" : "BRAK/EMPTY"}',
        module: _logModule,
      );

      if (!tokenPresent) {
        _log.w(
          '[UNLOCK-SESSION][3.2] Brak refresh_token na dysku. Sesja wygasła - wywołuję logout().',
          module: _logModule,
        );
        await logout();
        return false;
      }

      // 2. Strzał do API po świeże dane profilu
      _log.i(
        '[UNLOCK-SESSION][4] Wykonuję zapytanie do API (/auth/me)...',
        module: _logModule,
      );
      final user = await _authService.fetchAuthMe();
      _log.d(
        '[UNLOCK-SESSION][4.1] Pomyślnie pobrano dane użytkownika: ID=${user.id}, email=${user.email}',
        module: _logModule,
      );

      await _sessionService.cacheUser(user);

      // 3. Zdejmij blokadę lokalną
      _log.i(
        '[UNLOCK-SESSION][5] Zdejmowanie blokady lokalnej w SecurityService...',
        module: _logModule,
      );
      await ref.read(securityServiceProvider.notifier).unlockApp();
      _log.d(
        '[UNLOCK-SESSION][5.1] Blokada lokalna zdjęta.',
        module: _logModule,
      );

      // 4. Ustaw stan na authenticated
      _log.i(
        '[UNLOCK-SESSION][6] Ustawianie stanu AuthState.authenticated...',
        module: _logModule,
      );
      state = AuthState.authenticated(user: user, isDeviceTrusted: true);

      _log.i(
        '[UNLOCK-SESSION][7] ✅ Sesja pomyślnie odblokowana i zweryfikowana.',
        module: _logModule,
      );
      return true;
    } on AppFailure catch (failure, stack) {
      _log.w(
        '[UNLOCK-SESSION][ERR-APP] ⚠️ AppFailure podczas weryfikacji PIN: $failure',
        error: failure,
        stackTrace: stack,
        module: _logModule,
      );

      final shouldLogout = failure.maybeWhen(
        server: (statusCode) => statusCode == 401 || statusCode == 403,
        orElse: () => false,
      );

      _log.d(
        '[UNLOCK-SESSION][ERR-APP.1] Weryfikacja powodu błędu: shouldLogout=$shouldLogout',
        module: _logModule,
      );

      if (shouldLogout) {
        _log.w(
          '[UNLOCK-SESSION][ERR-APP.2] 🔒 Token unieważniony przez serwer (401/403). Następuje wylogowanie.',
          module: _logModule,
        );
        await logout();
      } else {
        _log.w(
          '[UNLOCK-SESSION][ERR-APP.3] Błąd po stronie aplikacji/sieci bez wylogowania. Ustawiam AuthState.unauthenticated().',
          module: _logModule,
        );
        state = const AuthState.unauthenticated();
      }

      return false;
    } on DioException catch (e, stack) {
      final appException = e.error is AppException
          ? e.error as AppException
          : null;
      final statusCode = e.response?.statusCode;

      _log.w(
        '[UNLOCK-SESSION][ERR-DIO] 🌐 DioException podczas odblokowywania '
        '(HTTP status: $statusCode, Exception: ${appException?.runtimeType ?? 'unknown'}, URL: ${e.requestOptions.path})',
        error: e,
        stackTrace: stack,
        module: _logModule,
      );

      // 1. Brak sieci / Timeout / Upstream Unavailable -> Wpuszczamy w tryb offline
      if (appException is NetworkException ||
          appException is TimeoutException ||
          appException is UpstreamUnavailableException) {
        _log.w(
          '[UNLOCK-SESSION] Brak łączności z serwerem. Zdejmowanie blokady lokalnej PIN i przejście w tryb offline.',
          module: _logModule,
        );

        final cachedUser = await _sessionService.getCachedUser();

        if (cachedUser == null) {
          _log.e(
            '[UNLOCK-SESSION] Brak skache\'owanego profilu użytkownika dla trybu offline! Wymuszam wylogowanie.',
            module: _logModule,
          );
          await logout();
          return false;
        }

        // Odblokowujemy aplikację lokalnie – PIN wpisany przez usera był poprawny!
        await ref.read(securityServiceProvider.notifier).unlockApp();

        // Ustawiamy stan sesji z profilem odczytanym z dysku
        state = AuthState.authenticated(
          user: cachedUser,
          isDeviceTrusted: true,
        );

        return true;
      }

      // 2. Błędy autoryzacji (401 / 403) -> Wylogowanie
      if (appException is UnauthorizedException ||
          appException is ForbiddenException ||
          statusCode == 401 ||
          statusCode == 403) {
        _log.w(
          '[UNLOCK-SESSION][ERR-DIO.1] Serwer odrzucił token (status $statusCode). Następuje wylogowanie.',
          module: _logModule,
        );
        await logout();
        return false;
      }

      // 3. Pozostałe błędy (np. 500, błąd walidacji po stronie serwera)
      _log.e(
        '[UNLOCK-SESSION][ERR-DIO.2] Błąd serwera/aplikacji (status: $statusCode). Brak wylogowania, odrzucenie PIN.',
        module: _logModule,
      );
      return false;
    } catch (e, stack) {
      _log.e(
        '[UNLOCK-SESSION][ERR-CRIT] ❌ Nieoczekiwany błąd podczas weryfikacji sesji po podaniu PIN-u.',
        error: e,
        stackTrace: stack,
        module: _logModule,
      );

      return false;
    }
  }

  Future<bool> resendTwoFaCode() async {
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
      return false;
    }

    try {
      await _authService.resendTwoFaCode(currentEmail, currentToken);

      ref
          .read(globalNotificationProvider.notifier)
          .show(
            AppNotification(
              messageKey: LocaleKeys.login_2fa_code_resent,
              type: NotificationType.info,
            ),
          );
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  Future<void> unpairAndReset() async {
    _log.w(
      '⚠️ Rozpoczynam rozparowanie urządzenia i Hard Reset...',
      module: _logModule,
    );

    try {
      // Serwer sam unieważnia sesję w Redis i DB w ramach rozparowania
      await _authService.unpairDevice();
    } catch (e) {
      _log.w(
        'Błąd API podczas unpair (kontynuuję lokalny wipe): $e',
        module: _logModule,
      );
    } finally {
      await _clearLocalSession(wipeDatabase: true);
    }
  }

  Future<void> _handleAuthResponse(AuthResponse result, String email) async {
    final logger = ref.read(appLoggerProvider);

    logger.d(
      '[_handleAuthResponse - 1] Rozpoczynam obsługę odpowiedzi auth. Typ: ${result.runtimeType}',
    );

    await result.when(
      twoFaRequired: (token) {
        logger.d('[_handleAuthResponse - 2] Weszło w przypadek: twoFaRequired');
        logger.i(
          '🔑 [_handleAuthResponse - 3] Wymagany krok 2FA. Ustawiam state na twoFaRequired.',
        );

        state = AuthState.twoFaRequired(email: email, tempToken: token);

        logger.d('[_handleAuthResponse - 4] Zakończono obsługę twoFaRequired.');
      },

      preTrust: (setupToken, challenge) async {
        logger.d(
          '[_handleAuthResponse - 5] Weszło w przypadek: preTrust (PRE_TRUST)',
        );
        try {
          logger.i(
            '🔐 [_handleAuthResponse - 6] Ustawiam state = AuthState.partiallyAuthenticated...',
          );

          state = AuthState.partiallyAuthenticated(
            setupToken: setupToken,
            challenge: challenge,
          );

          logger.d(
            '[_handleAuthResponse - 7] Stan zmieniony na partiallyAuthenticated. Aktualizuję PendingSession...',
          );

          final pending = PendingSession(setupToken: setupToken);
          ref.read(pendingSessionProvider.notifier).update(pending);

          logger.d(
            '[_handleAuthResponse - 8] PendingSession zaktualizowany. Zapisuję setupToken do Fresh...',
          );

          await ref
              .read(authFreshProvider)
              .setToken(OAuth2Token(accessToken: setupToken, refreshToken: ''));

          logger.w(
            '📱 [_handleAuthResponse - 9] Sukces PreTrust! Token we Fresh zapisany. Oczekuję na reakcję routera/widoku.',
          );
        } catch (e, stackTrace) {
          logger.e(
            '❌ [_handleAuthResponse - ERROR] Wyjątek wewnątrz bloku preTrust: $e',
            error: e,
            stackTrace: stackTrace,
          );
          _handleError(e);
          setUnauthenticated();
        }
      },

      fullSuccess: (accessToken, refreshToken) async {
        logger.d('[_handleAuthResponse - 10] Weszło w przypadek: fullSuccess');
        try {
          logger.i(
            '✅ [_handleAuthResponse - 11] Zapisywanie refreshToken na dysku...',
          );
          await _sessionService.saveSession(refreshToken: refreshToken);

          logger.d('[_handleAuthResponse - 12] Zapisywanie tokenów w Fresh...');
          await ref
              .read(authFreshProvider)
              .setToken(
                OAuth2Token(
                  accessToken: accessToken,
                  refreshToken: refreshToken,
                ),
              );

          logger.d('[_handleAuthResponse - 13] Czyszczenie PendingSession...');
          ref.read(pendingSessionProvider.notifier).clear();

          logger.d(
            '[_handleAuthResponse - 14] Oznaczam security jako zainicjalizowane...',
          );
          await ref
              .read(securityServiceProvider.notifier)
              .markSecurityAsInitialized();

          logger.i(
            '🔄 [_handleAuthResponse - 15] Pobieranie profilu użytkownika z /auth/me...',
          );
          final user = await _authService.fetchAuthMe();

          logger.d(
            '[_handleAuthResponse - 16] Cache’uję profil użytkownika...',
          );
          await _sessionService.cacheUser(user);

          logger.d(
            '[_handleAuthResponse - 17] Ustawiam state = AuthState.authenticated (isDeviceTrusted: true)...',
          );
          state = AuthState.authenticated(user: user, isDeviceTrusted: true);

          logger.i(
            '🚀 [_handleAuthResponse - 18] Użytkownik w pełni uwierzytelniony!',
          );
        } catch (e, stackTrace) {
          logger.e(
            '❌ [_handleAuthResponse - ERROR] Wyjątek wewnątrz bloku fullSuccess: $e',
            error: e,
            stackTrace: stackTrace,
          );
          _handleError(e);
          setUnauthenticated();
        }
      },

      temporarySuccess: (accessToken) async {
        logger.d(
          '[_handleAuthResponse - 10T] Weszło w przypadek: temporarySuccess',
        );
        try {
          logger.d(
            '[_handleAuthResponse - 11T] Zapisywanie tylko accessToken w Fresh (brak refreshToken)...',
          );
          await ref
              .read(authFreshProvider)
              .setToken(
                OAuth2Token(accessToken: accessToken, refreshToken: ''),
              );

          logger.d('[_handleAuthResponse - 12T] Czyszczenie PendingSession...');
          ref.read(pendingSessionProvider.notifier).clear();

          logger.d(
            '[_handleAuthResponse - 13T] Oznaczam security jako konfigurację tymczasową...',
          );
          await ref
              .read(securityServiceProvider.notifier)
              .completeTemporarySetup();

          logger.i(
            '🔄 [_handleAuthResponse - 14T] Pobieranie profilu użytkownika z /auth/me...',
          );
          final user = await _authService.fetchAuthMe();

          logger.d(
            '[_handleAuthResponse - 15T] Cache’uję profil użytkownika...',
          );
          await _sessionService.cacheUser(user);

          logger.d(
            '[_handleAuthResponse - 16T] Ustawiam state = AuthState.authenticated (isDeviceTrusted: false)...',
          );
          state = AuthState.authenticated(user: user, isDeviceTrusted: false);

          logger.i(
            '⏳ [_handleAuthResponse - 17T] Użytkownik zalogowany w trybie sesji tymczasowej (15 min).',
          );
        } catch (e, stackTrace) {
          logger.e(
            '❌ [_handleAuthResponse - ERROR] Wyjątek wewnątrz bloku temporarySuccess: $e',
            error: e,
            stackTrace: stackTrace,
          );
          _handleError(e);
          setUnauthenticated();
        }
      },
    );

    logger.d(
      '[_handleAuthResponse - 19] Zakończono wykonywanie _handleAuthResponse.',
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
    _log.i('[AuthController] Initiating login process for email: $email');
    state = const AuthState.authenticating();

    try {
      final result = await _authService.login(email, passwordBytes);
      _log.d(
        '[AuthController] Authentication request successful, processing response...',
      );

      passwordBytes.fillRange(0, passwordBytes.length, 0);

      await _handleAuthResponse(result, email);
    } catch (e, st) {
      _log.e(
        '[AuthController] Login failed for email: $email',
        error: e,
        stackTrace: st,
      );
      passwordBytes.fillRange(0, passwordBytes.length, 0);
      _handleError(e);
      setUnauthenticated();
    }
  }

  Future<void> verifyTwoFa(String code) async {
    _log.i('[AuthController] Initiating 2FA verification...');

    final currentEmail = state.maybeMap(
      twoFaRequired: (s) => s.email,
      orElse: () => null,
    );
    final currentToken = state.maybeMap(
      twoFaRequired: (s) => s.tempToken,
      orElse: () => null,
    );

    if (currentEmail == null || currentToken == null) {
      _log.w(
        '[AuthController] 2FA verification failed: missing session data (email or tempToken)',
      );
      _showError(LocaleKeys.errors_SESSION_EXPIRED);
      return;
    }

    final List<int> codeBytes = code.codeUnits.toList();
    state = const AuthState.authenticating();

    try {
      _log.d(
        '[AuthController] Sending 2FA verification request for email: $currentEmail',
      );
      final result = await _authService.verifyTwoFa(
        currentEmail,
        codeBytes,
        currentToken,
      );

      _log.d(
        '[AuthController] 2FA verification successful, processing response...',
      );
      await _handleAuthResponse(result, currentEmail);
    } catch (e, st) {
      _log.e(
        '[AuthController] 2FA verification failed for email: $currentEmail',
        error: e,
        stackTrace: st,
      );
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
    _log.i('[AuthController] Starting trusted device registration...');

    final pending = ref.read(pendingSessionProvider);
    final deviceService = ref.read(deviceInfoServiceProvider);
    final authService = ref.read(authServiceProvider);
    final crypto = ref.read(cryptoServiceProvider.notifier);
    final storage = ref.read(secureStorageProvider);

    try {
      // 1️⃣ Odczytujemy wygenerowany w kroku 4/6 klucz publiczny (Base64)
      _log.d('[AuthController] Reading public key from secure storage...');
      final publicKeyBase64 = await storage.read(
        key: StorageKeys.devicePublicKey,
      );

      if (publicKeyBase64 == null || publicKeyBase64.isEmpty) {
        _log.w(
          '[AuthController] Device registration failed: Public key missing in storage',
        );
        throw Exception('Brak wygenerowanego klucza publicznego w pamięci.');
      }

      _log.d(
        '[AuthController] Fetching device fingerprint and encrypted name...',
      );
      final fingerprint = await deviceService.getFingerprint();
      final encryptedName = await deviceService.getEncryptedMarketingName();

      final challenge = state.maybeMap(
        partiallyAuthenticated: (s) => s.challenge,
        orElse: () {
          _log.w(
            '[AuthController] Device registration failed: Missing challenge in state',
          );
          throw Exception('Brak challenge');
        },
      );

      // 2️⃣ Podpisujemy challenge kluczem aktywnym w RAM (_activeDeviceKeyPair)
      _log.d('[AuthController] Signing challenge with active device key...');
      final signature = await crypto.signWithActiveKey(challenge);

      // 3️⃣ Wysyłamy do backendu Go
      _log.d(
        '[AuthController] Sending registerTrustedDevice request to backend...',
      );
      final response = await authService.registerTrustedDevice(
        fingerprint: fingerprint,
        publicKey: publicKeyBase64,
        encryptedName: encryptedName,
        platform: Platform.operatingSystem,
        signature: signature,
        accessToken: pending?.setupToken,
      );

      _log.i(
        '[AuthController] Trusted device registered successfully. Processing response...',
      );
      await _handleAuthResponse(response, '');
    } catch (e, st) {
      _log.e(
        '[AuthController] Failed to register trusted device',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<void> createTemporarySession() async {
    final logger = ref.read(appLoggerProvider);
    logger.i('⏳ [AuthController] Tworzenie sesji tymczasowej...');

    try {
      final pendingSession = ref.read(pendingSessionProvider);
      final setupToken = pendingSession?.setupToken;

      if (setupToken == null || setupToken.isEmpty) {
        throw Exception(
          'Brak setupToken w PendingSession do utworzenia sesji tymczasowej.',
        );
      }

      final response = await _authService.createTemporarySession(
        accessToken: setupToken,
      );

      final email = state.email ?? '';
      await _handleAuthResponse(response, email);

      logger.i('✅ [AuthController] Sesja tymczasowa utworzona pomyślnie.');
    } catch (e, stackTrace) {
      logger.e(
        '❌ [AuthController] Błąd podczas tworzenia sesji tymczasowej: $e',
        error: e,
        stackTrace: stackTrace,
      );
      _handleError(e);
      setUnauthenticated();
      rethrow;
    }
  }

  Future<void> logout() async {
    _log.i('Rozpoczynam zwykłe wylogowanie...', module: _logModule);

    try {
      final refreshToken = await _sessionService.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _authService.logout(refreshToken);
      }
    } catch (e) {
      _log.w(
        'Błąd API podczas logout (kontynuuję czyszczenie lokalne): $e',
        module: _logModule,
      );
    } finally {
      await _clearLocalSession(wipeDatabase: false);
    }
  }

  Future<void> _clearLocalSession({required bool wipeDatabase}) async {
    // 1. Czyszczenie tokenów z pamięci RAM (Fresh Dio)
    await ref.read(authFreshProvider).clearToken();

    // 2. Przygotowanie zadań do czyszczenia
    final clearTasks = <Future<void>>[ref.read(activePrefsProvider).clearAll()];

    if (wipeDatabase) {
      // Przy Hard Reset czyścimy CAŁE SecureStorage (zamiast czyścić pojedyncze klucze)
      clearTasks.add(ref.read(secureStorageProvider).clearAll());

      final db = ref.read(appDatabaseProvider);
      clearTasks.add(() async {
        await db.clearDatabase();
        await db.close();
      }());
    } else {
      // Przy zwykłym logout czyścimy tylko klucz sesji
      clearTasks.add(_sessionService.clearSession());
    }

    // 3. Wykonaj bezpiecznie bez konfliktów IO
    try {
      await Future.wait(clearTasks);
    } catch (e, stack) {
      _log.e(
        'Błąd podczas czyszczenia lokalnej sesji',
        error: e,
        stackTrace: stack,
        module: _logModule,
      );
    }

    // 4. Inwalidacja providerów
    ref.read(pendingSessionProvider.notifier).clear();
    ref.invalidate(securityServiceProvider);
    ref.invalidate(appDatabaseProvider);
    ref.invalidate(notificationsControllerProvider);

    unawaited(ref.read(securityServiceProvider.notifier).init());

    // 5. Powrót do stanu niezalogowanego
    setUnauthenticated();

    _log.i('✅ Czyszczenie zakończone sukcesem.', module: _logModule);
  }

  Future<void> forceSecurityWipe() async {
    _log.w(
      '🚨 Wymuszone czyszczenie bezpieczeństwa (Security Wipe)...',
      module: _logModule,
    );

    try {
      final refreshToken = await _sessionService.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        // Best-effort: próba unieważnienia sesji na backendzie
        await _authService
            .logout(refreshToken)
            .timeout(
              const Duration(seconds: 3),
              onTimeout: () {
                _log.w(
                  'Timeout podczas zgłaszania logout do API - kontynuuję wipe lokalny.',
                  module: _logModule,
                );
                return;
              },
            );
      }
    } catch (e) {
      _log.w(
        'Błąd API podczas forceSecurityWipe (kontynuuję czyszczenie lokalne): $e',
        module: _logModule,
      );
    } finally {
      // KLuczowy element: wipeDatabase MUST BE TRUE
      await _clearLocalSession(wipeDatabase: true);
    }
  }

  // #region: Moja Sekcja
  Future<void> verifyDeviceSignature() async {
    await state.maybeMap(
      partiallyAuthenticated: (s) async {
        try {
          final crypto = ref.read(cryptoServiceProvider.notifier);

          // Sprawdzenie czy klucz jest gotowy do użycia
          if (!await crypto.hasActiveKey()) {
            _log.w(
              'Brak aktywnego klucza w RAM. Wymagane odblokowanie storage/PIN-em.',
            );
            return;
          }

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
