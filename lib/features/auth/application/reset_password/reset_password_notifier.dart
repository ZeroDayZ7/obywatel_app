import 'dart:async';

import 'package:obywatel_plus/core/errors/global_notification_provider.dart';
import 'package:obywatel_plus/features/auth/application/reset_password/reset_password_service.dart';
import 'package:obywatel_plus/features/auth/application/reset_password/reset_password_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_password_notifier.g.dart';

@riverpod
class ResetPasswordNotifier extends _$ResetPasswordNotifier {
  Timer? _timer;
  void Function()? _closeKeepAlive;

  @override
  ResetPasswordState build() {
    ref.onDispose(() {
      _timer?.cancel();
      _closeKeepAlive?.call();
    });

    return const ResetPasswordState.initial();
  }

  void setMethod({
    required String accountIdentifier,
    required String contactValue,
    required bool isEmail,
  }) {
    state = ResetPasswordState.methodChosen(
      accountIdentifier: accountIdentifier,
      contactValue: contactValue,
      method: isEmail ? ResetMethod.email : ResetMethod.phone,
    );
  }

  Future<void> sendResetCode() async {
    final currentState = state;

    String? accountIdentifier;
    String? contactValue;
    ResetMethod? method;

    currentState.maybeMap(
      methodChosen: (s) {
        accountIdentifier = s.accountIdentifier;
        contactValue = s.contactValue;
        method = s.method;
      },
      orElse: () {},
    );

    if (accountIdentifier == null || contactValue == null || method == null) {
      return;
    }

    // Blokujemy autoDispose na czas trwania procedury
    _closeKeepAlive ??= ref.keepAlive().close;

    state = const ResetPasswordState.loading();

    try {
      final token = await sendResetCodeApi(
        ref: ref,
        accountIdentifier: accountIdentifier!,
        contactValue: contactValue!,
        isEmail: method == ResetMethod.email,
      );

      state = ResetPasswordState.codeSent(
        accountIdentifier: accountIdentifier!,
        contactValue: contactValue!,
        method: method!,
        resendTime: 30,
        canResend: false,
        token: token,
      );

      _startTimer();
    } catch (e) {
      ref.read(globalNotificationProvider.notifier).showFromError(e);

      state = ResetPasswordState.methodChosen(
        accountIdentifier: accountIdentifier!,
        contactValue: contactValue!,
        method: method!,
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      state.maybeMap(
        codeSent: (s) {
          if (s.resendTime <= 1) {
            t.cancel();

            state = s.copyWith(resendTime: 0, canResend: true);
          } else {
            state = s.copyWith(resendTime: s.resendTime - 1);
          }
        },
        orElse: () => t.cancel(),
      );
    });
  }

  Future<void> verifyCode(String code) async {
    final previousState = state;

    String? token;

    state.maybeMap(codeSent: (s) => token = s.token, orElse: () {});

    state = const ResetPasswordState.loading();

    try {
      final response = await verifyResetCodeApi(
        ref: ref,
        code: code,
        token: token,
      );

      state = ResetPasswordState.codeVerified(
        token: (response['reset_token'] as String?) ?? token,
        challenge: response['challenge'] as String?,
      );
    } catch (e) {
      ref.read(globalNotificationProvider.notifier).showFromError(e);

      state = previousState;
    }
  }

  Future<void> confirmReset({
    required String code,
    required String newPassword,
  }) async {
    final currentState = state;

    String? resetToken;
    String? serverChallenge;

    currentState.maybeMap(
      codeVerified: (s) {
        resetToken = s.token;
        serverChallenge = s.challenge;
      },
      orElse: () {},
    );

    if (resetToken == null || serverChallenge == null) {
      return;
    }

    state = const ResetPasswordState.loading();

    try {
      // Wywołanie API zmiany hasła
      state = const ResetPasswordState.completed();

      // Po pełnym sukcesie zwalniamy blokadę — jeśli użytkownik wyjdzie z ekranu, provider się zczyści
      _closeKeepAlive?.call();
      _closeKeepAlive = null;
    } catch (e) {
      ref.read(globalNotificationProvider.notifier).showFromError(e);

      state = currentState;
    }
  }
}
