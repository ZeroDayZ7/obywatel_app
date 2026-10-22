// lib\core\security\security\security_service_provider.dart
import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/device_integrity/device_integrity_facade.dart';
import 'package:obywatel_plus/core/security/local_auth_provider.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security/security_state.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_application/secure_application_controller.dart';

part 'security_service_provider.g.dart';

abstract interface class ISecurityService {
  Future<void> init();
  Future<void> lockApp();
  Future<void> unlockApp();
  Future<void> unlockManually();
  Future<void> markSecurityAsInitialized();
}

@Riverpod(keepAlive: true)
class SecurityService extends _$SecurityService implements ISecurityService {
  SecureApplicationController? _secureController;
  Future<void>? _initFuture;

  @override
  SecurityState build() {
    return SecurityState.initial();
  }

  void registerSecureController(SecureApplicationController? controller) {
    _secureController = controller;
    _secureController?.secure();
    _logger.d('SecureApplicationController registered', module: 'Security');
  }

  void _enablePrivacyShield() {
    _logger.d('Locking SecureGate', module: 'Security');
    _secureController?.lock();
  }

  void _disablePrivacyShield() {
    _logger.d('Opening SecureGate', module: 'Security');
    _secureController?.unlock();
  }

  Future<void> _checkIntegrityOnResume() async {
    final isAllowed = await ref
        .read(deviceIntegrityFacadeProvider)
        .isDeviceAllowed();

    if (!isAllowed) {
      _logger.e(
        '🛑 Security violation detected on resume! Executing force security wipe.',
        module: 'Security',
      );

      // 1. Natychmiastowe zablokowanie UI (ekran zostaje zakryty/zablokowany)
      state = state.copyWith(hasLocalLock: true, initialized: false);

      // 2. Czyszczenie pod spodem
      try {
        await ref.read(authControllerProvider.notifier).forceSecurityWipe();
      } catch (e, stack) {
        _logger.e(
          'Błąd krytyczny podczas forceSecurityWipe na resume',
          error: e,
          stackTrace: stack,
          module: 'Security',
        );
        ref.read(authControllerProvider.notifier).setUnauthenticated();
      }
    }
  }

  // --- Gettery ---
  SecureStorageService get _secureStorage => ref.read(secureStorageProvider);
  PinService get _pinService => ref.read(pinServiceProvider);
  LocalAuthentication get _localAuth => ref.read(localAuthProvider);
  AppLogger get _logger => ref.read(appLoggerProvider);

  @override
  Future<void> init() async {
    // Jeśli proces już trwa lub został zakończony, zwróć istniejący Future
    if (_initFuture != null) {
      return _initFuture;
    }

    // W przeciwnym razie przypisz i uruchom proces inicjalizacji
    _initFuture = _internalInit();
    return _initFuture;
  }

  // 3. Prywatna metoda z całą Twoją logiką
  Future<void> _internalInit() async {
    // Podwójne sprawdzenie, czy stan nie jest już gotowy
    if (state.initialized) return;

    final [
      bool setupCompleted,
      bool isLocalLockEnabled,
      bool isBiometricEnabled,
    ] = await Future.wait([
      _secureStorage.readBool(key: StorageKeys.setupCompleted),
      _secureStorage.readBool(key: StorageKeys.localLockEnabled),
      _secureStorage.readBool(key: StorageKeys.isBiometricConfigured),
    ]);

    final storedMethod = await _pinService.readStoredLocalSecurityMethod();

    if (!isBiometricEnabled) {
      await _checkBiometricsAvailability();
    }

    final isMethodConfigured = storedMethod != LocalSecurityMethod.none;

    if (!setupCompleted || !isMethodConfigured) {
      state = state.copyWith(
        hasLocalLock: false,
        isPinConfigured: false,
        isBiometricEnabled: isBiometricEnabled,
        canUseBiometrics: isBiometricEnabled,
        isSetupCompleted: setupCompleted && isMethodConfigured,
        initialized: true,
        localSecurityMethod: storedMethod,
      );
      debugSecurityState();
      return;
    }

    state = state.copyWith(
      hasLocalLock: isLocalLockEnabled,
      isPinConfigured: storedMethod == LocalSecurityMethod.pin,
      isBiometricEnabled: isBiometricEnabled,
      canUseBiometrics: isBiometricEnabled,
      isSetupCompleted: true,
      initialized: true,
      localSecurityMethod: storedMethod,
    );

    debugSecurityState();
    _logger.i('🔐 Security Init: Done');
  }

  /// Oznacza stan bezpieczeństwa jako w pełni zainicjalizowany i gotowy po pomyślnej weryfikacji
  @override
  Future<void> markSecurityAsInitialized() async {
    final storedMethod = await _pinService.readStoredLocalSecurityMethod();
    final isBiometricEnabled = await _secureStorage.readBool(
      key: StorageKeys.isBiometricConfigured,
    );
    final isMethodConfigured = storedMethod != LocalSecurityMethod.none;

    state = state.copyWith(
      initialized: true,
      isSetupCompleted: isMethodConfigured,
      isPinConfigured: storedMethod == LocalSecurityMethod.pin,
      isBiometricEnabled: isBiometricEnabled,
      hasLocalLock: false,
      localSecurityMethod: storedMethod,
    );

    _logger.i('✅ Security state marked as initialized and unlocked');
    debugSecurityState();
  }

