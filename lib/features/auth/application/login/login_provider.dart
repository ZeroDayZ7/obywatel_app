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

    state = state.copyWith(isLoading: false);
  }
}

final loginNotifierProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);
