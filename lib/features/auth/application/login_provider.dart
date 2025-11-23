import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/core/core_providers.dart'
    show authServiceProvider;

class LoginState {
  final bool isLoading;
  final String? error;
  final String email;
  final String password;

  const LoginState({
    this.isLoading = false,
    this.error,
    this.email = '',
    this.password = '',
  });

  LoginState copyWith({
    bool? isLoading,
    String? error,
    String? email,
    String? password,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() {
    return LoginState(
      email: apiConstants.defaultEmail,
      password: apiConstants.defaultPassword,
    );
  }

  void setEmail(String value) {
    state = state.copyWith(email: value, error: null);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value, error: null);
  }

  Future<void> onLogin() async {
    state = state.copyWith(isLoading: true, error: null);

    final authService = ref.read(authServiceProvider);

    final result = await authService.login(
      email: state.email,
      password: state.password,
    );

    if (!result.success) {
      state = state.copyWith(isLoading: false, error: result.error);
      return;
    }

    // SessionService ustawi isLoggedIn = true
    state = state.copyWith(isLoading: false);
  }
}

final loginStateProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);
