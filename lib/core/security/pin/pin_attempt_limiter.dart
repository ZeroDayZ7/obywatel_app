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

  Future<void> registerFailedAttempt() async {
    // Generator obsługuje stan asynchroniczny, pobieramy aktualną wartość
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
          'PIN trial failed ($nextAttempts). Device locked until: $lockUntil',
          module: 'SECURITY',
        );

    final newState = currentState.copyWith(
      attempts: nextAttempts,
      lockUntil: lockUntil,
    );

    // W generatorze używamy state = AsyncData(newState)
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
    if (attempts < 3) return Duration.zero;
    final lockCount = attempts - 2;
    // Wykładniczy wzrost blokady: 60s, 120s, 240s...
    final seconds = 60 * (1 << (lockCount - 1));
    return Duration(seconds: seconds);
  }
}
