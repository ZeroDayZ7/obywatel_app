import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/security/pin/pin_verification_state.dart';
import 'package:obywatel_plus/core/security/pin/pin_attempt_limiter.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security_service_provider.dart';

class PinVerificationNotifier extends Notifier<PinVerificationState> {
  @override
  PinVerificationState build() => const PinVerificationState.idle();

  Future<void> verifyPin(String pin) async {
    state = const PinVerificationState.loading();

    final pinService = ref.read(pinServiceProvider);
    final limiter = ref.read(pinAttemptLimiterProvider.notifier);
    final security = ref.read(securityServiceProvider.notifier);

    final lock = ref.read(pinAttemptLimiterProvider);
    if (lock.isLocked) {
      state = PinVerificationState.locked(
        remaining: lock.lockUntil!.difference(DateTime.now()),
      );
      return;
    }

    final isValid = await pinService.verifyPin(pin);

    if (isValid) {
      await limiter.reset();
      await security.unlockApp();
      state = const PinVerificationState.success();
    } else {
      await limiter.registerFailedAttempt();
      state = const PinVerificationState.error();
    }
  }
}

final pinVerificationProvider =
    NotifierProvider.autoDispose<PinVerificationNotifier, PinVerificationState>(
      PinVerificationNotifier.new,
    );
