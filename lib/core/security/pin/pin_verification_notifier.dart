import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/security/pin/pin_attempt_limiter.dart';
import 'package:obywatel_plus/core/security/pin/pin_attempt_state.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/pin/pin_verification_state.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';

class PinVerificationNotifier extends Notifier<PinVerificationState> {
  Timer? _lockoutTimer;

  @override
  PinVerificationState build() {
    // Słuchamy zmian w limiterze. Gdy tylko dane się załadują (AsyncData)
    // i okaże się, że jest blokada, odpalany timer.
    ref.listen<AsyncValue<PinAttemptState>>(pinAttemptLimiterProvider, (
      prev,
      next,
    ) {
      next.whenData((data) {
        if (data.isLocked && _lockoutTimer == null) {
          _startLockoutTimer(data.lockUntil!);
        }
      });
    });

    ref.onDispose(() => _lockoutTimer?.cancel());
    return const PinVerificationState.idle();
  }

  void _startLockoutTimer(DateTime lockUntil) {
    _lockoutTimer?.cancel();
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final now = DateTime.now();
      final remaining = lockUntil.difference(now);

      if (remaining.isNegative || remaining.inSeconds <= 0) {
        timer.cancel();
        _lockoutTimer = null;
        await ref.read(pinAttemptLimiterProvider.notifier).reset();
        state = const PinVerificationState.idle();
      } else {
        state = PinVerificationState.locked(remaining: remaining);
      }
    });
  }

  Future<void> verifyPin(List<int> pinCodes) async {
    // 1. Pobieramy aktualną wartość limitera
    final limiterAsync = ref.read(pinAttemptLimiterProvider);

    if (limiterAsync.isLoading) return;

    final limiterData = limiterAsync.value;
    if (limiterData != null && limiterData.isLocked) {
      _startLockoutTimer(limiterData.lockUntil!);
      return;
    }

    state = const PinVerificationState.loading();

    // TERAZ ZADZIAŁA: Przekazujemy List<int> do PinService
    final isValid = await ref.read(pinServiceProvider).verifyPin(pinCodes);

    if (isValid) {
      await ref.read(pinAttemptLimiterProvider.notifier).reset();
      await ref.read(securityServiceProvider.notifier).unlockApp();
      state = const PinVerificationState.success();
    } else {
      await ref
          .read(pinAttemptLimiterProvider.notifier)
          .registerFailedAttempt();

      final updatedLimiter = ref.read(pinAttemptLimiterProvider).value;
      if (updatedLimiter != null && updatedLimiter.isLocked) {
        _startLockoutTimer(updatedLimiter.lockUntil!);
      } else {
        state = const PinVerificationState.error();
      }
    }

    // DOBRA PRAKTYKA: Czyścimy listę wejściową po zakończeniu operacji
    for (int i = 0; i < pinCodes.length; i++) {
      pinCodes[i] = 0;
    }
  }
}

final pinVerificationProvider =
    NotifierProvider.autoDispose<PinVerificationNotifier, PinVerificationState>(
      PinVerificationNotifier.new,
    );
