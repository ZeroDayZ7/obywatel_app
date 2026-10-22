import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/crypto/crypto_service.dart';
import 'package:obywatel_plus/core/crypto/hash_service.dart';
import 'package:obywatel_plus/core/crypto/kdf_service.dart';
import 'package:obywatel_plus/core/crypto/symmetric_crypto.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security/security_state.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/core/utils/validators.dart';

class _TestSecureStorage extends SecureStorageService {
  final Map<String, String> _values = {};

  _TestSecureStorage(AppLogger logger)
      : super(const FlutterSecureStorage(), logger);

  @override
  Future<void> write({required String key, required String value}) async {
    _values[key] = value;
  }

  @override
  Future<String?> read({required String key}) async => _values[key];

  @override
  Future<void> delete({required String key}) async {
    _values.remove(key);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SecuritySetupState', () {
    test('tracks the chosen local security method explicitly', () {
      final state = SecuritySetupState.initial().copyWith(
        localSecurityMethod: LocalSecurityMethod.pin,
        secretConfigured: true,
      );

      expect(state.localSecurityMethod, LocalSecurityMethod.pin);
      expect(state.isPinMethod, true);
      expect(state.secretConfigured, true);
    });

    test('requires a valid password for local secret selection', () {
      expect(Validators.validatePassword('Abc123!'), isNull);
      expect(Validators.validatePassword('1234'), isNotNull);
      expect(Validators.validatePassword('Abcdef!'), isNotNull);
    });

    test('password lock state remains active without falling back to PIN', () {
      final state = SecuritySetupState.initial().copyWith(
        localSecurityMethod: LocalSecurityMethod.password,
        secretConfigured: true,
      );

      expect(state.localSecurityMethod, LocalSecurityMethod.password);
      expect(state.isPasswordMethod, isTrue);
      expect(state.isPinMethod, isFalse);
    });

    test('security lock respects stored method and rejects invalid none state', () {
      final passwordState = SecurityState.initial().copyWith(
        hasLocalLock: true,
        isSetupCompleted: true,
        initialized: true,
        localSecurityMethod: LocalSecurityMethod.password,
      );
      expect(passwordState.shouldShowLock, isTrue);

      final invalidState = SecurityState.initial().copyWith(
        hasLocalLock: true,
        isSetupCompleted: true,
        initialized: true,
        localSecurityMethod: LocalSecurityMethod.none,
      );
      expect(invalidState.shouldShowLock, isFalse);
    });
  });

  group('PinService', () {
    test('verifyPin rejects a PIN when the stored local method is password', () async {
      final logger = AppLogger();
      final secureStorage = _TestSecureStorage(logger);
      final service = PinService(
        storage: secureStorage,
        hashService: HashService(logger),
        kdfService: KdfService(logger),
        crypto: SymmetricCrypto(logger),
        cryptoService: CryptoService(),
        deviceInfoService: DeviceInfoService(logger),
        logger: logger,
      );

      final passwordBytes = utf8.encode('123456');
      await service.setLocalSecret(
        method: LocalSecurityMethod.password,
        secretBytes: List<int>.from(passwordBytes),
      );

      expect(
        await service.verifyPin([1, 2, 3, 4, 5, 6]),
        isFalse,
      );
    });

    test('verifyLocalSecret enforces the stored local secret method', () async {
      final logger = AppLogger();
      final secureStorage = _TestSecureStorage(logger);
      final crypto = SymmetricCrypto(logger);
      final kdf = KdfService(logger);
      final service = PinService(
        storage: secureStorage,
        hashService: HashService(logger),
        kdfService: kdf,
        crypto: crypto,
        cryptoService: CryptoService(),
        deviceInfoService: DeviceInfoService(logger),
        logger: logger,
      );

      const secret = 'Abc123!';
      final originalSecret = utf8.encode(secret);
      final secretBytesForKey = List<int>.from(originalSecret);
      final salt = kdf.generateSalt();
      final key = await kdf.deriveKeyFromPin(
        pinBytes: secretBytesForKey,
        salt: salt,
      );
      final encryptedKey = await crypto.encryptBytes(
        clearBytes: [1, 2, 3, 4, 5],
        secretKey: key,
      );

      await secureStorage.write(
        key: StorageKeys.kekSalt,
        value: base64Encode(salt),
      );
      await secureStorage.write(
        key: StorageKeys.devicePrivateKey,
        value: encryptedKey,
      );

      await service.setLocalSecret(
        method: LocalSecurityMethod.password,
        secretBytes: List<int>.from(originalSecret),
      );

      expect(
        await service.verifyLocalSecret(
          method: LocalSecurityMethod.password,
          secretBytes: List<int>.from(originalSecret),
        ),
        isTrue,
      );

      expect(
        await service.verifyLocalSecret(
          method: LocalSecurityMethod.pin,
          secretBytes: [1, 2, 3, 4, 5, 6],
        ),
        isFalse,
      );
    });
  });
}
