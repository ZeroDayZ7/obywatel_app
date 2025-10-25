import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

class SecurityService {
  final SecureStorageService secureStorage;
  final LocalAuthentication localAuth;
  final AppLogger logger;

  bool hasSession = false;
  bool hasLocalLock = false;
  bool isBiometricEnabled = false;
  bool isPinConfigured = false;
  bool isBiometricAvailable = false;
  bool canUseBiometrics = false;

  SecurityService({
    required this.secureStorage,
    required this.localAuth,
    required this.logger,
  });

  /// Inicjalizacja serwisu, sprawdzenie wszystkich ustawień
  Future<void> init() async {
    logger.i('Inicjalizacja SecurityService...');
    await _checkSession();
    await _checkLocalLockSettings();
    await _checkBiometricSettings();
    logger.i('SecurityService: init zakończone ✅');
  }

  /// Sprawdzenie, czy istnieje sesja (np. accessToken)
  Future<void> _checkSession() async {
    try {
      await secureStorage.delete(key: 'user_token');
      final token = await secureStorage.read(key: 'accessToken');
      hasSession = token != null && token.isNotEmpty;
      logger.i('Sprawdzono sesję: hasSession=$hasSession');
    } catch (e, st) {
      logger.e('Błąd podczas sprawdzania sesji', error: e, stackTrace: st);
      hasSession = false;
    }
  }

  /// Sprawdzenie lokalnych ustawień blokady i PIN-u
  Future<void> _checkLocalLockSettings() async {
    try {
      hasLocalLock = await _readBool('hasLocalLock');
      isPinConfigured = (await secureStorage.read(key: 'pinHash')) != null;
      logger.i(
        'Sprawdzono lokalne ustawienia: hasLocalLock=$hasLocalLock, isPinConfigured=$isPinConfigured',
      );
    } catch (e, st) {
      logger.e(
        'Błąd podczas sprawdzania lokalnych ustawień',
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
      logger.d('Odczytano bool z SecureStorage: $key=$result');
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
    final result =
        hasSession &&
        hasLocalLock &&
        (isPinConfigured || (isBiometricEnabled && canUseBiometrics));
    logger.d('shouldShowLock = $result');
    return result;
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
