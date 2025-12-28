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
class PinAttemptLimiter extends Notifier<PinAttemptState> {
  late final SecureStorageService _storage;

  @override
  PinAttemptState build() {
    _storage = ref.read(secureStorageProvider);
    _loadState();
    return const PinAttemptState();
  }

  Future<void> _loadState() async {
    final attemptsStr = await _storage.read(key: StorageKeys.pinAttempts);
    final lockMillisStr = await _storage.read(key: StorageKeys.pinLockUntil);

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

  Future<void> _saveState() async {
    await _storage.write(
      key: StorageKeys.pinAttempts,
      value: state.attempts.toString(),
    );
    if (state.lockUntil != null) {
      await _storage.write(
        key: StorageKeys.pinLockUntil,
        value: state.lockUntil!.millisecondsSinceEpoch.toString(),
      );
    } else {
      await _storage.delete(key: StorageKeys.pinLockUntil);
    }
  }

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

  Future<void> reset() async {
    state = const PinAttemptState();
    await _saveState();
  }

  Duration _getLockDuration(int attempts) {
    const baseAttempts = 3;
    const baseDuration = 60;

    if (attempts <= baseAttempts) return Duration.zero;

    final lockCount = attempts - baseAttempts;
    final seconds = baseDuration * (1 << (lockCount - 1));

    return Duration(seconds: seconds);
  }
}

/// AutoDispose provider dla PinAttemptLimiter
final pinAttemptLimiterProvider =
    NotifierProvider<PinAttemptLimiter, PinAttemptState>(
      PinAttemptLimiter.new,
    );
