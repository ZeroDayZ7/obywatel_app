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
    final securityNotifier = ref.read(securityServiceProvider.notifier);

    try {
      // 1. Sprawdź limit prób
      final limiterState = ref.read(pinAttemptLimiterProvider);
      if (limiterState.isLocked) {
        final remaining = limiterState.lockUntil!.difference(DateTime.now());
        state = state.copyWith(isLoading: false, lockRemaining: remaining);
        return;
      }

      // 2. Weryfikacja PIN (hash comparison)
      final isValid = await pinService.verifyPin(pin);

      if (isValid) {
        await pinLimiter.reset();

        // 3. Odblokuj aplikację (SecurityState: hasLocalLock -> false)
        // To wyzwoli AuthRefreshListenable -> Router -> pinLockGuard -> Redirect to Home
        await securityNotifier.unlockApp();

        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        await pinLimiter.registerFailedAttempt();
        state = state.copyWith(isLoading: false, isError: true);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, isError: true);
    }
  }
}

/// Provider do wywoływania logiki weryfikacji PIN
final pinVerificationProvider =
    NotifierProvider<PinVerificationNotifier, PinVerificationState>(
      PinVerificationNotifier.new,
    );
