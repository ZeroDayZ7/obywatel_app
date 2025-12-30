import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/local_auth_provider.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security/security_state.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

abstract interface class ISecurityService {
  Future<void> init();
  Future<void> lockApp();
  Future<void> unlockApp();
}

final securityServiceProvider =
    NotifierProvider<SecurityNotifier, SecurityState>(SecurityNotifier.new);

class SecurityNotifier extends Notifier<SecurityState>
    implements ISecurityService {
  // Clean Getters - teraz synchroniczne
  AppLogger get _logger => ref.read(appLoggerProvider);
  PinService get _pinService => ref.read(pinServiceProvider);
  LocalAuthentication get _localAuth => ref.read(localAuthProvider);

  // POPRAWKA: Pobieramy gotowy serwis synchronicznie
  SharedPreferencesService get _prefs => ref.read(activePrefsProvider);

  @override
  SecurityState build() => SecurityState.initial();

  @override
  Future<void> init() async {
    // Odczyt z SharedPreferencesService jest teraz synchroniczny
    final setupCompleted = _prefs.readBool(StorageKeys.setupCompleted) ?? false;

    if (!setupCompleted) {
      state = state.copyWith(isSetupCompleted: false, initialized: true);
      return;
    }

    // PIN Service zazwyczaj operuje na SecureStorage, więc tu zostaje await
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

  Future<void> setPin(String pin) async {
    await _pinService.setPin(pin);
    // Zapisujemy na dysk, ale dostęp do _prefs jest natychmiastowy
    await _prefs.writeBool(StorageKeys.isPinConfigured, true);

    state = state.copyWith(isPinConfigured: true);
  }

  Future<void> completeSetup({bool enableBiometric = false}) async {
    // Wykonujemy serie zapisów asynchronicznych
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
