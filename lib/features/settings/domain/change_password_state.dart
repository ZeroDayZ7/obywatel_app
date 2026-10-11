import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_state.freezed.dart';

enum ChangePasswordStatus {
  idle,
  validating,
  submitting,
  success,
  error,
}

@freezed
sealed class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    @Default(ChangePasswordStatus.idle) ChangePasswordStatus status,
    String? messageKey,
  }) = _ChangePasswordState;
}
