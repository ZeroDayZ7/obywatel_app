import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/app/di/injector.dart';

// lib/features/auth/application/auth_provider.dart
import 'package:obywatel_plus/core/security/security_service_provider.dart'; // Dodaj zależność
import 'package:obywatel_plus/app/config/storage_keys.dart';

class AuthState {
  final bool isLoggedIn;

  const AuthState({required this.isLoggedIn});

  factory AuthState.initial() => const AuthState(isLoggedIn: false);

  AuthState copyWith({bool? isLoggedIn}) {
    return AuthState(isLoggedIn: isLoggedIn ?? this.isLoggedIn);
  }
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  final AppLogger _logger;

  AuthNotifier() : _logger = sl<AppLogger>();

  @override
  Future<AuthState> build() async {
    _logger.i('AuthNotifier: Ładowanie stanu...');
    // Automatycznie załaduj stan z SecurityService podczas build
    final securityService = ref.read(securityServiceProvider);
    await securityService.init(); // Czekaj na init, jeśli nie było wcześniej
    final isLoggedIn = securityService.hasSession;
    _logger.i('AuthNotifier: Załadowano stan, isLoggedIn=$isLoggedIn');
    return AuthState(isLoggedIn: isLoggedIn);
  }

  /// Oznacz użytkownika jako zalogowanego (token już zapisany)
  Future<void> login() async {
    state = const AsyncValue.loading();

    try {
      final securityService = ref.read(securityServiceProvider);
      // Tutaj możesz dodatkowo zapisać token, jeśli potrzeba
      securityService.hasSession = true; // Synchronizuj z service
      state = AsyncValue.data(
        state.value?.copyWith(isLoggedIn: true) ?? AuthState(isLoggedIn: true),
      );
      _logger.i('User logged in');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      _logger.e('Błąd login', error: e, stackTrace: st);
    }
  }

  /// Oznacz użytkownika jako wylogowanego
  Future<void> logout() async {
    state = const AsyncValue.loading();

    try {
      final securityService = ref.read(securityServiceProvider);
      // Usuń token z storage (jeśli masz metodę)
      await securityService.secureStorage.delete(key: StorageKeys.accessToken);
      securityService.hasSession = false; // Synchronizuj
      state = AsyncValue.data(
        state.value?.copyWith(isLoggedIn: false) ??
            AuthState(isLoggedIn: false),
      );
      _logger.i('User logged out');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      _logger.e('Błąd logout', error: e, stackTrace: st);
    }
  }

  // Helper: Czytaj synchroniczny stan (po załadowaniu)
  bool get isLoggedIn => state.value?.isLoggedIn ?? false;
}

// Provider teraz async
final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
