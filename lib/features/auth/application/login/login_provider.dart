import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/core/errors/app_exception.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_error_provider.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_service.dart';
import 'package:obywatel_plus/features/auth/domain/login_state.dart';
import 'package:obywatel_plus/features/auth/domain/login_state_ui.dart';

final loginNotifierProvider =
    NotifierProvider<LoginNotifier, AsyncValue<LoginUiState>>(
      LoginNotifier.new,
    );

class LoginNotifier extends Notifier<AsyncValue<LoginUiState>> {
  @override
  AsyncValue<LoginUiState> build() {
    return AsyncData(
      LoginUiState(
        login: LoginState(email: apiConstants.defaultEmail),
        errorKey: null,
      ),
    );
  }

  void setEmail(String value) {
    final current = state.value!;
    state = AsyncData(
      current.copyWith(
        login: current.login.copyWith(email: value),
        errorKey: null,
      ),
    );
  }

  Future<void> login({required String email, required String password}) async {
    final previousState = state.value!;
    state = const AsyncLoading();

    try {
      final authService = ref.read(authServiceProvider);
      final result = await authService.login(email: email, password: password);

      // Sukces
      final newState = previousState.copyWith(
        login: LoginState(
          email: email,
          twoFaRequired: result.twoFaRequired,
          twoFaToken: result.twoFaToken,
        ),
        errorKey: null,
      );

      state = AsyncData(LoginUiState(login: newState.login));
    } catch (e) {
      final appException = AppException.fromDio(e);

      if (appException.type == ErrorType.system) {
        // BŁĄD KRYTYCZNY - Czerwony Toast
        ref
            .read(globalNotificationProvider.notifier)
            .show(appException.messageKey, type: NotificationType.error);
      } else {
        // BŁĄD DANYCH (np. niepoprawne hasło) - Żółty Toast (Ostrzeżenie)
        ref
            .read(globalNotificationProvider.notifier)
            .show(appException.messageKey, type: NotificationType.warning);
      }
      state = AsyncData(previousState);
    }
  }

  void clearError() {
    final current = state.value!;
    state = AsyncData(current.copyWith(errorKey: null));
  }

  void clearTwoFaRequired() {
    final current = state.value!;
    state = AsyncData(
      current.copyWith(
        login: current.login.copyWith(twoFaRequired: false, twoFaToken: null),
        errorKey: null,
      ),
    );
  }
}
