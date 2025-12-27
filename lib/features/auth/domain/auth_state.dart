// features/auth/domain/auth_state.dart
import 'package:equatable/equatable.dart';

enum AuthStatus {
  initial,        // Stan początkowy (nieużywany obecnie)
  unauthenticated, // 1. Start / Wylogowany
  authenticating, // 2. Kręci się spinner
  twoFaRequired, // 3. Wymagany kod 2FA
  authenticated, // 4. Zalogowany (sesja aktywna)
}

class AuthState extends Equatable {
  final AuthStatus status;
  final String? email; // Przechowujemy email potrzebny do 2FA
  final String? tempToken; // Token tymczasowy dla 2FA
  final String? userId; // ID usera po zalogowaniu
  final Object? error; // Błąd (np. "Złe hasło")

  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.email,
    this.tempToken,
    this.userId,
    this.error,
  });

  // Helpery dla UI
  bool get isLoading => status == AuthStatus.authenticating;
  bool get isTwoFa => status == AuthStatus.twoFaRequired;
  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    String? email,
    String? tempToken,
    String? userId,
    Object? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      email: email ?? this.email,
      tempToken: tempToken ?? this.tempToken,
      userId: userId ?? this.userId,
      error:
          error, // null nie resetuje, trzeba jawnie null'ować w logice jeśli chcemy
    );
  }

  // Metoda do czyszczenia błędu bez zmiany reszty
  AuthState clearError() => copyWith(error: null);

  @override
  List<Object?> get props => [status, email, tempToken, userId, error];
}
