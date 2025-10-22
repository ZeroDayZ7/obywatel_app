import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stan Auth – trzyma info o tokenie i zalogowaniu
class AuthState {
  final bool isLoggedIn;
  final String? token;

  AuthState({required this.isLoggedIn, this.token});

  factory AuthState.initial() => AuthState(isLoggedIn: false);

  AuthState copyWith({bool? isLoggedIn, String? token}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token ?? this.token,
    );
  }
}

/// Notifier zarządzający auth
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => AuthState.initial();

  void login(String token) {
    state = state.copyWith(isLoggedIn: true, token: token);
  }

  void logout() {
    state = state.copyWith(isLoggedIn: false, token: null);
  }
}

/// Provider dla całej aplikacji
final authProvider = NotifierProvider.autoDispose<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
