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
