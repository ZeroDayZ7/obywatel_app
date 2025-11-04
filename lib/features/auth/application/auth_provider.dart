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
    final securityService = ref.read(securityServiceProvider.notifier);

    logger.i('AuthNotifier: Ładowanie stanu...');
    await securityService.init();

    // Teraz dostęp do hasSession przez state
    final isLoggedIn = securityService.state.hasSession;
    logger.i('AuthNotifier: Załadowano stan, isLoggedIn=$isLoggedIn');

    return AuthState(isLoggedIn: isLoggedIn);
  }

  Future<void> login() async {
    state = const AsyncValue.loading();
    final logger = ref.read(appLoggerProvider);
    final securityService = ref.read(securityServiceProvider.notifier);

    try {
      // Zapisywanie tokenu w secureStorage jeśli potrzebne
      // await securityService.secureStorage.write(...);

      // Aktualizacja stanu SecurityState zamiast pola
      securityService.state = securityService.state.copyWith(hasSession: true);

      state = AsyncValue.data(AuthState(isLoggedIn: true));
      logger.i('✅ Użytkownik zalogowany');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      logger.e('❌ Błąd logowania', error: e, stackTrace: st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final logger = ref.read(appLoggerProvider);
    final securityService = ref.read(securityServiceProvider.notifier);

    try {
      await securityService.secureStorage.delete(key: StorageKeys.accessToken);

      // Aktualizacja stanu SecurityState
      securityService.state = securityService.state.copyWith(hasSession: false);

      state = AsyncValue.data(AuthState(isLoggedIn: false));
      logger.i('🚪 Użytkownik wylogowany');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      logger.e('❌ Błąd podczas wylogowania', error: e, stackTrace: st);
    }
  }

  bool get isLoggedIn => state.value?.isLoggedIn ?? false;
}

/// Provider globalny odpowiedzialny za stan autoryzacji
final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
