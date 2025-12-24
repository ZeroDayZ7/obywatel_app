import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_service.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/features/auth/domain/login_state.dart';

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() {
    return LoginState(email: apiConstants.defaultEmail);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void setEmail(String value) {
    state = state.copyWith(email: value, error: null);
  }

  /// Hasło nie jest przechowywane w stanie
  Future<void> onLogin({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final authService = ref.read(authServiceProvider);

    final result = await authService.login(email: email, password: password);

    if (!result.success) {
      state = state.copyWith(isLoading: false, error: result.error);
      return;
    }

    // Ustawiamy finalny stan tylko raz, bez dead code
    state = state.copyWith(
      isLoading: false,
      twoFaRequired: result.twoFaRequired,
    );
  }

  Future<LoginResult> verifyTwoFa({
    required String email,
    required String code,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authService = ref.read(authServiceProvider);
      final result = await authService.verifyTwoFa(email: email, code: code);

      if (!result.success) {
        state = state.copyWith(isLoading: false, error: result.error);
        return result;
      }

      state = state.copyWith(isLoading: false, twoFaRequired: false);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Wystąpił błąd. Spróbuj ponownie.',
      );
      return const LoginResult(success: false);
    }
  }
}

final loginNotifierProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);
