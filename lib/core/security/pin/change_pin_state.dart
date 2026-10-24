import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';

part 'change_pin_state.freezed.dart';

enum ChangePinOperationType {
  changeSecret,
  changeMethod,
}

enum ChangePinStep {
  selectMethod,
  idle,
  enterOld,
  enterNew,
  confirmNew,
  loading,
  success,
  error,
}

@freezed
abstract class ChangePinState with _$ChangePinState {
  const ChangePinState._();

  const factory ChangePinState({
    @Default(ChangePinStep.selectMethod) ChangePinStep step,
    @Default(LocalSecurityMethod.none) LocalSecurityMethod currentMethod,
    @Default(LocalSecurityMethod.none) LocalSecurityMethod targetMethod,
    @Default(ChangePinOperationType.changeSecret)
    ChangePinOperationType operationType,
    @Default(false) bool isSubmitting,
    String? errorMessageKey,
  }) = _ChangePinState;

  bool get isMethodSwitch =>
      operationType == ChangePinOperationType.changeMethod;

  bool get isCurrentPassword =>
      currentMethod == LocalSecurityMethod.password;

  bool get isTargetPassword =>
      targetMethod == LocalSecurityMethod.password;
}
