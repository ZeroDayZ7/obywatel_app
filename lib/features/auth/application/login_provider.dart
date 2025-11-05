import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/auth/application/auth_provider.dart';
import 'package:obywatel_plus/app/config/env.dart';

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

  void setEmail(String value) => state = state.copyWith(email: value);
  void setPassword(String value) => state = state.copyWith(password: value);

  Future<void> onLogin() async {
    state = state.copyWith(isLoading: true, error: null);

    final authNotifier = ref.read(authProvider.notifier);

    try {
      await authNotifier.login(email: state.email, password: state.password);

      // Po login sprawdzamy stan authProvider
      final authState = ref.read(authProvider);
      if (authState is AsyncError) {
        state = state.copyWith(error: authState.error.toString());
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final loginStateProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);
