import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/security/pin_service.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/settings/presentation/security_setup_screen.dart';

/// 🔑 Stan bezpieczeństwa aplikacji
class SecurityState {
  final bool hasLocalLock;
  final bool isPinConfigured;
  final bool isBiometricEnabled;
  final bool canUseBiometrics;
  final bool skipSetup;
  final bool initialized;

  SecurityState({
    required this.hasLocalLock,
    required this.isPinConfigured,
    required this.isBiometricEnabled,
    required this.canUseBiometrics,
    required this.skipSetup,
    required this.initialized,
  });

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

  bool get shouldShowLock => !skipSetup && isPinConfigured && hasLocalLock;
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

    // Zwrócenie początkowego stanu
    return SecurityState(
      hasLocalLock: false,
      isPinConfigured: false,
      isBiometricEnabled: false,
      canUseBiometrics: false,
      skipSetup: false,
      initialized: false,
    );
  }

  Future<void> init() async {
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
      final hasLocalLock = await _readBool(StorageKeys.localLockEnabled);
      final isPinConfigured = await pinService.hasPin();
      logger.i(
        'Sprawdzono lokalne ustawienia: hasLocalLock=$hasLocalLock, '
        'isPinConfigured=$isPinConfigured',
      );
      return _LocalLockResult(hasLocalLock, isPinConfigured);
    } catch (e, st) {
      logger.e(
        'Błąd podczas sprawdzania lokalnych ustawień',
        error: e,
        stackTrace: st,
      );
      return _LocalLockResult(false, false);
    }
  }

  Future<_BiometricResult> _checkBiometricSettings() async {
    try {
      final isBiometricEnabled = await _readBool(StorageKeys.biometric);
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

  Future<bool> _readBool(String key) async {
    try {
      final value = await secureStorage.read(key: key);
      return value == 'true';
    } catch (e, st) {
      logger.e(
        'Błąd odczytu bool z SecureStorage: $key',
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  Future<void> setPin(String pin) async {
    logger.d('Ustawianie PIN...');
    await pinService.setPin(pin);
    await secureStorage.write(key: StorageKeys.localLockEnabled, value: 'true');

    state = state.copyWith(hasLocalLock: true, isPinConfigured: true);
  }

  Future<void> completeSetup() async {
    await secureStorage.write(key: StorageKeys.setupCompleted, value: 'true');
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
