import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security/security_state.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/auth/domain/auth_response.dart';

/// Interfejs dla celów Dependency Inversion (używany w StartupTask)
abstract interface class ISecurityService {
  Future<void> init();
  Future<void> lockApp();
  Future<void> unlockApp();
}

final securityServiceProvider =
    NotifierProvider<SecurityNotifier, SecurityState>(SecurityNotifier.new);

class SecurityNotifier extends Notifier<SecurityState>
    implements ISecurityService {
  AppLogger get _logger => ref.read(appLoggerProvider);

  @override
  SecurityState build() => SecurityState.initial();

  @override
  Future<void> init() async {
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

    final isLocked = isLocalLockEnabled && isPinConfigured;

    state = state.copyWith(
      hasLocalLock: isLocked,
      isPinConfigured: isPinConfigured,
      isBiometricEnabled: isBiometricEnabled,
      canUseBiometrics: canUseBiometrics,
      isSetupCompleted: true,
      initialized: true,
    );

    _logger.i('🔐 Security Init: Done');
    debugSecurityState();
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

  Future<void> completeSetup({
    bool enableBiometric = false,
    AuthResponse? auth,
  }) async {
    final sharedPrefs = await ref.read(sharedPreferencesServiceProvider.future);

    await sharedPrefs.writeBool(StorageKeys.setupCompleted, true);
    await sharedPrefs.writeBool(StorageKeys.localLockEnabled, true);
    await sharedPrefs.writeBool(
      StorageKeys.isBiometricConfigured,
      enableBiometric,
    );

    auth?.when(
      twoFaRequired: (_) {},
      success: (accessToken, refreshToken, userId) async {
        await ref
            .read(sessionServiceProvider)
            .saveSession(
              accessToken: accessToken,
              refreshToken: refreshToken,
              userId: userId,
            );
      },
    );

    state = state.copyWith(
      hasLocalLock: false,
      isPinConfigured: true,
      isBiometricEnabled: enableBiometric,
      isSetupCompleted: true,
    );

    debugSecurityState();
  }

  // W SecurityNotifier:
  Future<void> skipPinSetup() async {
    final sharedPrefs = await ref.read(sharedPreferencesServiceProvider.future);

    // Zapisujemy, że setup jest SKOŃCZONY (użytkownik podjął decyzję o pominięciu)
    await sharedPrefs.writeBool(StorageKeys.setupCompleted, true);
    // Zapisujemy, że blokada jest WYŁĄCZONA
    await sharedPrefs.writeBool(StorageKeys.localLockEnabled, false);

    state = state.copyWith(
      hasLocalLock: false,
      isSetupCompleted: true,
      isPinConfigured: false, // Ważne: upewniamy się, że stan wie o braku PINu
    );
  }

  @override
  Future<void> unlockApp() async {
    state = state.copyWith(hasLocalLock: false);
    _logger.i('🔓 App Unlocked'); // Używasz gettera
  }

  @override
  Future<void> lockApp() async {
    if (state.isSetupCompleted && state.isPinConfigured) {
      state = state.copyWith(hasLocalLock: true);
      _logger.i('🔒 App Locked');
    }
  }

  void debugSecurityState() {
    final s = state;
    _logger.d('''
--- SECURITY STATE ---
Initialized:    ${s.initialized}
Setup Done:     ${s.isSetupCompleted}
PIN Set:        ${s.isPinConfigured}
Local Lock:     ${s.hasLocalLock}
>>> SHOW LOCK:  ${s.shouldShowLock}
----------------------''', module: 'Security');
  }
}
