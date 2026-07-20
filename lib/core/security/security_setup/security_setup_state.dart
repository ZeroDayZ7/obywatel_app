import 'package:freezed_annotation/freezed_annotation.dart';

part 'security_setup_state.freezed.dart';

@freezed
sealed class SecuritySetupState with _$SecuritySetupState {
  const factory SecuritySetupState({
    required bool pinSet,
    required bool biometricAvailable,
    required bool biometricSet,
    @Default(false) bool trustDevice,
  }) = _SecuritySetupState;

  const SecuritySetupState._();

  bool get canFinish => pinSet && trustDevice;

  factory SecuritySetupState.initial() => const SecuritySetupState(
    pinSet: false,
    biometricAvailable: false,
    biometricSet: false,
    trustDevice: false,
  );
}
