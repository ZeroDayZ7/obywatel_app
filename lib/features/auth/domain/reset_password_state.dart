import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_state.freezed.dart';

@freezed
sealed class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState.initial() = _Initial;

  const factory ResetPasswordState.methodChosen({
    required String input,
    required ResetMethod method,
  }) = _MethodChosen;

  const factory ResetPasswordState.sendingCode({
    required String input,
    required ResetMethod method,
  }) = _SendingCode;

  const factory ResetPasswordState.codeSent({
    required String input,
    required ResetMethod method,
    @Default(30) int resendTime,
    @Default(false) bool canResend,
  }) = _CodeSent;

  const factory ResetPasswordState.verifyingCode() = _VerifyingCode;

  const factory ResetPasswordState.codeVerified() = _CodeVerified;

  const factory ResetPasswordState.resettingPassword() = _ResettingPassword;

  const factory ResetPasswordState.completed() = _Completed;

  const factory ResetPasswordState.error({required String message}) = _Error;
}

enum ResetMethod { email, phone }
