class LoginState {
  final String email;
  final bool twoFaRequired;
  final String? twoFaToken;

  const LoginState({
    this.email = '',
    this.twoFaRequired = false,
    this.twoFaToken,
  });

  LoginState copyWith({
    String? email,
    bool? twoFaRequired,
    String? twoFaToken,
  }) {
    return LoginState(
      email: email ?? this.email,
      twoFaRequired: twoFaRequired ?? this.twoFaRequired,
      twoFaToken: twoFaToken ?? this.twoFaToken,
    );
  }
}
