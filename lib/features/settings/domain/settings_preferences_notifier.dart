import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';
import 'package:obywatel_plus/features/settings/domain/settings_preferences_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_preferences_notifier.g.dart';

@riverpod
class SettingsPreferencesNotifier extends _$SettingsPreferencesNotifier {
  static const _kAppLockTimeout = 'settings.app_lock_timeout';
  static const _kBiometricPrompt = 'settings.biometric_prompt';

  SharedPreferencesService get _prefs => ref.read(activePrefsProvider);

  @override
  SettingsPreferencesState build() {
    return SettingsPreferencesState(
      appLockTimeout: _readAppLockTimeout(),
      biometricPrompt: _prefs.readBool(_kBiometricPrompt) ?? true,
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
    } catch (error, _) {
      state = previous;
    }
  }

  Future<void> setAppLockTimeout(AppLockTimeout value) async {
    await _saveAndUpdate(
      persist: () => _prefs.write(_kAppLockTimeout, value.name),
      update: (old) => old.copyWith(appLockTimeout: value),
    );
  }

  Future<void> toggleBiometricPrompt(bool value) async {
    await _saveAndUpdate(
      persist: () => _prefs.writeBool(_kBiometricPrompt, value),
      update: (old) => old.copyWith(biometricPrompt: value),
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
}