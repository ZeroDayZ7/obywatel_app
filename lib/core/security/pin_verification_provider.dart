import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/security/pin_service.dart';

/// State klasy przechowujący informacje o weryfikacji PIN
class PinVerificationState {
  final bool isLoading;
  final bool isError;
  final bool isSuccess;
  final Duration? lockRemaining;

  const PinVerificationState({
    this.isLoading = false,
    this.isError = false,
    this.isSuccess = false,
    this.lockRemaining,
  });

  PinVerificationState copyWith({
    bool? isLoading,
    bool? isError,
    bool? isSuccess,
    Duration? lockRemaining,
  }) {
    return PinVerificationState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      isSuccess: isSuccess ?? this.isSuccess,
      lockRemaining: lockRemaining,
    );
  }
}

class PinVerificationNotifier extends Notifier<PinVerificationState> {
  @override
  PinVerificationState build() => const PinVerificationState();

  Future<void> verifyPin({required WidgetRef ref, required String pin}) async {
    state = state.copyWith(isLoading: true, isError: false, isSuccess: false);

    final pinService = ref.read(pinServiceProvider);
    final pinLimiter = ref.read(pinAttemptLimiterProvider.notifier);
    final securityService = ref.read(securityServiceProvider.notifier);

    try {
      final limiterState = ref.read(pinAttemptLimiterProvider);

      if (limiterState.isLocked) {
        final remaining = limiterState.lockUntil!.difference(DateTime.now());
        state = state.copyWith(lockRemaining: remaining);
        return;
      }

      final isValid = await pinService.verifyPin(pin);

      if (isValid) {
        await pinLimiter.reset();
        await securityService.unlockApp();
        state = state.copyWith(isSuccess: true, lockRemaining: null);
        // await Future.delayed(const Duration(milliseconds: 100));
      
      } else {
        await pinLimiter.registerFailedAttempt();
        state = state.copyWith(isError: true);
      }
    } catch (_) {
      state = state.copyWith(isError: true);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

/// Provider do wywoływania logiki weryfikacji PIN
final pinVerificationProvider =
    NotifierProvider<PinVerificationNotifier, PinVerificationState>(
      PinVerificationNotifier.new,
    );
