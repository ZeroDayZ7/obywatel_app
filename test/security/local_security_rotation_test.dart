import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/crypto/crypto_service.dart';
import 'package:obywatel_plus/core/crypto/kdf_service.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  FlutterSecureStorage.setMockInitialValues({});

  test(
    'rotates active local pin secret without losing the wrapped private key',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final pinService = container.read(pinServiceProvider);
      final crypto = container.read(cryptoServiceProvider.notifier);
      final storage = container.read(secureStorageProvider);

      await storage.clearAll();
      const oldPin = [1, 2, 3, 4];
      const newPin = [9, 8, 7, 6];

      final salt = container.read(kdfServiceProvider).generateSalt();
      await pinService.setLocalSecret(
        method: LocalSecurityMethod.pin,
        secretBytes: oldPin,
      );
      await storage.write(key: StorageKeys.kekSalt, value: base64Encode(salt));
      await crypto.generateAndHoldKeyPair();
      await crypto.finalizeAndPersist(oldPin, salt);

      await pinService.updateLocalSecret(
        currentMethod: LocalSecurityMethod.pin,
        currentSecret: oldPin,
        targetMethod: LocalSecurityMethod.pin,
        newSecret: newPin,
      );

      expect(
        await pinService.verifyLocalSecret(
          method: LocalSecurityMethod.pin,
          secretBytes: newPin,
        ),
        isTrue,
      );
      expect(
        await storage.read(key: StorageKeys.localSecurityMethod),
        LocalSecurityMethod.pin.name,
      );
      expect(await storage.read(key: StorageKeys.kekSalt), isNotNull);
      expect(await storage.read(key: StorageKeys.devicePrivateKey), isNotNull);
    },
  );

  test('supports local password as a valid alternative method', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final pinService = container.read(pinServiceProvider);
    final crypto = container.read(cryptoServiceProvider.notifier);
    final storage = container.read(secureStorageProvider);

    await storage.clearAll();
    const oldPassword = 'Abcdef1!';
    const newPassword = 'Zxy987\$!';
    final salt = container.read(kdfServiceProvider).generateSalt();

    await pinService.setLocalSecret(
      method: LocalSecurityMethod.password,
      secretBytes: utf8.encode(oldPassword),
    );
    await storage.write(key: StorageKeys.kekSalt, value: base64Encode(salt));
    await crypto.generateAndHoldKeyPair();
    await crypto.finalizeAndPersist(utf8.encode(oldPassword), salt);

    await pinService.updateLocalSecret(
      currentMethod: LocalSecurityMethod.password,
      currentSecret: utf8.encode(oldPassword),
      targetMethod: LocalSecurityMethod.password,
      newSecret: utf8.encode(newPassword),
    );

    expect(
      await pinService.verifyLocalSecret(
        method: LocalSecurityMethod.password,
        secretBytes: utf8.encode(newPassword),
      ),
      isTrue,
    );
    expect(
      await pinService.readStoredLocalSecurityMethod(),
      LocalSecurityMethod.password,
    );
  });
}