  Future<void> setPin(List<int> pinCodes) async {
    await _pinService.setPin(pinCodes);
    state = state.copyWith(isPinConfigured: true);
    for (int i = 0; i < pinCodes.length; i++) {
      pinCodes[i] = 0;
    }
  }

  Future<void> completeSetup({bool enableBiometric = false}) async {
    final storedMethod = await _pinService.readStoredLocalSecurityMethod();
    await _secureStorage.writeBool(
      key: StorageKeys.setupCompleted,
      value: true,
    );
    await _secureStorage.writeBool(
      key: StorageKeys.localLockEnabled,
      value: true,
    );
    await _secureStorage.writeBool(
      key: StorageKeys.isPinConfigured,
      value: storedMethod == LocalSecurityMethod.pin,
    );
    await _secureStorage.writeBool(
      key: StorageKeys.isBiometricConfigured,
      value: enableBiometric,
    );

    state = state.copyWith(
      hasLocalLock: false,
      isPinConfigured: storedMethod == LocalSecurityMethod.pin,
      isBiometricEnabled: enableBiometric,
      isSetupCompleted: storedMethod != LocalSecurityMethod.none,
      localSecurityMethod: storedMethod,
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

  Future<bool> toggleBiometrics(bool enabled) async {
    try {
      if (enabled) {
        // 1. Sprawdzenie dostępności sprzętowej
        final canCheck = await _localAuth.canCheckBiometrics;
        final isSupported = await _localAuth.isDeviceSupported();
        final availableBiometrics = await _localAuth.getAvailableBiometrics();

        if (!canCheck || !isSupported || availableBiometrics.isEmpty) {
          _logger.w(
            'Biometrics requested but hardware not available',
            module: 'Security',
          );
          return false;
        }

        // 2. Weryfikacja biometryczna bezpośrednio z parametrami API local_auth
        final authenticated = await _localAuth.authenticate(
          localizedReason:
              'Weryfikacja biometryczna wymagana do włączenia funkcji',
          biometricOnly: true,
          persistAcrossBackgrounding: true,
        );

        if (!authenticated) {
          _logger.w(
            'Biometric authentication failed during setup',
            module: 'Security',
          );
          return false;
        }

        // 3. Zapis stanu po pomyślnej weryfikacji
        await _secureStorage.writeBool(
          key: StorageKeys.isBiometricConfigured,
          value: true,
        );

        state = state.copyWith(
          isBiometricEnabled: true,
          canUseBiometrics: true,
        );
        _logger.i(
          '✅ Biometrics enabled and saved to SecureStorage',
          module: 'Security',
        );
        return true;
      } else {
        // 4. Wyłączenie biometrii i wyczyszczenie z SecureStorage
        await _secureStorage.delete(key: StorageKeys.isBiometricConfigured);

        state = state.copyWith(
          isBiometricEnabled: false,
          canUseBiometrics: true,
        );
        _logger.i(
          '🚫 Biometrics disabled and cleared from SecureStorage',
          module: 'Security',
        );
        return true;
      }
    } catch (e, s) {
      _logger.e(
        'Failed to toggle biometrics',
        error: e,
        stackTrace: s,
        module: 'Security',
      );
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
    if (state.isSetupCompleted && state.localSecurityMethod != LocalSecurityMethod.none) {
      state = state.copyWith(hasLocalLock: true);
      _logger.i('🔒 App Locked');
    }
  }

  @override
  Future<void> unlockManually() async {
    LocalSecurityMethod storedMethod = LocalSecurityMethod.none;
    try {
      storedMethod = await _pinService.readStoredLocalSecurityMethod();
    } catch (e) {
      _logger.e('Failed to read local security method', error: e);
    }

    final isMethodConfigured = storedMethod != LocalSecurityMethod.none;
    state = state.copyWith(
      hasLocalLock: false,
      initialized: true,
      isPinConfigured: storedMethod == LocalSecurityMethod.pin,
      isSetupCompleted: isMethodConfigured,
      localSecurityMethod: storedMethod,
    );
    _logger.i(
      '🔐 Security: Manual unlock. Local method: $storedMethod, configured: $isMethodConfigured',
    );
  }

  Future<void> onAppResumed() async {
    if (_secureController == null) return;

    _logger.d('App resumed', module: 'Security');

    await _checkIntegrityOnResume();

    _disablePrivacyShield();
  }

  /// Finalizuje konfigurację dla sesji tymczasowej (bez rejestracji urządzenia i bez PIN-u)
  Future<void> completeTemporarySetup() async {
    await _secureStorage.writeBool(
      key: StorageKeys.setupCompleted,
      value: true,
    );
    await _secureStorage.writeBool(
      key: StorageKeys.localLockEnabled,
      value: false,
    );
    await _secureStorage.writeBool(
      key: StorageKeys.isPinConfigured,
      value: false,
    );
    await _secureStorage.write(
      key: StorageKeys.localSecurityMethod,
      value: LocalSecurityMethod.none.name,
    );

    state = state.copyWith(
      hasLocalLock: false,
      isPinConfigured: false,
      isBiometricEnabled: false,
      isSetupCompleted: true,
      localSecurityMethod: LocalSecurityMethod.none,
    );

    _logger.i('✅ Temporary Security Setup Completed (No local secret)');
    debugSecurityState();
  }

  void onAppHidden() {
    if (_secureController == null) return;
    _logger.d('App hidden/minimized', module: 'Security');
    _enablePrivacyShield();
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
