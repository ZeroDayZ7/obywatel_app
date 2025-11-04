import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

/// Model stanu autoryzacji użytkownika
class AuthState {
  final bool isLoggedIn;

  const AuthState({required this.isLoggedIn});

  factory AuthState.initial() => const AuthState(isLoggedIn: false);

  AuthState copyWith({bool? isLoggedIn}) {
    return AuthState(isLoggedIn: isLoggedIn ?? this.isLoggedIn);
  }
}

/// Główny kontroler logiki autoryzacji
class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final logger = ref.watch(appLoggerProvider);
    final securityService = ref.watch(securityServiceProvider);

    logger.i('AuthNotifier: Ładowanie stanu...');
    await securityService.init();

    final isLoggedIn = securityService.hasSession;
    logger.i('AuthNotifier: Załadowano stan, isLoggedIn=$isLoggedIn');

    return AuthState(isLoggedIn: isLoggedIn);
  }

  /// Zaloguj użytkownika (po udanym uwierzytelnieniu i zapisaniu tokenu)
  Future<void> login() async {
    state = const AsyncValue.loading();
    final logger = ref.read(appLoggerProvider);

    try {
      final securityService = ref.read(securityServiceProvider);

      // Jeśli używasz tokenów – zapisz token w secureStorage
      // await securityService.secureStorage.write(
      //   key: StorageKeys.accessToken,
      //   value: token,
      // );

      securityService.hasSession = true;
      state = AsyncValue.data(AuthState(isLoggedIn: true));
      logger.i('✅ Użytkownik zalogowany');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      logger.e('❌ Błąd logowania', error: e, stackTrace: st);
    }
  }

  /// Wyloguj użytkownika i wyczyść dane sesji
  Future<void> logout() async {
    state = const AsyncValue.loading();
    final logger = ref.read(appLoggerProvider);

    try {
      final securityService = ref.read(securityServiceProvider);
      await securityService.secureStorage.delete(key: StorageKeys.accessToken);
      securityService.hasSession = false;

      state = AsyncValue.data(AuthState(isLoggedIn: false));
      logger.i('🚪 Użytkownik wylogowany');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      logger.e('❌ Błąd podczas wylogowania', error: e, stackTrace: st);
    }
  }

  /// Pomocniczy getter — czy użytkownik jest zalogowany
  bool get isLoggedIn => state.value?.isLoggedIn ?? false;
}

/// Provider globalny odpowiedzialny za stan autoryzacji
final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
