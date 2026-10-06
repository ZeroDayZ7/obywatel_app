import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_preferences_state.freezed.dart';
part 'settings_preferences_state.g.dart';

enum AppLockTimeout {
  immediate,
  seconds30,
  minute1,
  fiveMinutes,
}

enum PrivacyMode {
  standard,
  balanced,
  strict,
}

enum DisplayMode {
  adaptive,
  compact,
  highContrast,
}

@freezed
sealed class SettingsPreferencesState with _$SettingsPreferencesState {
  const factory SettingsPreferencesState({
    @Default(AppLockTimeout.minute1) AppLockTimeout appLockTimeout,
    @Default(PrivacyMode.balanced) PrivacyMode privacyMode,
    @Default(false) bool biometricPrompt,
    @Default(false) bool compactMode,
    @Default(false) bool reducedMotion,
    @Default(false) bool dataSharingOptIn,
    @Default(false) bool highContrast,
  }) = _SettingsPreferencesState;

  factory SettingsPreferencesState.fromJson(Map<String, dynamic> json) =>
      _$SettingsPreferencesStateFromJson(json);
}
