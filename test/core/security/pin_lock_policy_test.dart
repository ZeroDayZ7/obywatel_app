import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/security/pin/pin_attempt_limiter.dart';
import 'package:obywatel_plus/core/security/pin/pin_verification_notifier.dart';
import 'package:obywatel_plus/core/security/pin/pin_verification_state.dart';

void main() {
  group('PIN/Password policy', () {
    test('third failed attempt locks for 60 seconds while second does not', () {
      expect(PinAttemptLimiter.lockDurationForAttempts(2), Duration.zero);
      expect(
        PinAttemptLimiter.lockDurationForAttempts(3),
        const Duration(seconds: 60),
      );
      expect(
        PinAttemptLimiter.lockDurationForAttempts(4),
        const Duration(seconds: 120),
      );
    });

    test('verification retries are ignored while a check is already in progress', () {
      expect(
        PinVerificationNotifier.shouldIgnoreRetry(
          const PinVerificationState.loading(),
        ),
        isTrue,
      );
      expect(
        PinVerificationNotifier.shouldIgnoreRetry(
          const PinVerificationState.idle(),
        ),
        isFalse,
      );
    });
  });
}
