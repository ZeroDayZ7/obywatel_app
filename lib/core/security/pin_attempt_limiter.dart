import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

/// Represents the current state of PIN attempts and lock status.
class PinAttemptState {
  /// Number of failed PIN attempts.
  final int attempts;

  /// Timestamp until which the PIN entry is locked.
  final DateTime? lockUntil;

  const PinAttemptState({this.attempts = 0, this.lockUntil});

  /// Returns true if the user is currently locked out.
  bool get isLocked => lockUntil != null && DateTime.now().isBefore(lockUntil!);
}

/// A Riverpod notifier that manages PIN attempt state and automatic lockouts.
///
/// It reads and writes the state to [secureStorageProvider] to prevent tampering.
/// Failed attempts increase the lock duration exponentially.
class PinAttemptLimiter extends Notifier<PinAttemptState> {
  PinAttemptLimiter() : super();

  @override
  PinAttemptState build() {
    // Load stored state on initialization
    _loadState();
    return const PinAttemptState();
  }

  /// Loads the current attempt count and lock timestamp from secure storage.
  Future<void> _loadState() async {
    final storage = ref.read(secureStorageProvider);

    final attemptsStr = await storage.read(key: StorageKeys.pinAttempts);
    final lockMillisStr = await storage.read(key: StorageKeys.pinLockUntil);

    final attempts = int.tryParse(attemptsStr ?? '') ?? 0;
    DateTime? lockUntil;
    if (lockMillisStr != null) {
      final millis = int.tryParse(lockMillisStr);
      if (millis != null) {
        lockUntil = DateTime.fromMillisecondsSinceEpoch(millis);
      }
    }

    state = PinAttemptState(attempts: attempts, lockUntil: lockUntil);
  }

  /// Saves the current state to secure storage.
  Future<void> _saveState() async {
    final storage = ref.read(secureStorageProvider);
    await storage.write(
      key: StorageKeys.pinAttempts,
      value: state.attempts.toString(),
    );
    if (state.lockUntil != null) {
      await storage.write(
        key: StorageKeys.pinLockUntil,
        value: state.lockUntil!.millisecondsSinceEpoch.toString(),
      );
    } else {
      await storage.delete(key: StorageKeys.pinLockUntil);
    }
  }

  /// Registers a failed PIN attempt, updates lock duration, and saves state.
  Future<void> registerFailedAttempt() async {
    final nextAttempts = state.attempts + 1;
    final lockDuration = _getLockDuration(nextAttempts);

    DateTime? lockUntil;
    if (lockDuration > Duration.zero) {
      lockUntil = DateTime.now().add(lockDuration);
    }

    state = PinAttemptState(attempts: nextAttempts, lockUntil: lockUntil);
    await _saveState();
  }

  /// Resets the attempt counter and unlocks the PIN entry.
  Future<void> reset() async {
    state = const PinAttemptState();
    await _saveState();
  }

  /// Determines the lock duration based on the number of failed attempts.
  ///
  /// - The first [baseAttempts] failures do not trigger a lock.
  /// - Each additional failure doubles the previous lock duration (exponential backoff).
  Duration _getLockDuration(int attempts) {
    const baseAttempts = 3; // attempts allowed before first lock
    const baseDuration = 60; // lock duration in seconds for the first lock

    if (attempts <= baseAttempts) return Duration.zero;

    // Calculate how many locks have been triggered above the base attempts
    final lockCount = attempts - baseAttempts;

    // Exponential backoff: duration = baseDuration * 2^(lockCount - 1)
    final seconds = baseDuration * (1 << (lockCount - 1));

    return Duration(seconds: seconds);
  }
}

/// A global provider for accessing and controlling PIN attempts and lock status.
final pinAttemptLimiterProvider =
    NotifierProvider<PinAttemptLimiter, PinAttemptState>(PinAttemptLimiter.new);
