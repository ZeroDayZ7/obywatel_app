import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/security/pin_service.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/settings/presentation/security_setup_screen.dart';

/// 🔑 Stan bezpieczeństwa aplikacji
@immutable
class SecurityState extends Equatable {
  final bool hasLocalLock;
  final bool isPinConfigured;
  final bool isBiometricEnabled;
  final bool canUseBiometrics;
  final bool skipSetup;
  final bool initialized;

  const SecurityState({
    required this.hasLocalLock,
    required this.isPinConfigured,
    required this.isBiometricEnabled,
    required this.canUseBiometrics,
    required this.skipSetup,
    required this.initialized,
  });

  /// 🏁 Fabryka stanu początkowego — wygodne domyślne wartości
  factory SecurityState.initial() => const SecurityState(
    hasLocalLock: false,
    isPinConfigured: false,
    isBiometricEnabled: false,
    canUseBiometrics: false,
    skipSetup: false,
    initialized: false,
  );

  /// 🔁 Kopia z modyfikacją wybranych pól
  SecurityState copyWith({
    bool? hasLocalLock,
    bool? isPinConfigured,
    bool? isBiometricEnabled,
    bool? canUseBiometrics,
    bool? skipSetup,
    bool? initialized,
  }) {
    return SecurityState(
      hasLocalLock: hasLocalLock ?? this.hasLocalLock,
      isPinConfigured: isPinConfigured ?? this.isPinConfigured,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      canUseBiometrics: canUseBiometrics ?? this.canUseBiometrics,
      skipSetup: skipSetup ?? this.skipSetup,
      initialized: initialized ?? this.initialized,
    );
  }

  /// 💡 Pomocniczy getter
  bool get shouldShowLock => !skipSetup && isPinConfigured && hasLocalLock;

  /// 📦 Equatable używa tej listy do automatycznego porównywania
  @override
  List<Object?> get props => [
    hasLocalLock,
    isPinConfigured,
    isBiometricEnabled,
    canUseBiometrics,
    skipSetup,
    initialized,
  ];
}

/// 🔐 Notifier bezpieczeństwa
class SecurityNotifier extends Notifier<SecurityState> {
  late final PinService pinService;
  late final SecureStorageService secureStorage;
  late final LocalAuthentication localAuth;
  late final AppLogger logger;

  @override
  SecurityState build() {
    // Inicjalizacja zależności od razu
    logger = ref.read(appLoggerProvider);
    secureStorage = ref.read(secureStorageProvider);
    pinService = ref.read(pinServiceProvider);
    localAuth = ref.read(localAuthProvider);

    return SecurityState.initial();
  }

  Future<void> init() async {
    final sharedPrefs = await ref.read(sharedPreferencesServiceProvider.future);
    final isLocalLockEnabled =
        sharedPrefs.readBool(StorageKeys.localLockEnabled) ?? false;

    if (isLocalLockEnabled) {
      // Jeśli ustawiono PIN — pomijamy biometrię
      state = state.copyWith(
        hasLocalLock: true,
        isPinConfigured: true,
        initialized: true,
      );
      logger.d('🔐 PIN aktywny – pomijam inicjalizację biometrii.');
      return;
    }

    // Jeśli nie ustawiono PIN-u, sprawdzamy pełne ustawienia
    final localLock = await _checkLocalLockSettings();
    final biometric = await _checkBiometricSettings();

    state = state.copyWith(
      hasLocalLock: localLock.hasLocalLock,
      isPinConfigured: localLock.isPinConfigured,
      isBiometricEnabled: biometric.isBiometricEnabled,
      canUseBiometrics: biometric.canUseBiometrics,
      initialized: true,
    );
  }

