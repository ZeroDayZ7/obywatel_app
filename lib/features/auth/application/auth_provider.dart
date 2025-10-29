import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
// import 'package:obywatel_plus/app/di/injector.dart';

class AuthState {
  final bool isLoggedIn;

  const AuthState({required this.isLoggedIn});

  factory AuthState.initial() => const AuthState(isLoggedIn: false);

  AuthState copyWith({bool? isLoggedIn}) {
    return AuthState(isLoggedIn: isLoggedIn ?? this.isLoggedIn);
  }
}

class AuthNotifier extends Notifier<AuthState> {
  late final AppLogger _logger;

  @override
  AuthState build() {
    // _logger = sl<AppLogger>();
    // _logger.i('AuthNotifier initialized ✅');
    return AuthState.initial();
  }

  /// Oznacz użytkownika jako zalogowanego (token już zapisany w storage)
  void login() {
    state = state.copyWith(isLoggedIn: true);
    _logger.i('User logged in');
  }

  /// Oznacz użytkownika jako wylogowanego (token usunięty ze storage)
  void logout() {
    state = state.copyWith(isLoggedIn: false);
    _logger.i('User logged out');
  }
}

final authProvider = NotifierProvider.autoDispose<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
