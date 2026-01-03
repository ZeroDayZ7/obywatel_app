import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/local_auth_provider.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security/security_state.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'security_service_provider.g.dart';

abstract interface class ISecurityService {
  Future<void> init();
  Future<void> lockApp();
  Future<void> unlockApp();
  Future<void> unlockManually();
}

@Riverpod(keepAlive: true)
class SecurityService extends _$SecurityService implements ISecurityService {
  @override
  SecurityState build() => SecurityState.initial();

  SharedPreferencesService get _prefs => ref.read(activePrefsProvider);
  PinService get _pinService => ref.read(pinServiceProvider);
  LocalAuthentication get _localAuth => ref.read(localAuthProvider);
  AppLogger get _logger => ref.read(appLoggerProvider);

  @override
  Future<void> init() async {
    final setupCompleted = _prefs.readBool(StorageKeys.setupCompleted) ?? false;

    if (!setupCompleted) {
      state = state.copyWith(isSetupCompleted: false, initialized: true);
      return;
    }

    final isPinConfigured = await _pinService.hasPin();
    final isLocalLockEnabled =
        _prefs.readBool(StorageKeys.localLockEnabled) ?? false;
    final isBiometricEnabled =
        _prefs.readBool(StorageKeys.isBiometricConfigured) ?? false;
    final canUseBiometrics = await _checkBiometricsAvailability();

    state = state.copyWith(
      hasLocalLock: isLocalLockEnabled && isPinConfigured,
      isPinConfigured: isPinConfigured,
      isBiometricEnabled: isBiometricEnabled,
      canUseBiometrics: canUseBiometrics,
      isSetupCompleted: true,
      initialized: true,
    );

    _logger.i('🔐 Security Init: Done');
  }

  Future<void> setPin(List<int> pinCodes) async {
    await _pinService.setPin(pinCodes);
    await _prefs.writeBool(StorageKeys.isPinConfigured, true);

    state = state.copyWith(isPinConfigured: true);

    for (int i = 0; i < pinCodes.length; i++) {
      pinCodes[i] = 0;
    }
  }

  Future<void> completeSetup({bool enableBiometric = false}) async {
    await Future.wait([
      _prefs.writeBool(StorageKeys.setupCompleted, true),
      _prefs.writeBool(StorageKeys.localLockEnabled, true),
      _prefs.writeBool(StorageKeys.isBiometricConfigured, enableBiometric),
    ]);

    state = state.copyWith(
      hasLocalLock: false,
      isPinConfigured: true,
      isBiometricEnabled: enableBiometric,
      isSetupCompleted: true,
    );

    _logger.i('✅ Security Setup Completed');
    debugSecurityState();
  }

  Future<void> skipPinSetup() async {
    await Future.wait([
      _prefs.writeBool(StorageKeys.setupCompleted, true),
      _prefs.writeBool(StorageKeys.localLockEnabled, false),
    ]);

    state = state.copyWith(
      hasLocalLock: false,
      isSetupCompleted: true,
      isPinConfigured: false,
    );
  }

  Future<bool> _checkBiometricsAvailability() async {
    try {
      final available = await _localAuth.getAvailableBiometrics();
      return available.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> toggleBiometrics(bool enabled) async {
    try {
      await _prefs.writeBool(StorageKeys.isBiometricConfigured, enabled);
      state = state.copyWith(isBiometricEnabled: enabled);
      _logger.i('Biometrics toggled: $enabled');
    } catch (e, s) {
      _logger.e('Failed to toggle biometrics', error: e, stackTrace: s);
    }
  }

  @override
  Future<void> unlockApp() async {
    state = state.copyWith(hasLocalLock: false);
    _logger.i('🔓 App Unlocked');
  }

  @override
  Future<void> lockApp() async {
    if (state.isSetupCompleted && state.isPinConfigured) {
      state = state.copyWith(hasLocalLock: true);
      _logger.i('🔒 App Locked');
    }
  }

  @override
  Future<void> unlockManually() async {
    bool isPinConfigured = false;
    try {
      isPinConfigured = await _pinService.hasPin();
    } catch (e) {
      _logger.e('Failed to check PIN status', error: e);
    }

    state = state.copyWith(
      hasLocalLock: false,
      initialized: true,
      isPinConfigured: isPinConfigured,
      isSetupCompleted: isPinConfigured,
    );
    _logger.i('🔐 Security: Manual unlock. PIN configured: $isPinConfigured');
  }

  void debugSecurityState() {
    _logger.d('''
--- SECURITY STATE ---
Initialized:    ${state.initialized}
Setup Done:     ${state.isSetupCompleted}
PIN Set:        ${state.isPinConfigured}
Local Lock:     ${state.hasLocalLock}
>>> SHOW LOCK:  ${state.shouldShowLock}
----------------------''', module: 'Security');
  }
}
