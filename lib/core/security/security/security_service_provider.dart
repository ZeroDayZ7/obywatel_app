import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/local_auth_provider.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security/security_state.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
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

  // SharedPreferencesService get _prefs => ref.read(activePrefsProvider);
  SecureStorageService get _secureStorage => ref.read(secureStorageProvider);
  PinService get _pinService => ref.read(pinServiceProvider);
  LocalAuthentication get _localAuth => ref.read(localAuthProvider);
  AppLogger get _logger => ref.read(appLoggerProvider);

  @override
  Future<void> init() async {
    final setupCompleted = await _readBool(StorageKeys.setupCompleted);

    if (!setupCompleted) {
      state = state.copyWith(isSetupCompleted: false, initialized: true);
      return;
    }

    final [
      bool isPinConfigured,
      bool isLocalLockEnabled,
      bool isBiometricEnabled,
      bool canUseBiometrics,
    ] = await Future.wait([
      _pinService.hasPin(),
      _readBool(StorageKeys.localLockEnabled),
      _readBool(StorageKeys.isBiometricConfigured),
      _checkBiometricsAvailability(),
    ]);

    state = state.copyWith(
      hasLocalLock: isLocalLockEnabled && isPinConfigured,
      isPinConfigured: isPinConfigured,
      isBiometricEnabled: isBiometricEnabled,
      canUseBiometrics: canUseBiometrics,
      isSetupCompleted: true,
      initialized: true,
    );

    debugSecurityState();
    _logger.i('🔐 Security Init: Done');
  }

  Future<bool> _readBool(String key) async {
    try {
      final value = await _secureStorage.read(key: key);
      final boolResult = value == 'true';

      // Logujemy odczyt (pomocne przy sprawdzaniu init aplikacji)
      _logger.d(
        'Read security flag: $key = $boolResult',
        module: 'SecurityService',
      );

      return boolResult;
    } catch (e) {
      _logger.e(
        'Error reading security flag: $key',
        error: e,
        module: 'SecurityService',
      );
      return false;
    }
  }

  Future<void> _writeBool(String key, bool value) async {
    try {
      await _secureStorage.write(key: key, value: value.toString());

      // Logujemy zapis (potwierdzenie, że flaga została utrwalona)
      _logger.i(
        'Saved security flag: $key = $value',
        module: 'SecurityService',
      );
    } catch (e) {
      _logger.e(
        'Error saving security flag: $key',
        error: e,
        module: 'SecurityService',
      );
    }
  }

  Future<void> setPin(List<int> pinCodes) async {
    await _pinService.setPin(pinCodes);
    state = state.copyWith(isPinConfigured: true);
    for (int i = 0; i < pinCodes.length; i++) {
      pinCodes[i] = 0;
    }
  }

  Future<void> completeSetup({bool enableBiometric = false}) async {
    await _writeBool(StorageKeys.setupCompleted, true);
    await _writeBool(StorageKeys.localLockEnabled, true);
    await _writeBool(StorageKeys.isPinConfigured, true);
    await _writeBool(StorageKeys.isBiometricConfigured, enableBiometric);

    state = state.copyWith(
      hasLocalLock: false,
      isPinConfigured: true,
      isBiometricEnabled: enableBiometric,
      isSetupCompleted: true,
    );

    _logger.i('✅ Security Setup Completed');
    debugSecurityState();
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
