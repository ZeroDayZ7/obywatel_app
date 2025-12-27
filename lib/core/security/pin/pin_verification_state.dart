import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_verification_state.freezed.dart';

@freezed
sealed class PinVerificationState with _$PinVerificationState {
  const factory PinVerificationState.idle() = _Idle;
  const factory PinVerificationState.loading() = _Loading;
  const factory PinVerificationState.success() = _Success;
  const factory PinVerificationState.error() = _Error;
  const factory PinVerificationState.locked({required Duration remaining}) =
      _Locked;
}