  Future<_LocalLockResult> _checkLocalLockSettings() async {
    try {
      // Get SharedPreferences instance
      final sharedPrefs = await ref.read(
        sharedPreferencesServiceProvider.future,
      );

      // Read flags directly as bool
      final isPinConfigured =
          sharedPrefs.readBool(StorageKeys.isPinConfigured) ?? false;
      final isBiometricConfigured =
          sharedPrefs.readBool(StorageKeys.isBiometricConfigured) ?? false;

      // Determine if any local lock is active
      final hasLocalLock = isPinConfigured || isBiometricConfigured;

      logger.i(
        'Checked local settings: hasLocalLock=$hasLocalLock, '
        'isPinConfigured=$isPinConfigured, isBiometricConfigured=$isBiometricConfigured',
      );

      return _LocalLockResult(hasLocalLock, isPinConfigured);
    } catch (e, st) {
      logger.e('Error checking local settings', error: e, stackTrace: st);
      return _LocalLockResult(false, false);
    }
  }

  Future<_BiometricResult> _checkBiometricSettings() async {
    try {
      final sharedPrefs = await ref.read(
        sharedPreferencesServiceProvider.future,
      );
      final isBiometricEnabled =
          sharedPrefs.readBool(StorageKeys.isBiometricConfigured) ?? false;
      final isBiometricAvailable = await localAuth.isDeviceSupported();
      final available = await localAuth.getAvailableBiometrics();
      final canUseBiometrics = available.isNotEmpty;

      logger.i(
        'Biometria: isBiometricEnabled=$isBiometricEnabled, '
        'isBiometricAvailable=$isBiometricAvailable, '
        'canUseBiometrics=$canUseBiometrics',
      );

      return _BiometricResult(
        isBiometricEnabled: isBiometricEnabled,
        canUseBiometrics: canUseBiometrics,
      );
    } catch (e, st) {
      logger.e('Błąd biometrii', error: e, stackTrace: st);
      return _BiometricResult(
        isBiometricEnabled: false,
        canUseBiometrics: false,
      );
    }
  }

  Future<void> setPin(String pin) async {
    logger.d('Ustawianie PIN...');
    await pinService.setPin(pin);

    final sharedPrefs = await ref.read(sharedPreferencesServiceProvider.future);
    await sharedPrefs.writeBool(StorageKeys.localLockEnabled, true);
    await sharedPrefs.writeBool(StorageKeys.isPinConfigured, true);
    state = state.copyWith(hasLocalLock: true, isPinConfigured: true);
  }

  Future<void> completeSetup() async {
    final sharedPrefs = await ref.read(sharedPreferencesServiceProvider.future);
    await sharedPrefs.write(StorageKeys.setupCompleted, 'true');
    state = state.copyWith(skipSetup: true);
    logger.i('Setup zakończony');
  }

  void skipPinSetup() {
    state = state.copyWith(skipSetup: true);
    logger.w('Użytkownik pominął konfigurację bezpieczeństwa');
  }

  Future<void> unlockApp() async {
    state = state.copyWith(hasLocalLock: false, skipSetup: true);
    logger.i('🔓 Aplikacja odblokowana');
  }

  Future<void> lockApp() async {
    state = state.copyWith(hasLocalLock: true);
    logger.i('🔒 Aplikacja zablokowana');
  }

  Future<bool> tryBiometricAuth() async {
    if (!state.isBiometricEnabled || !state.canUseBiometrics) return false;
    try {
      final canCheck = await localAuth.canCheckBiometrics;
      if (!canCheck) return false;

      final success = await localAuth.authenticate(
        localizedReason: 'Odblokuj aplikację za pomocą biometrii',
        biometricOnly: true,
      );
      logger.i('Autoryzacja biometryczna zakończona: success=$success');
      return success;
    } catch (e, st) {
      logger.e(
        'Błąd podczas autoryzacji biometrycznej',
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }
}

/// Wynik lokalnego PIN/lock
class _LocalLockResult {
  final bool hasLocalLock;
  final bool isPinConfigured;
  _LocalLockResult(this.hasLocalLock, this.isPinConfigured);
}

/// Wynik ustawień biometrii
class _BiometricResult {
  final bool isBiometricEnabled;
  final bool canUseBiometrics;
  _BiometricResult({
    required this.isBiometricEnabled,
    required this.canUseBiometrics,
  });
}
