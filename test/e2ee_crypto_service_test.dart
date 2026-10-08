import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:obywatel_plus/core/crypto/drift_signal_protocol_store.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/communication/application/e2ee_crypto_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('E2eeCryptoService', () {
    test('parses a Signal pre-key bundle from backend JSON', () {
      final identity = generateIdentityKeyPair();
      final signedPreKey = generateSignedPreKey(identity, 1);
      final oneTimePreKey = generatePreKeys(1, 1).first;

      final bundle = E2eeCryptoService.fromPreKeyBundleJson({
        'registrationId': 123,
        'deviceId': 'device-1',
        'preKeyId': 7,
        'preKeyPublic': base64Encode(
          oneTimePreKey.getKeyPair().publicKey.serialize(),
        ),
        'signedPreKeyId': 1,
        'signedPreKeyPublic': base64Encode(
          signedPreKey.getKeyPair().publicKey.serialize(),
        ),
        'signedPreKeySignature': base64Encode(signedPreKey.signature),
        'identityKey': base64Encode(identity.getPublicKey().serialize()),
      });

      expect(bundle.getRegistrationId(), 123);
      expect(bundle.getDeviceId(), 1);
      expect(bundle.getSignedPreKeyId(), 1);
      expect(
        bundle.getIdentityKey().serialize(),
        identity.getPublicKey().serialize(),
      );
    });

    test(
      'encrypts and decrypts a message with a real Signal session',
      () async {
        final logger = AppLogger();
        final aliceStorage = SecureStorageService(
          const FlutterSecureStorage(),
          logger,
        );
        final bobStorage = SecureStorageService(
          const FlutterSecureStorage(),
          logger,
        );
        final aliceApiClient = ApiClient(
          dio: Dio(),
          storage: aliceStorage,
          logger: logger,
        );
        final bobApiClient = ApiClient(
          dio: Dio(),
          storage: bobStorage,
          logger: logger,
        );
        final deviceInfoService = DeviceInfoService(logger);

        final aliceDb = AppDatabase(NativeDatabase.memory());
        final bobDb = AppDatabase(NativeDatabase.memory());
        addTearDown(() async {
          await aliceDb.close();
          await bobDb.close();
        });

        final aliceStore = DriftSignalProtocolStore(aliceDb);
        final bobStore = DriftSignalProtocolStore(bobDb);

        final aliceService = E2eeCryptoService(
          aliceStorage,
          logger,
          aliceApiClient,
          deviceInfoService,
          aliceStore,
        );
        final bobService = E2eeCryptoService(
          bobStorage,
          logger,
          bobApiClient,
          deviceInfoService,
          bobStore,
        );

        final bobIdentity = await bobStore.getIdentityKeyPair();
        final bobSignedPreKey = generateSignedPreKey(bobIdentity, 1);
        final bobOneTimePreKey = generatePreKeys(1, 1).first;
        await bobStore.storeSignedPreKey(bobSignedPreKey.id, bobSignedPreKey);
        await bobStore.storePreKey(bobOneTimePreKey.id, bobOneTimePreKey);

        final remoteBundle = PreKeyBundle(
          await bobStore.getLocalRegistrationId(),
          1,
          bobOneTimePreKey.id,
          bobOneTimePreKey.getKeyPair().publicKey,
          bobSignedPreKey.id,
          bobSignedPreKey.getKeyPair().publicKey,
          bobSignedPreKey.signature,
          bobIdentity.getPublicKey(),
        );

        await aliceService.initializeSessionForPeer(
          'peer-user',
          remoteBundle: remoteBundle,
        );
        final encrypted = await aliceService.encryptOutboundMessage(
          'peer-user',
          'hello signal',
          senderDeviceId: 'device-1',
        );
        final plaintext = await bobService.decryptInboundMessage(
          senderUserId: 'peer-user',
          senderDeviceId: '1',
          ciphertextBase64: encrypted.ciphertext,
          type: encrypted.type,
        );

        expect(plaintext, 'hello signal');
      },
    );
  });
}
