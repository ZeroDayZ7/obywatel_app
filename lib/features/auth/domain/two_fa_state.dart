class TwoFaUiState {
  final String? errorKey;

  const TwoFaUiState({this.errorKey});

  TwoFaUiState copyWith({String? errorKey}) {
    return TwoFaUiState(errorKey: errorKey);
  }
}
