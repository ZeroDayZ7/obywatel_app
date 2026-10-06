import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';
import 'package:obywatel_plus/features/settings/domain/settings_preferences_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_preferences_notifier.g.dart';

@riverpod
class SettingsPreferencesNotifier extends _$SettingsPreferencesNotifier {
  static const _kAppLockTimeout = 'settings.app_lock_timeout';
  static const _kPrivacyMode = 'settings.privacy_mode';
  static const _kDisplayMode = 'settings.display_mode';
  static const _kBiometricPrompt = 'settings.biometric_prompt';
  static const _kReducedMotion = 'settings.reduced_motion';
  static const _kDataSharingOptIn = 'settings.data_sharing_opt_in';

  SharedPreferencesService get _prefs => ref.read(activePrefsProvider);

  @override
  SettingsPreferencesState build() {
    return SettingsPreferencesState(
      appLockTimeout: _readAppLockTimeout(),
      privacyMode: _readPrivacyMode(),
      displayMode: _readDisplayMode(),
      biometricPrompt: _prefs.readBool(_kBiometricPrompt) ?? true,
      reducedMotion: _prefs.readBool(_kReducedMotion) ?? false,
      dataSharingOptIn: _prefs.readBool(_kDataSharingOptIn) ?? false,
    );
  }

  Future<void> _saveAndUpdate({
    required Future<void> Function() persist,
    required SettingsPreferencesState Function(SettingsPreferencesState old) update,
  }) async {
    final previous = state;
    state = update(state);

    try {
      await persist();
      // TODO: Replace with backend sync service once API contract is ready.
      // await ref.read(settingsSyncServiceProvider).syncPreferences(state);
    } catch (error, _) {
      state = previous;
      // The settings provider remains the local-first source of truth.
      // Report via the app logger when a global error handler is available.
      // ignore: state is rolled back and UI remains consistent.
    }
  }

  Future<void> setAppLockTimeout(AppLockTimeout value) async {
    await _saveAndUpdate(
      persist: () => _prefs.write(_kAppLockTimeout, value.name),
      update: (old) => old.copyWith(appLockTimeout: value),
    );
  }

  Future<void> setPrivacyMode(PrivacyMode value) async {
    await _saveAndUpdate(
      persist: () => _prefs.write(_kPrivacyMode, value.name),
      update: (old) => old.copyWith(privacyMode: value),
    );
  }

  Future<void> setDisplayMode(DisplayMode value) async {
    await _saveAndUpdate(
      persist: () => _prefs.write(_kDisplayMode, value.name),
      update: (old) => old.copyWith(displayMode: value),
    );
  }

  Future<void> toggleBiometricPrompt(bool value) async {
    await _saveAndUpdate(
      persist: () => _prefs.writeBool(_kBiometricPrompt, value),
      update: (old) => old.copyWith(biometricPrompt: value),
    );
  }

  Future<void> toggleReducedMotion(bool value) async {
    await _saveAndUpdate(
      persist: () => _prefs.writeBool(_kReducedMotion, value),
      update: (old) => old.copyWith(reducedMotion: value),
    );
  }

  Future<void> toggleDataSharingOptIn(bool value) async {
    await _saveAndUpdate(
      persist: () => _prefs.writeBool(_kDataSharingOptIn, value),
      update: (old) => old.copyWith(dataSharingOptIn: value),
    );
  }

  AppLockTimeout _readAppLockTimeout() {
    final raw = _prefs.read(_kAppLockTimeout);
    if (raw == null) return AppLockTimeout.minute1;

    return AppLockTimeout.values.firstWhere(
      (mode) => mode.name == raw,
      orElse: () => AppLockTimeout.minute1,
    );
  }

  PrivacyMode _readPrivacyMode() {
    final raw = _prefs.read(_kPrivacyMode);
    if (raw == null) return PrivacyMode.balanced;

    return PrivacyMode.values.firstWhere(
      (mode) => mode.name == raw,
      orElse: () => PrivacyMode.balanced,
    );
  }

  DisplayMode _readDisplayMode() {
    final raw = _prefs.read(_kDisplayMode);
    if (raw == null) return DisplayMode.adaptive;

    return DisplayMode.values.firstWhere(
      (mode) => mode.name == raw,
      orElse: () => DisplayMode.adaptive,
    );
  }
}
