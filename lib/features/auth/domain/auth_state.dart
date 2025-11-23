// features/auth/domain/auth_state.dart
class AuthState {
  final bool isLoggedIn;
  final String? userId;

  const AuthState({required this.isLoggedIn, this.userId});

  factory AuthState.initial() => const AuthState(isLoggedIn: false);
}
