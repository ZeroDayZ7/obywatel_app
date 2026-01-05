import 'package:flutter/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/device_integrity/device_integrity_facade.dart';
import 'package:obywatel_plus/core/security/local_auth_provider.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security/security_state.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_application/secure_application_controller.dart';

part 'security_service_provider.g.dart';

abstract interface class ISecurityService {
  Future<void> init();
  Future<void> lockApp();
  Future<void> unlockApp();
  Future<void> unlockManually();
}

@Riverpod(keepAlive: true)
class SecurityService extends _$SecurityService
    with WidgetsBindingObserver
    implements ISecurityService {
  SecureApplicationController? _secureController;
  Future<void>? _initFuture;

  @override
  SecurityState build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_secureController == null) return;

    Future.microtask(() {
      switch (state) {
        case AppLifecycleState.resumed:
          _logger.d('App resumed', module: 'Security');
          _checkIntegrityOnResume();
          _disablePrivacyShield();
          break;

        case AppLifecycleState.inactive:
        case AppLifecycleState.paused:
          _logger.d('App hidden/minimized', module: 'Security');
          _enablePrivacyShield();
          // Clipboard.setData(const ClipboardData(text: ''));
          break;
        default:
          break;
      }
    });
  }

  Future<void> _checkIntegrityOnResume() async {
    final isAllowed = await ref
        .read(deviceIntegrityFacadeProvider)
        .isDeviceAllowed();

    if (!isAllowed) {
      _logger.e(
        '🛑 Security violation detected on resume!',
        module: 'Security',
      );

      // Natychmiastowa reakcja: blokujemy stan aplikacji
      state = state.copyWith(
        hasLocalLock: true,
        initialized:
            false, // Oznaczenie jako nieukonczone wymusi re-inicjalizację lub blokadę UI
      );

      // Tutaj możesz dodać ref.read(authControllerProvider.notifier).logout();
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
      bool isPinConfigured,
      bool setupCompleted,
      bool isLocalLockEnabled,
      bool isBiometricEnabled,
    ] = await Future.wait([
      _pinService.hasPin(),
      _readBool(StorageKeys.setupCompleted),
      _readBool(StorageKeys.localLockEnabled),
      _readBool(StorageKeys.isBiometricConfigured),
    ]);

    // Poprawione wywołanie (dodane nawiasy)
    if (!isBiometricEnabled) {
      await _checkBiometricsAvailability();
    }

    if (!setupCompleted) {
      state = state.copyWith(isSetupCompleted: false, initialized: true);
      return;
    }

    state = state.copyWith(
      hasLocalLock: isLocalLockEnabled && isPinConfigured,
      isPinConfigured: isPinConfigured,
      isBiometricEnabled: isBiometricEnabled,
      canUseBiometrics: isBiometricEnabled,
      isSetupCompleted: setupCompleted,
      initialized: true,
    );

    debugSecurityState();
    _logger.i('🔐 Security Init: Done');
  }

  Future<bool> _readBool(String key) async {
    try {
      final value = await _secureStorage.read(key: key);
      final boolResult = value == 'true';

      // Logujemy odczyt (pomocne przy sprawdzaniu init aplikacji)
      _logger.d(
        'Read security flag: $key = $boolResult',
        module: 'SecurityService',
      );

      return boolResult;
    } catch (e) {
      _logger.e(
        'Error reading security flag: $key',
        error: e,
        module: 'SecurityService',
      );
      return false;
    }
  }

  Future<void> _writeBool(String key, bool value) async {
    try {
      await _secureStorage.write(key: key, value: value.toString());

      // Logujemy zapis (potwierdzenie, że flaga została utrwalona)
      _logger.i(
        'Saved security flag: $key = $value',
        module: 'SecurityService',
      );
    } catch (e) {
      _logger.e(
        'Error saving security flag: $key',
        error: e,
        module: 'SecurityService',
      );
    }
  }

  Future<void> setPin(List<int> pinCodes) async {
    await _pinService.setPin(pinCodes);
    state = state.copyWith(isPinConfigured: true);
    for (int i = 0; i < pinCodes.length; i++) {
      pinCodes[i] = 0;
    }
  }

  Future<void> completeSetup({bool enableBiometric = false}) async {
    await _writeBool(StorageKeys.setupCompleted, true);
    await _writeBool(StorageKeys.localLockEnabled, true);
    await _writeBool(StorageKeys.isPinConfigured, true);
    await _writeBool(StorageKeys.isBiometricConfigured, enableBiometric);

    state = state.copyWith(
      hasLocalLock: false,
      isPinConfigured: true,
      isBiometricEnabled: enableBiometric,
      isSetupCompleted: true,
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

  Future<void> toggleBiometrics(bool enabled) async {
    try {
      state = state.copyWith(isBiometricEnabled: enabled);
      _logger.i('Biometrics toggled: $enabled');
    } catch (e, s) {
      _logger.e('Failed to toggle biometrics', error: e, stackTrace: s);
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

  @override
  Future<void> unlockManually() async {
    bool isPinConfigured = false;
    try {
      isPinConfigured = await _pinService.hasPin();
    } catch (e) {
      _logger.e('Failed to check PIN status', error: e);
    }

    state = state.copyWith(
      hasLocalLock: false,
      initialized: true,
      isPinConfigured: isPinConfigured,
      isSetupCompleted: isPinConfigured,
    );
    _logger.i('🔐 Security: Manual unlock. PIN configured: $isPinConfigured');
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
