class LoginState {
  final bool isLoading;
  final String? error;
  final String email;
  final bool twoFaRequired;

  const LoginState({
    this.isLoading = false,
    this.error,
    this.email = '',
    this.twoFaRequired = false,
  });

  LoginState copyWith({
    bool? isLoading,
    String? error,
    String? email,
    bool? twoFaRequired,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      email: email ?? this.email,
      twoFaRequired: twoFaRequired ?? this.twoFaRequired,
    );
  }
}
