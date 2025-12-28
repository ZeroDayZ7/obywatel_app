import 'package:freezed_annotation/freezed_annotation.dart';

part 'security_setup_state.freezed.dart';

@freezed
sealed class SecuritySetupState with _$SecuritySetupState {
  const factory SecuritySetupState({
    required bool pinSet,
    required bool biometricAvailable,
    required bool biometricSet,
  }) = _SecuritySetupState;

  const SecuritySetupState._();

  bool get canFinish => pinSet;

  factory SecuritySetupState.initial() => const SecuritySetupState(
    pinSet: false,
    biometricAvailable: false,
    biometricSet: false,
  );
}
