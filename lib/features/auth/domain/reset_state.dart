enum ResetStatus {
  initial,
  methodChosen,
  sending,
  codeSent,
  verifying,
  codeVerified,
  resetting,
  error,
  completed,
}

class ResetState {
  final ResetStatus status;
  final String? input; // email lub phone
  final bool? isEmail;
  final String? errorMessage;
  final int resendTime;
  final bool canResend;

  const ResetState({
    this.status = ResetStatus.initial,
    this.input,
    this.isEmail,
    this.errorMessage,
    this.resendTime = 30,
    this.canResend = false,
  });

  ResetState copyWith({
    ResetStatus? status,
    String? input,
    bool? isEmail,
    String? errorMessage,
    int? resendTime,
    bool? canResend,
  }) {
    return ResetState(
      status: status ?? this.status,
      input: input ?? this.input,
      isEmail: isEmail ?? this.isEmail,
      errorMessage: errorMessage ?? this.errorMessage,
      resendTime: resendTime ?? this.resendTime,
      canResend: canResend ?? this.canResend,
    );
  }
}
