import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/core/core_providers.dart';

import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security/security_state.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

final securityServiceProvider =
    NotifierProvider<SecurityNotifier, SecurityState>(SecurityNotifier.new);

class SecurityNotifier extends Notifier<SecurityState> {
  @override
  SecurityState build() => SecurityState.initial();

  Future<void> init() async {
    final logger = ref.read(appLoggerProvider);
    final sharedPrefs = await ref.read(sharedPreferencesServiceProvider.future);

    final setupCompleted =
        sharedPrefs.readBool(StorageKeys.setupCompleted) ?? false;

    if (!setupCompleted) {
      state = state.copyWith(isSetupCompleted: false, initialized: true);
      return;
    }

    final pinService = ref.read(pinServiceProvider);
    final localAuth = ref.read(localAuthProvider);

    final isPinConfigured = await pinService.hasPin();
    final isLocalLockEnabled =
        sharedPrefs.readBool(StorageKeys.localLockEnabled) ?? false;
    final isBiometricEnabled =
        sharedPrefs.readBool(StorageKeys.isBiometricConfigured) ?? false;
    final canUseBiometrics = await _checkBiometricsAvailability(localAuth);

    final shouldLock = isLocalLockEnabled && isPinConfigured;

    state = state.copyWith(
      hasLocalLock: shouldLock,
      isPinConfigured: isPinConfigured,
      isBiometricEnabled: isBiometricEnabled,
      canUseBiometrics: canUseBiometrics,
      isSetupCompleted: true,
      initialized: true,
    );

    logger.i(
      '🔐 Security Init: Locked=$shouldLock, PinConfigured=$isPinConfigured',
    );
  }

  Future<bool> _checkBiometricsAvailability(
    LocalAuthentication localAuth,
  ) async {
    try {
      final available = await localAuth.getAvailableBiometrics();
      return available.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> setPin(String pin) async {
    final pinService = ref.read(pinServiceProvider);
    await pinService.setPin(pin);

    final sharedPrefs = await ref.read(sharedPreferencesServiceProvider.future);
    await sharedPrefs.writeBool(StorageKeys.isPinConfigured, true);

    state = state.copyWith(isPinConfigured: true);
  }

  Future<void> completeSetup({bool enableBiometric = false}) async {
    final sharedPrefs = await ref.read(sharedPreferencesServiceProvider.future);
    await sharedPrefs.writeBool(StorageKeys.setupCompleted, true);
    await sharedPrefs.writeBool(StorageKeys.localLockEnabled, true);
    await sharedPrefs.writeBool(
      StorageKeys.isBiometricConfigured,
      enableBiometric,
    );

    state = state.copyWith(
      hasLocalLock: true,
      isBiometricEnabled: enableBiometric,
      isSetupCompleted: true,
    );
  }

  Future<void> skipPinSetup() async {
    final sharedPrefs = await ref.read(sharedPreferencesServiceProvider.future);
    await sharedPrefs.writeBool(StorageKeys.setupCompleted, true);

    state = state.copyWith(hasLocalLock: false, isSetupCompleted: true);
  }

  Future<void> unlockApp() async {
    final logger = ref.read(appLoggerProvider);
    state = state.copyWith(hasLocalLock: false);
    logger.i('🔓 App Unlocked (hasLocalLock: false)');
  }

  Future<void> lockApp() async {
    if (state.isSetupCompleted && state.isPinConfigured) {
      state = state.copyWith(hasLocalLock: true);
      ref.read(appLoggerProvider).i('🔒 App Locked');
    }
  }
}
