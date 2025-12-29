import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/core/core_providers.dart';
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
  @override
  SecurityState build() => SecurityState.initial();

  @override
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

    final isLocked = isLocalLockEnabled && isPinConfigured;

    state = state.copyWith(
      hasLocalLock: isLocked,
      isPinConfigured: isPinConfigured,
      isBiometricEnabled: isBiometricEnabled,
      canUseBiometrics: canUseBiometrics,
      isSetupCompleted: true,
      initialized: true,
    );

    logger.i(
      '🔐 Security Init: Locked=$isLocked, PinConfigured=$isPinConfigured',
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

  @override
  Future<void> unlockApp() async {
    final logger = ref.read(appLoggerProvider);
    state = state.copyWith(hasLocalLock: false);
    logger.i('🔓 App Unlocked (hasLocalLock: false)');
  }

  @override
  Future<void> lockApp() async {
    if (state.isSetupCompleted && state.isPinConfigured) {
      state = state.copyWith(hasLocalLock: true);
      ref.read(appLoggerProvider).i('🔒 App Locked');
    }
  }
}
