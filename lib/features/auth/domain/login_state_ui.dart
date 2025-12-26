import 'package:obywatel_plus/features/auth/domain/login_state.dart';

class LoginUiState {
  final LoginState login;
  final String? errorKey;

  const LoginUiState({required this.login, this.errorKey});

  LoginUiState copyWith({LoginState? login, String? errorKey}) {
    return LoginUiState(login: login ?? this.login, errorKey: errorKey);
  }
}
