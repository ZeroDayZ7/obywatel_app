import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_client.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/features/auth/application/login/login_provider.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/auth/domain/two_fa_state.dart';

final twoFaNotifierProvider =
    NotifierProvider<TwoFaNotifier, AsyncValue<TwoFaUiState>>(
      TwoFaNotifier.new,
    );

class TwoFaNotifier extends Notifier<AsyncValue<TwoFaUiState>> {
  late final ApiClient _apiClient;
  late final AppLogger _logger;

  @override
  AsyncValue<TwoFaUiState> build() {
    _apiClient = ref.read(apiClientProvider);
    _logger = ref.read(appLoggerProvider);

    return const AsyncData(TwoFaUiState());
  }

  Future<void> verifyCode(String code) async {
    final loginAsync = ref.read(loginNotifierProvider);
    final loginState = loginAsync.value?.login;

    if (loginState == null) return;

    final previous = state.value ?? const TwoFaUiState();

    state = const AsyncLoading();

    try {
      final response = await _apiClient.post(
        ApiEndpoints.twoFaVerify,
        data: {
          'email': loginState.email,
          'code': code,
          'token': loginState.twoFaToken,
        },
      );

      final success = response.data['success'] as bool? ?? false;

      if (!success) {
        state = AsyncData(
          previous.copyWith(
            errorKey: response.data['code'] ?? 'TWO_FA_INVALID',
          ),
        );
        return;
      }

      // 🔥 zamiast wywoływać login(), startujemy sesję
      final sessionService = ref.read(sessionServiceProvider.notifier);
      await sessionService.startSession(
        accessToken: response.data['access_token'],
        refreshToken: response.data['refresh_token'],
        userId: response.data['user_id']?.toString(),
      );

      final loginNotifier = ref.read(loginNotifierProvider.notifier);
      loginNotifier.clearTwoFaRequired();

      state = const AsyncData(TwoFaUiState());
    } on DioException catch (e, st) {
      final code = e.response?.data is Map ? e.response?.data['code'] : null;

      _logger.e('2FA verify failed', error: e, stackTrace: st);

      state = AsyncData(previous.copyWith(errorKey: code ?? 'UNKNOWN_ERROR'));
    } catch (e, st) {
      _logger.e('2FA verify failed', error: e, stackTrace: st);

      state = AsyncData(previous.copyWith(errorKey: 'UNKNOWN_ERROR'));
    }
  }

  Future<void> resendCode() async {
    final loginAsync = ref.read(loginNotifierProvider);
    final loginState = loginAsync.value?.login;

    if (loginState == null) return;

    final previous = state.value ?? const TwoFaUiState();

    state = const AsyncLoading();

    try {
      await _apiClient.post(
        ApiEndpoints.twoFaResend,
        data: {'email': loginState.email},
      );

      state = AsyncData(previous.copyWith(errorKey: null));
    } catch (e, st) {
      _logger.e('Resend 2FA failed', error: e, stackTrace: st);

      state = AsyncData(previous.copyWith(errorKey: 'TWO_FA_RESEND_FAILED'));
    }
  }

  void clearError() {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(current.copyWith(errorKey: null));
  }
}
