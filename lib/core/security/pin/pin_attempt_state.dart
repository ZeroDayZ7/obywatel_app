import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_attempt_state.freezed.dart';

@freezed
sealed class PinAttemptState with _$PinAttemptState {
  const factory PinAttemptState({
    @Default(0) int attempts,
    DateTime? lockUntil,
  }) = _PinAttemptState;

  // Dodajemy helper wewnątrz modelu (wymaga pustego konstruktora const)
  const PinAttemptState._();
  bool get isLocked => lockUntil != null && DateTime.now().isBefore(lockUntil!);
}
