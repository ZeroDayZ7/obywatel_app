import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_state.freezed.dart';

enum ResetMethod { email, phone }

@freezed
class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState.initial() = _Initial;

  const factory ResetPasswordState.methodChosen({
    required String accountIdentifier,
    required String contactValue,
    required ResetMethod method,
  }) = _MethodChosen;

  const factory ResetPasswordState.loading() = _Loading;

  const factory ResetPasswordState.codeSent({
    required String accountIdentifier,
    required String contactValue,
    required ResetMethod method,
    required int resendTime,
    required bool canResend,
    String? token,
  }) = _CodeSent;

  const factory ResetPasswordState.codeVerified({
    String? token,
    String? challenge,
  }) = _CodeVerified;

  const factory ResetPasswordState.completed() = _Completed;
}
