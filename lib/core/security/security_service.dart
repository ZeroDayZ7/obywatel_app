import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

/// 🔑 Stan bezpieczeństwa aplikacji
@immutable
class SecurityState extends Equatable {
  final bool hasLocalLock;
  final bool isPinConfigured;
  final bool isBiometricEnabled;
  final bool canUseBiometrics;
  final bool isSetupCompleted;
  final bool isSetupInProgress;
  final bool initialized;

  const SecurityState({
    required this.hasLocalLock,
    required this.isPinConfigured,
    required this.isBiometricEnabled,
    required this.canUseBiometrics,
    required this.isSetupCompleted,
    required this.isSetupInProgress,
    required this.initialized,
  });

  factory SecurityState.initial() => const SecurityState(
    hasLocalLock: false,
    isPinConfigured: false,
    isBiometricEnabled: false,
    canUseBiometrics: false,
    isSetupCompleted: false,
    isSetupInProgress: false,
    initialized: false,
  );

  SecurityState copyWith({
    bool? hasLocalLock,
    bool? isPinConfigured,
    bool? isBiometricEnabled,
    bool? canUseBiometrics,
    bool? isSetupCompleted,
    bool? isSetupInProgress,
    bool? initialized,
  }) {
    return SecurityState(
      hasLocalLock: hasLocalLock ?? this.hasLocalLock,
      isPinConfigured: isPinConfigured ?? this.isPinConfigured,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      canUseBiometrics: canUseBiometrics ?? this.canUseBiometrics,
      isSetupCompleted: isSetupCompleted ?? this.isSetupCompleted,
      isSetupInProgress: isSetupInProgress ?? this.isSetupInProgress,
      initialized: initialized ?? this.initialized,
    );
  }

  // Backward compat: dla routera
  bool get skipSetup => isSetupCompleted;

  bool get shouldShowLock =>
      !isSetupInProgress && isPinConfigured && hasLocalLock;

  @override
  List<Object?> get props => [
    hasLocalLock,
    isPinConfigured,
    isBiometricEnabled,
    canUseBiometrics,
    isSetupCompleted,
    isSetupInProgress,
    initialized,
  ];
}

/// 🔐 Notifier bezpieczeństwa (globalny) – bez late final, read deps w metodach
class SecurityNotifier extends Notifier<SecurityState> {
  @override
  SecurityState build() {
    // Tylko initial state – bez inicjalizacji deps (to w metodach)
    return SecurityState.initial();
  }

  Future<void> init() async {
    final logger = ref.read(appLoggerProvider);
    final sharedPrefs = await ref.read(sharedPreferencesServiceProvider.future);
    final setupCompleted =
        sharedPrefs.readBool(StorageKeys.setupCompleted) ?? false;
    logger.d('🔐 SecurityNotifier.init() start');

    if (setupCompleted) {
      final pinService = ref.read(pinServiceProvider);
      final localAuth = ref.read(localAuthProvider);
      final isPinConfigured = await pinService.hasPin();
      final isLocalLockEnabled =
          sharedPrefs.readBool(StorageKeys.localLockEnabled) ?? false;
      final isBiometricEnabled =
          sharedPrefs.readBool(StorageKeys.isBiometricConfigured) ?? false;
      final canUseBiometrics = await _checkBiometricsAvailability(localAuth);

      state = state.copyWith(
        hasLocalLock:
            isLocalLockEnabled && (isPinConfigured || isBiometricEnabled),
        isPinConfigured: isPinConfigured,
        isBiometricEnabled: isBiometricEnabled,
        canUseBiometrics: canUseBiometrics,
        isSetupCompleted: true,
        initialized: true,
      );
      logger.d('🔐 Pełna inicjalizacja: setup zakończony.');
      return;
    }

    // Setup nieukończony: bez locka
    state = state.copyWith(
      isSetupCompleted: false,
      isSetupInProgress: true,
      initialized: true,
    );
    logger.d('🔐 Inicjalizacja w trybie setupu (bez locka).');
  }

  Future<bool> _checkBiometricsAvailability(
    LocalAuthentication localAuth,
  ) async {
    try {
      final available = await localAuth.getAvailableBiometrics();
      return available.isNotEmpty;
    } catch (e) {
      final logger = ref.read(appLoggerProvider);
      logger.e('Błąd sprawdzania biometrii', error: e);
      return false;
    }
  }

  Future<void> setPin(String pin) async {
    final logger = ref.read(appLoggerProvider);
    logger.d('Ustawianie PIN...');
    final pinService = ref.read(pinServiceProvider);
    await pinService.setPin(pin);
    final sharedPrefs = await ref.read(sharedPreferencesServiceProvider.future);
    await sharedPrefs.writeBool(StorageKeys.isPinConfigured, true);
    state = state.copyWith(isPinConfigured: true);
    logger.i('PIN skonfigurowany (czekaj na completeSetup).');
  }

  Future<void> completeSetup({bool enableBiometric = false}) async {
    final logger = ref.read(appLoggerProvider);
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
      isSetupInProgress: false,
    );
    logger.i('🔐 Setup zakończony i lock włączony.');
    // BEZ invalidate() – stan zaktualizowany, router zareaguje sam
  }

  Future<void> skipPinSetup() async {
    // Dodano async dla await
    final logger = ref.read(appLoggerProvider);
    final sharedPrefs = await ref.read(sharedPreferencesServiceProvider.future);
    await sharedPrefs.writeBool(StorageKeys.setupCompleted, true); // Bez locka

    state = state.copyWith(
      hasLocalLock: false, // Bez locka po skip
      isSetupCompleted: true,
      isSetupInProgress: false,
    );
    logger.w('Setup pominięty.');
    // BEZ invalidate()
  }

  Future<void> unlockApp() async {
    final logger = ref.read(appLoggerProvider);
    state = state.copyWith(hasLocalLock: false);
    logger.i('🔓 Odblokowano.');
  }

  Future<void> lockApp() async {
    final logger = ref.read(appLoggerProvider);
    if (state.skipSetup) {
      state = state.copyWith(hasLocalLock: true);
    }
    logger.i('🔒 Zablokowano.');
  }

  Future<bool> tryBiometricAuth() async {
    final logger = ref.read(appLoggerProvider);
    final localAuth = ref.read(localAuthProvider);
    if (!state.isBiometricEnabled || !state.canUseBiometrics) return false;
    try {
      final success = await localAuth.authenticate(
        localizedReason: 'Odblokuj aplikację',
        biometricOnly: true,
      );
      if (success) await unlockApp();
      logger.i('Biometria: success=$success');
      return success;
    } catch (e, st) {
      logger.e('Błąd biometrii', error: e, stackTrace: st);
      return false;
    }
  }
}
