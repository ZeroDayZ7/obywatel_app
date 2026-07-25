import 'dart:async';

import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/backend_sync.dart';
import 'package:obywatel_plus/core/security/pin/pin_attempt_state.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pin_attempt_limiter.g.dart';

@Riverpod(keepAlive: true)
class PinAttemptLimiter extends _$PinAttemptLimiter {
  /// Maksymalna liczba nieudanych prób przed nałożeniem pierwszej blokady czasowej.
  static const int maxAttemptsBeforeLock = 3;

  @override
  Future<PinAttemptState> build() async {
    return _loadFromStorage();
  }

  Future<PinAttemptState> _loadFromStorage() async {
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
    return PinAttemptState(attempts: attempts, lockUntil: lockUntil);
  }

  /// Zwraca liczbę pozostałych prób przed blokadą czasową
  int get remainingAttempts {
    final currentAttempts = state.value?.attempts ?? 0;
    final remaining = maxAttemptsBeforeLock - currentAttempts;
    return remaining > 0 ? remaining : 0;
  }

  Future<void> registerFailedAttempt() async {
    final currentState = state.value ?? const PinAttemptState();

    final nextAttempts = currentState.attempts + 1;
    final lockDuration = _getLockDuration(nextAttempts);

    DateTime? lockUntil;
    if (lockDuration > Duration.zero) {
      final serverNow = ref.read(backendStateProvider.notifier).getSafeNow();
      lockUntil = serverNow.add(lockDuration);
    }

    ref
        .read(appLoggerProvider)
        .w(
          'PIN trial failed ($nextAttempts/$maxAttemptsBeforeLock). Device locked until: $lockUntil',
          module: 'SECURITY',
        );

    final newState = currentState.copyWith(
      attempts: nextAttempts,
      lockUntil: lockUntil,
    );

    state = AsyncData(newState);
    await _saveToStorage(newState);
  }

  Future<void> reset() async {
    const newState = PinAttemptState();
    state = const AsyncData(newState);
    await _saveToStorage(newState);
  }

  Future<void> _saveToStorage(PinAttemptState data) async {
    final storage = ref.read(secureStorageProvider);
    await storage.write(
      key: StorageKeys.pinAttempts,
      value: data.attempts.toString(),
    );

    if (data.lockUntil != null) {
      await storage.write(
        key: StorageKeys.pinLockUntil,
        value: data.lockUntil!.millisecondsSinceEpoch.toString(),
      );
    } else {
      await storage.delete(key: StorageKeys.pinLockUntil);
    }
  }

  Duration _getLockDuration(int attempts) {
    if (attempts < maxAttemptsBeforeLock) return Duration.zero;

    final lockCount = attempts - (maxAttemptsBeforeLock - 1);
    final seconds = 60 * (1 << (lockCount - 1));
    return Duration(seconds: seconds);
  }
}
