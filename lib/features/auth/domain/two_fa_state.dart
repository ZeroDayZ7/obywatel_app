// lib\features\auth\domain\two_fa_state.dart
class TwoFaState {
  final bool isLoading;
  final String? error;
  final bool isVerified;
  final int resendCooldown;

  const TwoFaState({
    this.isLoading = false,
    this.error,
    this.isVerified = false,
    this.resendCooldown = 0,
  });

  TwoFaState copyWith({
    bool? isLoading,
    String? error,
    bool? isVerified,
    int? resendCooldown,
  }) {
    return TwoFaState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isVerified: isVerified ?? this.isVerified,
      resendCooldown: resendCooldown ?? this.resendCooldown,
    );
  }
}
