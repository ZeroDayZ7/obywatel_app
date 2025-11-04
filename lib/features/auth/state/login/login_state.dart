import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginState {
  final bool isLoading;
  final String? error;
  final String? nextRoute;

  const LoginState({this.isLoading = false, this.error, this.nextRoute});

  LoginState copyWith({bool? isLoading, String? error, String? nextRoute}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      nextRoute: nextRoute ?? this.nextRoute,
    );
  }
}

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void setLoading(bool value) => state = state.copyWith(isLoading: value);

  void setError(String? error) => state = state.copyWith(error: error);

  void setNextRoute(String? route) => state = state.copyWith(nextRoute: route);
}

final loginStateProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);
