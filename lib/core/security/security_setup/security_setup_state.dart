import 'package:freezed_annotation/freezed_annotation.dart';

part 'security_setup_state.freezed.dart';

enum LocalSecurityMethod { none, pin, password }

enum SecuritySetupStage {
  notStarted,
  preparing,
  awaitingBackendConfirmation,
  confirmed,
  completed,
  recoveryRequired,
}

@freezed
sealed class SecuritySetupState with _$SecuritySetupState {
  const factory SecuritySetupState({
    required bool pinSet,
    required bool biometricAvailable,
    required bool biometricSet,
    @Default(LocalSecurityMethod.none) LocalSecurityMethod localSecurityMethod,
    @Default(false) bool secretConfigured,
    @Default(SecuritySetupStage.notStarted) SecuritySetupStage setupStage,
    @Default(false) bool trustDevice,
  }) = _SecuritySetupState;

  const SecuritySetupState._();

  bool get isPinMethod => localSecurityMethod == LocalSecurityMethod.pin;
  bool get isPasswordMethod => localSecurityMethod == LocalSecurityMethod.password;
  bool get canFinish =>
      secretConfigured &&
      localSecurityMethod != LocalSecurityMethod.none &&
      trustDevice &&
      setupStage != SecuritySetupStage.completed;

  factory SecuritySetupState.initial() => const SecuritySetupState(
    pinSet: false,
    biometricAvailable: false,
    biometricSet: false,
    localSecurityMethod: LocalSecurityMethod.none,
    secretConfigured: false,
    setupStage: SecuritySetupStage.notStarted,
    trustDevice: false,
  );
}
