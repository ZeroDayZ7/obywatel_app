import 'package:flutter/material.dart';

enum ResetStatus { initial, methodChosen, codeSent, codeVerified, error }

@immutable
class ResetState {
  const ResetState({this.status = ResetStatus.initial, this.errorMessage});

  final ResetStatus status;
  final String? errorMessage;

  ResetState copyWith({ResetStatus? status, String? errorMessage}) {
    return ResetState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
