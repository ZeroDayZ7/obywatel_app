class LoginState {
  final bool isLoading;
  final String? error;
  final String email;

  const LoginState({
    this.isLoading = false,
    this.error,
    this.email = '',
  });

  LoginState copyWith({
    bool? isLoading,
    String? error,
    String? email,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      email: email ?? this.email,
    );
  }
}
