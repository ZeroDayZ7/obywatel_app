import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/core_providers.dart';

/// Model stanu autoryzacji użytkownika
class AuthState {
  final bool isLoggedIn;

  const AuthState({required this.isLoggedIn});

  factory AuthState.initial() => const AuthState(isLoggedIn: false);

  AuthState copyWith({bool? isLoggedIn}) =>
      AuthState(isLoggedIn: isLoggedIn ?? this.isLoggedIn);
}

/// Kontroler logiki autoryzacji
class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    return AuthState.initial();
  }

  /// Metoda inicjalizująca stan auth przy starcie aplikacji
  Future<void> init() async {
    state = const AsyncValue.loading();
    final authService = ref.read(authServiceProvider);
    final logger = ref.read(appLoggerProvider);

    try {
      final hasSession = await authService.validateToken();
      state = AsyncValue.data(AuthState(isLoggedIn: hasSession));
      logger.i('🔑 Auth initialized, loggedIn=$hasSession');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      logger.e('❌ Błąd inicjalizacji Auth', error: e, stackTrace: st);
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();
    final logger = ref.read(appLoggerProvider);
    final authService = ref.read(authServiceProvider);

    try {
      final result = await authService.login(email: email, password: password);

      if (result.success) {
        state = AsyncValue.data(const AuthState(isLoggedIn: true));
        logger.i('✅ Użytkownik zalogowany');
      } else {
        const userMessage = '❌ Błąd logowania';
        state = AsyncValue.error(userMessage, StackTrace.current);
        logger.e('❌ Błąd logowania: ${result.error}');
      }
    } catch (e, st) {
      // przechwytywanie surowych wyjątków np. DioException
      final friendlyMessage = '❌ Błąd połączenia z serwerem';
      state = AsyncValue.error(friendlyMessage, StackTrace.current);
      logger.e(friendlyMessage, error: e, stackTrace: st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final authService = ref.read(authServiceProvider);
    final logger = ref.read(appLoggerProvider);

    try {
      await authService.logout();
      state = AsyncValue.data(const AuthState(isLoggedIn: false));
      logger.i('🚪 Użytkownik wylogowany');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      logger.e('❌ Błąd podczas wylogowania', error: e, stackTrace: st);
    }
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
