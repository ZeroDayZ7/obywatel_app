import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginState {
  final bool isLoading;
  final String? error;
  final String? nextRoute;

  LoginState({this.isLoading = false, this.error, this.nextRoute});

  LoginState copyWith({bool? isLoading, String? error, String? nextRoute}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      nextRoute: nextRoute ?? this.nextRoute,
    );
  }
}

// nowa wersja Notifier
class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => LoginState();

  void setLoading(bool value) => state = state.copyWith(isLoading: value);
  void setError(String? error) => state = state.copyWith(error: error);
  void setNextRoute(String? route) => state = state.copyWith(nextRoute: route);
}

// nowy provider
final loginStateProvider = NotifierProvider<LoginNotifier, LoginState>(
  () => LoginNotifier(),
);
