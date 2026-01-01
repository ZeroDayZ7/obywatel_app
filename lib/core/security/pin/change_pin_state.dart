import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_pin_state.freezed.dart';

@freezed
sealed class ChangePinState with _$ChangePinState {
  const factory ChangePinState.enterOld() = _EnterOld;
  const factory ChangePinState.enterNew() = _EnterNew;
  const factory ChangePinState.confirmNew() = _ConfirmNew;
  const factory ChangePinState.loading() = _Loading;
  const factory ChangePinState.success() = _Success;
  const factory ChangePinState.error(String messageKey) = _Error;

  // opcjonalny prywatny konstruktor (jak w PinAttemptState)
  const ChangePinState._();
}
