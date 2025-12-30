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
  // Clean Getters
  AppLogger get _logger => ref.read(appLoggerProvider);
  PinService get _pinService => ref.read(pinServiceProvider);
  LocalAuthentication get _localAuth => ref.read(localAuthProvider);
  Future<SharedPreferencesService> get _prefs =>
      ref.read(sharedPreferencesServiceProvider.future);

  @override
  SecurityState build() => SecurityState.initial();

  @override
  Future<void> init() async {
    // Musimy "rozpakować" Future z gettera na początku metody
    final prefs = await _prefs;

    final setupCompleted = prefs.readBool(StorageKeys.setupCompleted) ?? false;
    if (!setupCompleted) {
      state = state.copyWith(isSetupCompleted: false, initialized: true);
      return;
    }

    final isPinConfigured = await _pinService.hasPin();
    final isLocalLockEnabled =
        prefs.readBool(StorageKeys.localLockEnabled) ?? false;
    final isBiometricEnabled =
        prefs.readBool(StorageKeys.isBiometricConfigured) ?? false;

    // Używamy gettera _localAuth wewnątrz metody pomocniczej
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
    debugSecurityState();
  }

  Future<void> setPin(String pin) async {
    await _pinService.setPin(pin);
    final prefs = await _prefs;
    await prefs.writeBool(StorageKeys.isPinConfigured, true);

    state = state.copyWith(isPinConfigured: true);
  }

  Future<void> completeSetup({bool enableBiometric = false}) async {
    final prefs = await _prefs;

    await prefs.writeBool(StorageKeys.setupCompleted, true);
    await prefs.writeBool(StorageKeys.localLockEnabled, true);
    await prefs.writeBool(StorageKeys.isBiometricConfigured, enableBiometric);

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
    final prefs = await _prefs;

    await prefs.writeBool(StorageKeys.setupCompleted, true);
    await prefs.writeBool(StorageKeys.localLockEnabled, false);

    state = state.copyWith(
      hasLocalLock: false,
      isSetupCompleted: true,
      isPinConfigured: false,
    );
  }

  // Pomocnicza metoda używa teraz gettera klasy
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
