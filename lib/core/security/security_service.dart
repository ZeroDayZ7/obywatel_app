import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/app/config/storage_keys.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/security/pin_service.dart';

class SecurityService {
  final PinService pinService;
  final SecureStorageService secureStorage;
  final LocalAuthentication localAuth;
  final AppLogger logger;

  bool hasSession = false;
  bool hasLocalLock = false;
  bool isBiometricEnabled = false;
  bool isPinConfigured = false;
  bool isBiometricAvailable = false;
  bool canUseBiometrics = false;
  bool skipSetup = false;
  bool initialized = false;

  SecurityService({
    required this.pinService,
    required this.secureStorage,
    required this.localAuth,
    required this.logger,
  });

  /// Inicjalizacja serwisu, sprawdzenie wszystkich ustawień
  Future<void> init() async {
    await Future.delayed(Duration.zero);
    logger.i('Inicjalizacja SecurityService...');

    await Future.wait([
      _checkSession(),
      _checkLocalLockSettings(),
      _checkBiometricSettings(),
    ]);
    initialized = true;

    logger.i('SecurityService: init zakończone ✅');
  }

  /// Sprawdzenie, czy istnieje sesja (np. accessToken)
  Future<void> _checkSession() async {
    try {
      final token = await secureStorage.read(key: StorageKeys.accessToken);
      hasSession = token != null && token.isNotEmpty;
      logger.i('Sprawdzono sesję: hasSession=$hasSession');
    } catch (e, st) {
      logger.e('Błąd podczas sprawdzania sesji', error: e, stackTrace: st);
      hasSession = false;
    }
  }

  /// Ustawienie PIN-u (hash + flaga lokalnej blokady)
  Future<void> setPin(String pin) async {
    logger.d('SecurityService: Ustawianie PIN przez PinService...');
    await pinService.setPin(pin);

    isPinConfigured = true;
    hasLocalLock = true;

    await secureStorage.write(key: StorageKeys.localLockEnabled, value: 'true');

    final storedHash = await secureStorage.read(key: StorageKeys.pinHash);
    logger.i('🔑 PIN zapisany jako hash: ${storedHash?.substring(0, 12)}...');
    logger.i('SecurityService: Blokada lokalna aktywowana ✅');
  }

  Future<void> completeSetup() async {
    logger.i('SecurityService: Setup zakończony');
    skipSetup = true;

    await secureStorage.write(key: StorageKeys.setupCompleted, value: 'true');
  }

  // setter po kliknięciu „Pomiń”
  void skipPinSetup() {
    skipSetup = true;
    logger.w('⚠️ Użytkownik pominął konfigurację bezpieczeństwa');
  }

  /// Sprawdzenie lokalnych ustawień blokady i PIN-u
  Future<void> _checkLocalLockSettings() async {
    try {
      hasLocalLock = await _readBool(StorageKeys.localLockEnabled);
      isPinConfigured = await pinService.hasPin();

      logger.i(
        '💡 Sprawdzono lokalne ustawienia: hasLocalLock=$hasLocalLock, isPinConfigured=$isPinConfigured',
      );
    } catch (e, st) {
      logger.e(
        'SecurityService: Błąd podczas sprawdzania lokalnych ustawień',
        error: e,
        stackTrace: st,
      );
      hasLocalLock = false;
      isPinConfigured = false;
    }
  }

  /// Sprawdzenie ustawień biometrii i dostępności na urządzeniu
  Future<void> _checkBiometricSettings() async {
    try {
      isBiometricEnabled = await _readBool('biometric');

      isBiometricAvailable = await localAuth.isDeviceSupported();
      final availableBiometrics = await localAuth.getAvailableBiometrics();
      canUseBiometrics = availableBiometrics.isNotEmpty;

      logger.i(
        'Biometria: isBiometricEnabled=$isBiometricEnabled, '
        'isBiometricAvailable=$isBiometricAvailable, '
        'canUseBiometrics=$canUseBiometrics',
      );
    } catch (e, st) {
      logger.e('Błąd biometrii', error: e, stackTrace: st);
      isBiometricAvailable = false;
      canUseBiometrics = false;
    }
  }

  /// Pomocnicza funkcja do odczytu bool z SecureStorage
  Future<bool> _readBool(String key) async {
    try {
      final value = await secureStorage.read(key: key);
      final result = value == 'true';
      // logger.d('Odczytano bool z SecureStorage: $key=$result');
      return result;
    } catch (e, st) {
      logger.e(
        'Błąd odczytu bool z SecureStorage: $key',
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  /// Czy należy pokazać ekran blokady (PIN / biometryczne)
  bool get shouldShowLock {
    if (skipSetup) return false;
    if (!isPinConfigured) return false;
    return hasLocalLock;
  }

  /// Próba autoryzacji biometrycznej
  Future<bool> tryBiometricAuth() async {
    if (!isBiometricEnabled || !canUseBiometrics) {
      logger.w(
        'Próba autoryzacji biometrycznej niemożliwa: warunki niespełnione',
      );
      return false;
    }

    try {
      final canCheck = await localAuth.canCheckBiometrics;
      if (!canCheck) {
        logger.w('Urządzenie nie pozwala na sprawdzenie biometrii');
        return false;
      }

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
