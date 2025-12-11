class SecurityState {
  final bool isPinSet;
  final bool isPatternSet;
  final bool isBiometricEnabled;

  const SecurityState({
    this.isPinSet = false,
    this.isPatternSet = false,
    this.isBiometricEnabled = false,
  });

  SecurityState copyWith({
    bool? isPinSet,
    bool? isPatternSet,
    bool? isBiometricEnabled,
  }) {
    return SecurityState(
      isPinSet: isPinSet ?? this.isPinSet,
      isPatternSet: isPatternSet ?? this.isPatternSet,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }
}
