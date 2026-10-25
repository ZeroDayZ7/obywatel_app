import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/security/pin/pin_attempt_limiter.dart';
import 'package:obywatel_plus/core/security/pin/pin_attempt_state.dart';

void main() {
  group('PinAttemptLimiter', () {
    test('lockDurationForAttempts applies an explicit upper bound', () {
      expect(PinAttemptLimiter.lockDurationForAttempts(2), Duration.zero);
      expect(PinAttemptLimiter.lockDurationForAttempts(3), const Duration(minutes: 1));
      expect(PinAttemptLimiter.lockDurationForAttempts(4), const Duration(minutes: 2));
      expect(
        PinAttemptLimiter.lockDurationForAttempts(20),
        PinAttemptLimiter.maxLockDuration,
      );
    });

    test('PinAttemptState reports lock based on a supplied time', () {
      final now = DateTime.now();
      final lockedState = PinAttemptState(
        attempts: 4,
        lockUntil: now.add(const Duration(minutes: 1)),
      );

      expect(lockedState.isLockedAt(now.add(const Duration(seconds: 30))), isTrue);
      expect(lockedState.isLockedAt(now.add(const Duration(minutes: 2))), isFalse);
    });
  });
}
