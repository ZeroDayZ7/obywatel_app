import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/backend_sync.dart';
import 'package:obywatel_plus/core/security/pin/pin_attempt_state.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

class PinAttemptLimiter extends AsyncNotifier<PinAttemptState> {
  late final SecureStorageService _storage;

  @override
  Future<PinAttemptState> build() async {
    _storage = ref.read(secureStorageProvider);
    return _loadFromStorage();
  }

  Future<PinAttemptState> _loadFromStorage() async {
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
    return PinAttemptState(attempts: attempts, lockUntil: lockUntil);
  }

  Future<void> registerFailedAttempt() async {
    // Pobieramy aktualny stan (jeśli załadowany)
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

    // Aktualizujemy stan i zapisujemy
    state = AsyncData(newState);
    await _saveToStorage(newState);
  }

  Future<void> reset() async {
    const newState = PinAttemptState();
    state = const AsyncData(newState);
    await _saveToStorage(newState);
  }

  Future<void> _saveToStorage(PinAttemptState data) async {
    await _storage.write(
      key: StorageKeys.pinAttempts,
      value: data.attempts.toString(),
    );
    if (data.lockUntil != null) {
      await _storage.write(
        key: StorageKeys.pinLockUntil,
        value: data.lockUntil!.millisecondsSinceEpoch.toString(),
      );
    } else {
      await _storage.delete(key: StorageKeys.pinLockUntil);
    }
  }

  Duration _getLockDuration(int attempts) {
    if (attempts < 3) return Duration.zero;
    final lockCount = attempts - 2;
    final seconds = 60 * (1 << (lockCount - 1));
    return Duration(seconds: seconds);
  }
}

final pinAttemptLimiterProvider =
    AsyncNotifierProvider<PinAttemptLimiter, PinAttemptState>(
      PinAttemptLimiter.new,
    );
