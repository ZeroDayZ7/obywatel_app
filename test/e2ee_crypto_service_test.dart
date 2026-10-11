import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:obywatel_plus/core/crypto/drift_signal_protocol_store.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/communication/application/e2ee_crypto_service.dart';
import 'package:obywatel_plus/features/communication/application/messaging_activation_controller.dart';
import 'package:obywatel_plus/features/communication/data/datasources/messaging_activation_api_client.dart';
import 'package:obywatel_plus/features/communication/data/dtos/messaging_activation_dto.dart';

class _FakeE2eeCryptoService extends E2eeCryptoService {
  _FakeE2eeCryptoService()
    : super(
        SecureStorageService(const FlutterSecureStorage(), AppLogger()),
        AppLogger(),
        ApiClient(
          dio: Dio(),
          storage: SecureStorageService(
            const FlutterSecureStorage(),
            AppLogger(),
          ),
          logger: AppLogger(),
        ),
        DeviceInfoService(AppLogger()),
        DriftSignalProtocolStore(AppDatabase(NativeDatabase.memory())),
      );

  int registerCalls = 0;

  @override
  Future<void> registerDeviceIdentity() async {
    registerCalls += 1;
  }
}

class _FakeMessagingActivationApiClient extends MessagingActivationApiClient {
  _FakeMessagingActivationApiClient()
    : super(
        ApiClient(
          dio: Dio(),
          storage: SecureStorageService(
            const FlutterSecureStorage(),
            AppLogger(),
          ),
          logger: AppLogger(),
        ),
      );

  @override
  Future<MessagingActivationDto> getActivationStatus() async {
    return const MessagingActivationDto(
      userId: 'user-1',
      status: 'not_started',
      consentAccepted: false,
      requiresTermsAcceptance: true,
      currentTermsVersion: 'v1',
    );
  }

  @override
  Future<MessagingTermsDto> getCurrentTerms() async {
    return const MessagingTermsDto(version: 'v1', text: 'Akceptuję regulamin.');
  }

