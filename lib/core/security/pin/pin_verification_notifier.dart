import 'dart:async';

import 'package:obywatel_plus/core/network/backend_sync.dart';
import 'package:obywatel_plus/core/security/pin/pin_attempt_limiter.dart';
import 'package:obywatel_plus/core/security/pin/pin_attempt_state.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/pin/pin_verification_state.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pin_verification_notifier.g.dart';

@Riverpod(keepAlive: true)
class PinVerificationNotifier extends _$PinVerificationNotifier {
  Timer? _lockoutTimer;

  @override
  PinVerificationState build() {
    // Słuchamy zmian w limiterze
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

    // Pobieramy notifier raz, by nie czytać go w pętli
    final backendNotifier = ref.read(backendStateProvider.notifier);

    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      // KLUCZ: Używamy skorygowanego czasu serwerowego
      final now = backendNotifier.getSafeNow();
      final remaining = lockUntil.difference(now);

      if (remaining.inSeconds <= 0) {
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
    final limiterAsync = ref.read(pinAttemptLimiterProvider);
    if (limiterAsync.isLoading) return;

    final limiterData = limiterAsync.value;
    if (limiterData != null && limiterData.isLocked) {
      _startLockoutTimer(limiterData.lockUntil!);
      return;
    }

    state = const PinVerificationState.loading();

    // Używamy wygenerowanego pinServiceProvider
    final isValid = await ref.read(pinServiceProvider).verifyPin(pinCodes);

    if (isValid) {
      await ref.read(pinAttemptLimiterProvider.notifier).reset();
      await ref.read(securityServiceProvider.notifier).unlockApp();
      state = const PinVerificationState.success();
    } else {
      // 1. Zarejestruj próbę (to jest asynchroniczne)
      await ref
          .read(pinAttemptLimiterProvider.notifier)
          .registerFailedAttempt();

      // 2. Pobierz aktualny stan limitera
      final updatedLimiter = ref.read(pinAttemptLimiterProvider).value;

      if (updatedLimiter != null && updatedLimiter.isLocked) {
        // 3. OD RAU ustaw stan weryfikacji na locked, żeby UI nie mignął błędem
        final now = ref.read(backendStateProvider.notifier).getSafeNow();
        final initialRemaining = updatedLimiter.lockUntil!.difference(now);

        state = PinVerificationState.locked(remaining: initialRemaining);
        _startLockoutTimer(updatedLimiter.lockUntil!);
      } else {
        state = const PinVerificationState.error();
      }
    }

    // Bezpieczeństwo: czyścimy bajty w pamięci
    for (int i = 0; i < pinCodes.length; i++) {
      pinCodes[i] = 0;
    }
  }
}
