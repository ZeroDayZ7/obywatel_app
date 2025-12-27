import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/security/pin_service.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

@immutable
class SecurityState extends Equatable {
  final bool hasLocalLock; // Czy ekran blokady jest aktywny?
  final bool isPinConfigured; // Czy user ustawił PIN?
  final bool isBiometricEnabled; // Czy włączył biometrię w ustawieniach?
  final bool canUseBiometrics; // Czy urządzenie obsługuje biometrię?
  final bool isSetupCompleted; // Czy zakończył wizard powitalny?
  final bool initialized; // Czy serwis skończył się ładować?

  const SecurityState({
    required this.hasLocalLock,
    required this.isPinConfigured,
    required this.isBiometricEnabled,
    required this.canUseBiometrics,
    required this.isSetupCompleted,
    required this.initialized,
  });

  factory SecurityState.initial() => const SecurityState(
    hasLocalLock: true,
    isPinConfigured: false,
    isBiometricEnabled: false,
    canUseBiometrics: false,
    isSetupCompleted: false,
    initialized: false,
  );

  SecurityState copyWith({
    bool? hasLocalLock,
    bool? isPinConfigured,
    bool? isBiometricEnabled,
    bool? canUseBiometrics,
    bool? isSetupCompleted,
    bool? initialized,
  }) {
    return SecurityState(
      hasLocalLock: hasLocalLock ?? this.hasLocalLock,
      isPinConfigured: isPinConfigured ?? this.isPinConfigured,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      canUseBiometrics: canUseBiometrics ?? this.canUseBiometrics,
      isSetupCompleted: isSetupCompleted ?? this.isSetupCompleted,
      initialized: initialized ?? this.initialized,
    );
  }

  // Gettery pomocnicze dla Routera
  bool get shouldShowLock =>
      initialized && isSetupCompleted && isPinConfigured && hasLocalLock;

  @override
  List<Object?> get props => [
    hasLocalLock,
    isPinConfigured,
    isBiometricEnabled,
    canUseBiometrics,
    isSetupCompleted,
    initialized,
  ];
}

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

    // LOGIKA STARTOWA: Jeśli PIN jest skonfigurowany i lock włączony -> ZABLOKUJ
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
      hasLocalLock:
          true, // Po setupie od razu blokujemy, by user wpisał PIN na próbę
      isBiometricEnabled: enableBiometric,
      isSetupCompleted: true,
    );
  }

  Future<void> skipPinSetup() async {
    final sharedPrefs = await ref.read(sharedPreferencesServiceProvider.future);
    await sharedPrefs.writeBool(StorageKeys.setupCompleted, true);

    state = state.copyWith(hasLocalLock: false, isSetupCompleted: true);
  }

  /// ✅ Uproszczone odblokowanie
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