  @override
  Future<MessagingActivationDto> acceptTerms({
    required String deviceId,
    required String termsVersion,
  }) async {
    return const MessagingActivationDto(
      userId: 'user-1',
      status: 'active',
      consentAccepted: true,
      termsVersion: 'v1',
      currentTermsVersion: 'v1',
      requiresTermsAcceptance: false,
      deviceId: 'device-1',
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const secureStorageChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(secureStorageChannel, (
        MethodCall methodCall,
      ) async {
        switch (methodCall.method) {
          case 'write':
          case 'delete':
          case 'deleteAll':
            return null;
          case 'read':
            return null;
          case 'readAll':
            return <String, String>{};
          default:
            return null;
        }
      });

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
      'acceptCurrentTerms initializes E2EE device identity after consent',
      () async {
        final fakeCrypto = _FakeE2eeCryptoService();
        final fakeApiClient = _FakeMessagingActivationApiClient();
        final container = ProviderContainer(
          overrides: [
            messagingActivationApiClientProvider.overrideWithValue(
              fakeApiClient,
            ),
            deviceInfoServiceProvider.overrideWithValue(
              DeviceInfoService(AppLogger()),
            ),
            e2eeCryptoServiceProvider.overrideWithValue(fakeCrypto),
          ],
        );
        addTearDown(container.dispose);

        final controller = container.read(
          messagingActivationControllerProvider.notifier,
        );
        await controller.acceptCurrentTerms();

        expect(
          fakeCrypto.registerCalls,
          1,
          reason:
              'Akceptacja regulaminu powinna uruchamiać inicjalizację E2EE.',
        );
        final state = container
            .read(messagingActivationControllerProvider)
            .value;
        expect(state?.status?.status, 'active');
      },
    );

    test(
      'uses Signal-compatible identity key material instead of raw device public key',
      () async {
        final logger = AppLogger();
        final storage = SecureStorageService(
          const FlutterSecureStorage(),
          logger,
        );
        final apiClient = ApiClient(
          dio: Dio(),
          storage: storage,
          logger: logger,
        );
        final deviceInfoService = DeviceInfoService(logger);
        final db = AppDatabase(NativeDatabase.memory());
        addTearDown(() async => db.close());

        final signalStore = DriftSignalProtocolStore(db);
        final service = E2eeCryptoService(
          storage,
          logger,
          apiClient,
          deviceInfoService,
          signalStore,
        );

        await storage.write(
          key: StorageKeys.devicePublicKey,
          value: base64Encode(List<int>.filled(32, 0x11)),
        );

        final bundle = await service.ensureDeviceIdentityBundle();
        final decodedPublicKey = base64Decode(bundle.publicKey);

        expect(
          decodedPublicKey.length,
          33,
          reason:
              'identity_public_key must be a valid Signal EC public key (33-byte compressed or 65-byte uncompressed).',
        );
        expect(bundle.signedPreKey.length, greaterThan(0));
        expect(bundle.oneTimePreKeys.length, greaterThan(0));
        expect(bundle.oneTimePreKeys.first.keyId, greaterThan(0));
        expect(
          base64Decode(bundle.oneTimePreKeys.first.publicKey).length,
          33,
          reason:
              'one_time_pre_keys must also use Signal EC public key format.',
        );
      },
    );

    test(
      'encryptMessage preserves Signal message type for outbound requests',
      () async {
        final logger = AppLogger();
        final aliceStorage = SecureStorageService(
          const FlutterSecureStorage(),
          logger,
        );
        final aliceApiClient = ApiClient(
          dio: Dio(),
          storage: aliceStorage,
          logger: logger,
        );
        final deviceInfoService = DeviceInfoService(logger);
        final aliceDb = AppDatabase(NativeDatabase.memory());
        addTearDown(() async => aliceDb.close());

        final aliceStore = DriftSignalProtocolStore(aliceDb);
        final aliceService = E2eeCryptoService(
          aliceStorage,
          logger,
          aliceApiClient,
          deviceInfoService,
          aliceStore,
        );

        final bobIdentity = await aliceStore.getIdentityKeyPair();
        final bobSignedPreKey = generateSignedPreKey(bobIdentity, 1);
        final bobOneTimePreKey = generatePreKeys(1, 1).first;
        await aliceStore.storeSignedPreKey(bobSignedPreKey.id, bobSignedPreKey);
        await aliceStore.storePreKey(bobOneTimePreKey.id, bobOneTimePreKey);

        final remoteBundle = PreKeyBundle(
          await aliceStore.getLocalRegistrationId(),
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

        final encrypted = await aliceService.encryptMessage(
          'peer-user',
          'hello type preservation',
        );

        expect(encrypted.ciphertextBase64.isNotEmpty, isTrue);
        expect(encrypted.type, isNotNull);
        expect([
          CiphertextMessage.prekeyType,
          CiphertextMessage.whisperType,
        ], contains(encrypted.type));
      },
    );

    test(
      'encrypts and decrypts multiple messages with a real Signal session',
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

        final message1 = await aliceService.encryptOutboundMessage(
          'peer-user',
          'hello signal 1',
          senderDeviceId: 'device-1',
        );
        final message2 = await aliceService.encryptOutboundMessage(
          'peer-user',
          'hello signal 2',
          senderDeviceId: 'device-1',
        );

        final plaintext1 = await bobService.decryptInboundMessage(
          senderUserId: 'peer-user',
          senderDeviceId: '1',
          ciphertextBase64: message1.ciphertext,
          type: message1.type,
        );
        final plaintext2 = await bobService.decryptInboundMessage(
          senderUserId: 'peer-user',
          senderDeviceId: '1',
          ciphertextBase64: message2.ciphertext,
          type: message2.type,
        );

        expect(plaintext1, 'hello signal 1');
        expect(plaintext2, 'hello signal 2');
      },
    );

    test('rejects tampered Signal ciphertext', () async {
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
        'secret message',
        senderDeviceId: 'device-1',
      );

      final tampered = base64Encode(
        base64Decode(
          encrypted.ciphertext,
        ).map((byte) => byte == 0 ? 1 : byte).toList(),
      );

      await expectLater(
        bobService.decryptInboundMessage(
          senderUserId: 'peer-user',
          senderDeviceId: '1',
          ciphertextBase64: tampered,
          type: encrypted.type,
        ),
        throwsA(isA<EncryptionFailureException>()),
      );
    });
  });
}
