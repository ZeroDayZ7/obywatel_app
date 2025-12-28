// features/auth/application/auth/auth_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/security/security/security_notifier.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_service.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';

class AuthController extends Notifier<AuthState> {
  late final AuthService _authService;
  late final SessionService _sessionService;

  @override
  AuthState build() {
    _authService = ref.read(authServiceProvider);
    _sessionService = ref.read(sessionServiceProvider);

    // Inicjalizacja: sprawdzamy czy user ma tokeny
    _checkSession();

    return const AuthState(status: AuthStatus.initial);
  }

  Future<void> _checkSession() async {
    final hasSession = await _sessionService.hasSession();
    if (hasSession) {
      final userId = await _sessionService.getUserId();

      // ZANIM ustawisz stan na authenticated, upewnij się,
      // że SecurityNotifier jest zainicjalizowany
      await ref.read(securityServiceProvider.notifier).init();

      state = AuthState(status: AuthStatus.authenticated, userId: userId);
    } else {
      // Jeśli nie ma sesji, dopiero teraz pozwalamy wejść na login
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// Krok 1: Logowanie Email/Hasło
  Future<void> login(String email, String password) async {
    // Resetujemy błędy, ustawiamy loading
    state = state.copyWith(status: AuthStatus.authenticating, error: null);

    try {
      final result = await _authService.login(email, password);

      if (result.twoFaRequired) {
        // Przechodzimy do 2FA - nie zapisujemy jeszcze tokenów trwałych!
        state = state.copyWith(
          status: AuthStatus.twoFaRequired,
          email: email,
          tempToken: result.twoFaToken,
        );
      } else {
        // Sukces bez 2FA
        await _finalizeLogin(result);
      }
    } catch (e) {
      // Błąd trafia do stanu -> UI wyświetli Toast
      state = state.copyWith(status: AuthStatus.unauthenticated, error: e);
    }
  }

  /// Krok 2: Weryfikacja kodu 2FA
  Future<void> verifyTwoFa(String code) async {
    state = state.copyWith(status: AuthStatus.authenticating, error: null);

    try {
      if (state.email == null || state.tempToken == null) {
        throw Exception('errors.SESSION_EXPIRED');
      }

      final result = await _authService.verifyTwoFa(
        state.email!,
        code,
        state.tempToken!,
      );

      await _finalizeLogin(result);
    } catch (e) {
      // Przy błędzie wracamy do 2FA, nie wylogowujemy całkowicie
      state = state.copyWith(status: AuthStatus.twoFaRequired, error: e);
    }
  }

  /// Krok 3: Finalizacja (Zapis tokenów + Security Check)
  Future<void> _finalizeLogin(AuthResponse result) async {
    if (result.accessToken == null) throw Exception('errors.UNKNOWN_ERROR');

    // 1. Zapisz sesję
    await _sessionService.saveSession(
      accessToken: result.accessToken!,
      refreshToken: result.refreshToken!,
      userId: result.userId ?? '',
    );

    // 2. Zainicjuj logikę PINu/Biometrii
    // SecurityService sprawdzi czy PIN jest ustawiony i wymusi blokadę
    await ref.read(securityServiceProvider.notifier).init();

    // 3. Zmień stan na Zalogowany
    state = state.copyWith(
      status: AuthStatus.authenticated,
      userId: result.userId,
      email: null, // Wyczyść dane wrażliwe z pamięci
      tempToken: null,
    );
  }

  Future<void> logout() async {
    await _authService.logout();
    await _sessionService.clearSession();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void setError(String messageKey) {
    state = state.copyWith(error: messageKey);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
