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

    test('lock is inactive exactly at expiration boundary', () {
      final now = DateTime.now();
      final lockUntil = now.add(const Duration(minutes: 1));
      final state = PinAttemptState(attempts: 4, lockUntil: lockUntil);

      expect(state.isLockedAt(lockUntil.subtract(const Duration(milliseconds: 1))), isTrue);
      expect(state.isLockedAt(lockUntil), isFalse);
      expect(state.isLockedAt(lockUntil.add(const Duration(seconds: 1))), isFalse);
    });

    test('expired lock is treated as inactive before timer starts', () {
      final now = DateTime.now();
      final expiredState = PinAttemptState(
        attempts: 4,
        lockUntil: now.subtract(const Duration(seconds: 1)),
      );

      expect(expiredState.isLockedAt(now), isFalse);
    });

    test('lock expiry is evaluated against the exact timestamp, not rounded seconds', () {
      final now = DateTime.fromMillisecondsSinceEpoch(1_000);
      final lockUntil = now.add(const Duration(seconds: 1));
      final state = PinAttemptState(attempts: 4, lockUntil: lockUntil);

      expect(state.isLockedAt(lockUntil.subtract(const Duration(milliseconds: 500))), isTrue);
      expect(state.isLockedAt(lockUntil), isFalse);
      expect(state.isExpiredAt(lockUntil), isTrue);
      expect(state.isExpiredAt(lockUntil.subtract(const Duration(milliseconds: 500))), isFalse);
    });
  });
}
