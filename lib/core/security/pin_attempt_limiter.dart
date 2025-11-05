import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/core_providers.dart';

class PinAttemptState {
  final int attempts;
  final DateTime? lockUntil;

  const PinAttemptState({this.attempts = 0, this.lockUntil});

  bool get isLocked => lockUntil != null && DateTime.now().isBefore(lockUntil!);
}

class PinAttemptLimiter extends Notifier<PinAttemptState> {
  PinAttemptLimiter() : super();

  @override
  PinAttemptState build() {
    _loadState();
    return const PinAttemptState();
  }

  Future<void> _loadState() async {
    final storage = ref.read(secureStorageProvider);

    final attemptsStr = await storage.read(key: 'pin_attempts');
    final lockMillisStr = await storage.read(key: 'pin_lock_until');

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
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: 'pin_attempts', value: state.attempts.toString());
    if (state.lockUntil != null) {
      await storage.write(
        key: 'pin_lock_until',
        value: state.lockUntil!.millisecondsSinceEpoch.toString(),
      );
    } else {
      await storage.delete(key: 'pin_lock_until');
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
    const baseAttempts = 3; // ile prób bez blokady
    const baseDuration = 60; // czas blokady w sekundach przy pierwszym locku

    if (attempts <= baseAttempts) return Duration.zero;

    // liczba locków = ile prób powyżej baseAttempts
    final lockCount = attempts - baseAttempts;

    // czas = baseDuration * 2^(lockCount-1)
    final seconds =
        baseDuration *
        (1 << (lockCount - 1)); // bitowy shift = mnożenie przez 2^n

    return Duration(seconds: seconds);
  }
}

final pinAttemptLimiterProvider =
    NotifierProvider<PinAttemptLimiter, PinAttemptState>(PinAttemptLimiter.new);
