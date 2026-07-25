import 'dart:async';

import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/backend_sync.dart';
import 'package:obywatel_plus/core/security/pin/pin_attempt_limiter.dart';
import 'package:obywatel_plus/core/security/pin/pin_attempt_state.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/pin/pin_verification_state.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pin_verification_notifier.g.dart';

@Riverpod(keepAlive: true)
class PinVerificationNotifier extends _$PinVerificationNotifier {
  Timer? _lockoutTimer;
  AppLogger get _log => ref.read(appLoggerProvider);

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

  Future<void> _handleFailedAttempt() async {
    // 1. Zarejestruj próbę (zapis do storage/zwiększenie licznika)
    await ref.read(pinAttemptLimiterProvider.notifier).registerFailedAttempt();

    // 2. Pobierz aktualny stan po zwiększeniu licznika
    final updatedLimiter = ref.read(pinAttemptLimiterProvider).value;

    if (updatedLimiter != null && updatedLimiter.isLocked) {
      // 3. Jeśli licznik przekroczył limit, oblicz pozostały czas
      final now = ref.read(backendStateProvider.notifier).getSafeNow();
      final initialRemaining = updatedLimiter.lockUntil!.difference(now);

      // 4. Ustaw stan zablokowania i uruchom licznik w UI
      state = PinVerificationState.locked(remaining: initialRemaining);
      _startLockoutTimer(updatedLimiter.lockUntil!);

      _log.w('Aplikacja zablokowana na: ${initialRemaining.inSeconds}s');
    } else {
      // 5. Jeśli to tylko zwykły błąd (jeszcze są próby)
      state = const PinVerificationState.error();

      final remaining = ref
          .read(pinAttemptLimiterProvider.notifier)
          .remainingAttempts;
      _log.w(
        'Błędny PIN. Pozostałe próby: $remaining / ${PinAttemptLimiter.maxAttemptsBeforeLock}',
      );
    }
  }

  Future<void> verifyPin(List<int> pinCodes) async {
    state = const PinVerificationState.loading();

    final ok = await ref.read(pinServiceProvider).verifyPin(pinCodes);

    if (!ok) {
      await _handleFailedAttempt();
      return;
    }

    state = const PinVerificationState.success();

    final sessionValid = await ref
        .read(authControllerProvider.notifier)
        .unlockWithPinAndValidateSession();

    if (!sessionValid) {
      _log.w(
        'Sesja nieprawidłowa po podaniu PIN-u. Przekierowanie do logowania.',
      );
      state = const PinVerificationState.error();
    }
  }
}
