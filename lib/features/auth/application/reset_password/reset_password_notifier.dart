import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/errors/global_error_provider.dart';
import 'package:obywatel_plus/features/auth/application/reset_password/reset_password_provider.dart';
import 'package:obywatel_plus/features/auth/application/reset_password/reset_password_service.dart';
import 'package:obywatel_plus/features/auth/domain/reset_password_state.dart';

final resetPasswordProvider =
    NotifierProvider<ResetPasswordNotifier, ResetPasswordState>(
      ResetPasswordNotifier.new,
    );

class ResetPasswordNotifier extends Notifier<ResetPasswordState> {
  late final ResetPasswordService _service;
  Timer? _timer;

  @override
  ResetPasswordState build() {
    _service = ref.read(resetPasswordServiceProvider);
    ref.onDispose(() => _timer?.cancel());
    return const ResetPasswordState.initial();
  }

  // Ustawienie metody resetu
  void setMethod(String input, bool isEmail) {
    state = ResetPasswordState.methodChosen(
      input: input,
      method: isEmail ? ResetMethod.email : ResetMethod.phone,
    );
  }

  // Wysyłanie kodu resetującego
  Future<void> sendResetCode() async {
    state.maybeWhen(
      methodChosen: (input, method) async {
        state = ResetPasswordState.sendingCode(input: input, method: method);
        try {
          await _service.sendCode(
            isEmail: method == ResetMethod.email,
            value: input,
          );
          state = ResetPasswordState.codeSent(
            input: input,
            method: method,
            resendTime: 30,
            canResend: false,
          );
          _startTimer();
        } catch (e) {
          ref.read(globalNotificationProvider.notifier).showFromError(e);
          state = ResetPasswordState.methodChosen(input: input, method: method);
        }
      },
      orElse: () {},
    );
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      state = state.maybeWhen(
        codeSent: (input, method, resendTime, canResend) {
          final newTime = resendTime - 1;
          if (newTime <= 0) {
            t.cancel();
            return ResetPasswordState.codeSent(
              input: input,
              method: method,
              resendTime: 0,
              canResend: true,
            );
          }
          return ResetPasswordState.codeSent(
            input: input,
            method: method,
            resendTime: newTime,
            canResend: canResend,
          );
        },
        orElse: () => state,
      );
    });
  }

  // Weryfikacja kodu
  Future<void> verifyCode(String code) async {
    state = const ResetPasswordState.verifyingCode();
    try {
      await _service.verifyCode(code);
      state = const ResetPasswordState.codeVerified();
    } catch (e) {
      ref.read(globalNotificationProvider.notifier).showFromError(e);
      state = const ResetPasswordState.codeSent(
        input: '',
        method: ResetMethod.email,
        resendTime: 0,
        canResend: true,
      );
    }
  }

  // Resetowanie hasła
  Future<void> resetPassword(String password) async {
    state = const ResetPasswordState.resettingPassword();
    try {
      await _service.resetPassword(password);
      state = const ResetPasswordState.completed();
    } catch (e) {
      ref.read(globalNotificationProvider.notifier).showFromError(e);
      state = const ResetPasswordState.codeVerified();
    }
  }
}
