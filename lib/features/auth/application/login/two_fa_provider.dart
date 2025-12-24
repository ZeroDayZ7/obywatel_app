// lib/features/auth/application/two_fa/two_fa_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/network/api_client.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/features/auth/domain/two_fa_state.dart';

class TwoFaNotifier extends Notifier<TwoFaState> {
  late final ApiClient _apiClient;
  late final AppLogger _logger;

  /// Email użytkownika, wymagany do weryfikacji
  String? _email;

  @override
  TwoFaState build() {
    return const TwoFaState();
  }

  void setEmail(String email) {
    _email = email;
  }

  void setError(String message) {
    state = state.copyWith(error: message);
  }

  /// Weryfikacja kodu 2FA
  Future<TwoFaState> verifyCode(String code) async {
    if (_email == null) {
      state = state.copyWith(error: 'Email is not set');
      return state;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.post(
        ApiEndpoints.twoFaVerify,
        data: {'email': _email, 'code': code},
      );

      // zakładamy, że backend zwraca success: true/false
      final success = response.data['success'] as bool? ?? false;

      if (!success) {
        state = state.copyWith(
          isLoading: false,
          error: response.data['message'] ?? 'Verification failed',
        );
        return state;
      }

      state = state.copyWith(isLoading: false, isVerified: true, error: null);
      return state;
    } catch (e, st) {
      _logger.e('2FA verification failed', error: e, stackTrace: st);
      state = state.copyWith(
        isLoading: false,
        error: 'Unexpected error occurred',
      );
      return state;
    }
  }

  /// Wyślij ponownie kod 2FA
  Future<void> resendCode() async {
    if (_email == null) return;

    if (state.resendCooldown > 0) return; // cooldown active

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _apiClient.post(ApiEndpoints.twoFaResend, data: {'email': _email});

      // przykładowy cooldown 30s
      state = state.copyWith(isLoading: false, resendCooldown: 30);

      // start cooldown timer
      _startCooldownTimer();
    } catch (e, st) {
      _logger.e('Resend 2FA code failed', error: e, stackTrace: st);
      state = state.copyWith(isLoading: false, error: 'Failed to resend code');
    }
  }

  void _startCooldownTimer() {
    const tick = Duration(seconds: 1);
    Future.doWhile(() async {
      if (state.resendCooldown <= 0) return false;
      await Future.delayed(tick);
      state = state.copyWith(resendCooldown: state.resendCooldown - 1);
      return true;
    });
  }

  /// Inicjalizacja dependencji
  void init({required ApiClient apiClient, required AppLogger logger}) {
    _apiClient = apiClient;
    _logger = logger;
  }
}

/// Provider 2FA
final twoFaProvider = NotifierProvider<TwoFaNotifier, TwoFaState>(
  () => TwoFaNotifier(),
);
