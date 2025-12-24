import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/core/network/public_client.dart';
import 'package:obywatel_plus/features/auth/domain/reset_state.dart';

// Provider dla ResetNotifier
final resetServiceProvider = NotifierProvider<ResetNotifier, ResetState>(
  ResetNotifier.new,
);

class ResetNotifier extends Notifier<ResetState> {
  late final PublicApiClient _api;
  late final AppLogger _logger;
  Timer? _resendTimer;

  @override
  ResetState build() {
    final api = ref.read(publicApiClientProvider);
    final logger = ref.read(appLoggerProvider);

    _api = api;
    _logger = logger;

    _logger.i('ResetNotifier initialized');
    return const ResetState();
  }

  void setMethod(String input, bool isEmail) {
    state = state.copyWith(
      input: input,
      isEmail: isEmail,
      status: ResetStatus.methodChosen,
      errorMessage: null,
    );
    _logger.i('Method set: ${isEmail ? 'email' : 'phone'} -> $input');
  }

  Future<bool> sendResetCode() async {
    if (state.status == ResetStatus.codeSent) {
      _logger.w('sendResetCode called but code already sent');
      return false;
    }

    state = state.copyWith(status: ResetStatus.sending);
    _logger.i('Sending reset code to ${state.isEmail! ? 'email' : 'phone'}');

    try {
      final response = await _api.post(
        ApiEndpoints.reset,
        data: {
          'method': state.isEmail! ? 'email' : 'phone',
          'value': state.input,
        },
      );
      _logger.i(
        'Reset code sent successfully response: $response',
        error: null,
        stackTrace: null,
      );

      state = state.copyWith(
        status: ResetStatus.codeSent,
        canResend: false,
        resendTime: 30,
        errorMessage: null,
      );
      _startResendTimer();
      return true;
    } catch (e, st) {
      _logger.e('Failed to send reset code', error: e, stackTrace: st);
      state = state.copyWith(
        status: ResetStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void _startResendTimer() {
    int countdown = state.resendTime;
    _resendTimer?.cancel();
    _logger.i('Starting resend timer: $countdown seconds');

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        countdown--;
        state = state.copyWith(resendTime: countdown);
      } else {
        state = state.copyWith(canResend: true);
        timer.cancel();
        _logger.i('Resend timer finished, user can resend code now');
      }
    });

    ref.onDispose(() {
      _resendTimer?.cancel();
      _logger.i('ResetNotifier disposed, timer cancelled');
    });
  }

  Future<bool> verifyCode(String code) async {
    if (code.length != 6) {
      state = state.copyWith(errorMessage: 'Kod musi mieć 6 cyfr');
      _logger.w('verifyCode called with invalid code length: $code');
      return false;
    }

    state = state.copyWith(status: ResetStatus.verifying);
    _logger.i('Verifying code: $code');

    try {
      final response = await _api.post(
        ApiEndpoints.verifyResetCode,
        data: {'code': code},
      );
      _logger.i(
        'Code verified successfully response: $response',
        error: null,
        stackTrace: null,
      );

      state = state.copyWith(
        status: ResetStatus.codeVerified,
        errorMessage: null,
      );
      return true;
    } catch (e, st) {
      _logger.e('Failed to verify code', error: e, stackTrace: st);
      state = state.copyWith(
        status: ResetStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> resetPassword(String newPassword) async {
    if (newPassword.length < 8) {
      state = state.copyWith(errorMessage: 'Hasło za krótkie');
      _logger.w('resetPassword called with too short password');
      return false;
    }

    state = state.copyWith(status: ResetStatus.resetting);
    _logger.i('Resetting password');

    try {
      final response = await _api.post(
        ApiEndpoints.resetFinal,
        data: {'password': newPassword},
      );
      _logger.i(
        'Password reset successfully response: $response',
        error: null,
        stackTrace: null,
      );

      state = state.copyWith(status: ResetStatus.completed);
      return true;
    } catch (e, st) {
      _logger.e('Failed to reset password:', error: e, stackTrace: st);
      state = state.copyWith(
        status: ResetStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}
