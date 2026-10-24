import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:obywatel_plus/core/crypto/drift_signal_protocol_store.dart';
import 'package:obywatel_plus/core/crypto/symmetric_crypto.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/auth/domain/auth_user.dart';
import 'package:obywatel_plus/features/communication/application/e2ee_crypto_service.dart';
import 'package:obywatel_plus/features/communication/application/messaging_activation_controller.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/datasources/messaging_activation_api_client.dart';
import 'package:obywatel_plus/features/communication/data/dtos/messaging_activation_dto.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/crypto/e2ee_models.dart';
import 'package:uuid/uuid.dart';

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

  @override
  Future<EncryptedData> encryptMessage(
    String remoteUserId,
    String plaintext, {
    String? operationId,
  }) async {
    return EncryptedData(
      ciphertextBase64: 'ciphertext-value',
      nonceBase64: '',
      type: CiphertextMessage.whisperType,
    );
  }
}

class _FakeChatsApiClient extends ChatsApiClient {
  _FakeChatsApiClient()
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

  Map<String, dynamic>? lastRequestPayload;

  @override
  Future<Response<dynamic>> post(String path, {dynamic data}) async {
    lastRequestPayload = data is Map<String, dynamic>
        ? data
        : Map<String, dynamic>.from(data as Map);

    return Response<dynamic>(
      data: {'messageId': lastRequestPayload!['messageId']},
      statusCode: 200,
      requestOptions: RequestOptions(path: path),
    );
  }
}

class _FakeBundleApiClient extends ApiClient {
  _FakeBundleApiClient(this.responsePayload)
    : super(
        dio: Dio(),
        storage: SecureStorageService(
          const FlutterSecureStorage(),
          AppLogger(),
        ),
        logger: AppLogger(),
      );

  final Map<String, dynamic> responsePayload;

  @override
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParams,
    Options? options,
    Map<String, String>? headers,
  }) async {
    return Response<dynamic>(
      data: responsePayload,
      statusCode: 200,
      requestOptions: RequestOptions(path: path),
    );
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
  final inMemorySecureStorage = <String, String>{};
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(secureStorageChannel, (
        MethodCall methodCall,
      ) async {
        switch (methodCall.method) {
          case 'write':
            final key = methodCall.arguments['key'] as String?;
            final value = methodCall.arguments['value'] as String?;
            if (key != null) {
              if (value == null) {
                inMemorySecureStorage.remove(key);
              } else {
                inMemorySecureStorage[key] = value;
              }
            }
            return null;
          case 'delete':
            final key = methodCall.arguments['key'] as String?;
            if (key != null) {
              inMemorySecureStorage.remove(key);
            }
            return null;
          case 'deleteAll':
            inMemorySecureStorage.clear();
            return null;
          case 'read':
            final key = methodCall.arguments['key'] as String?;
            return key == null ? null : inMemorySecureStorage[key];
          case 'readAll':
            return Map<String, String>.from(inMemorySecureStorage);
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
        'deviceId': '1',
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
      expect(bundle.getPreKeyId(), 7);
      expect(
        bundle.getIdentityKey().serialize(),
        identity.getPublicKey().serialize(),
      );
    });

    test('accepts a bundle without an optional one-time pre-key', () {
      final identity = generateIdentityKeyPair();
      final signedPreKey = generateSignedPreKey(identity, 1);

      final bundle = E2eeCryptoService.fromPreKeyBundleJson({
        'registrationId': 123,
        'deviceId': '1',
        'signedPreKeyId': 1,
        'signedPreKeyPublic': base64Encode(
          signedPreKey.getKeyPair().publicKey.serialize(),
        ),
        'signedPreKeySignature': base64Encode(signedPreKey.signature),
        'identityKey': base64Encode(identity.getPublicKey().serialize()),
      });

      expect(bundle.getRegistrationId(), 123);
      expect(bundle.getDeviceId(), 1);
      expect(bundle.getPreKeyId(), isNull);
      expect(bundle.getSignedPreKeyId(), 1);
    });

    test(
      'persists the peer app-device mapping from a trusted backend bundle',
      () async {
        final logger = AppLogger();
        final storage = SecureStorageService(
          const FlutterSecureStorage(),
          logger,
        );
        final identity = generateIdentityKeyPair();
        final signedPreKey = generateSignedPreKey(identity, 1);
        final oneTimePreKey = generatePreKeys(1, 1).first;
        final peerAppDeviceId = const Uuid().v4();

        final fakeApiClient = _FakeBundleApiClient({
          'registrationId': 123,
          'deviceId': '1',
          'appDeviceId': peerAppDeviceId,
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

        final db = AppDatabase(NativeDatabase.memory());
        addTearDown(() async => db.close());

        final service = E2eeCryptoService(
          storage,
          logger,
          fakeApiClient,
          DeviceInfoService(logger),
          DriftSignalProtocolStore(db),
        );

        final bundle = await service.fetchRemotePreKeyBundle('peer-user');
        expect(bundle.getDeviceId(), 1);

        final persisted = await storage.read(key: 'e2ee_signal_device_mapping');
        expect(persisted, isNotNull);
        expect(jsonDecode(persisted!)['peer-user'][peerAppDeviceId], 1);
      },
    );

    test(
      'acceptCurrentTerms initializes E2EE device identity after consent',
      () async {
        final fakeCrypto = _FakeE2eeCryptoService();
        final fakeApiClient = _FakeMessagingActivationApiClient();
        final fakeSessionService = SessionService(
          SecureStorageService(const FlutterSecureStorage(), AppLogger()),
          AppLogger(),
        );
        await fakeSessionService.cacheUser(const AuthUser(id: 'user-1'));
        final memoryDb = AppDatabase(NativeDatabase.memory());

        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(memoryDb),
            sessionServiceProvider.overrideWithValue(fakeSessionService),
            messagingActivationApiClientProvider.overrideWithValue(
              fakeApiClient,
            ),
            deviceInfoServiceProvider.overrideWithValue(
              DeviceInfoService(AppLogger()),
            ),
            e2eeCryptoServiceProvider.overrideWithValue(fakeCrypto),
          ],
        );
        addTearDown(() async => await memoryDb.close());
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
        expect(state?.status, 'active');
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

        final aliceIdentity = await aliceStore.getIdentityKeyPair();
        final aliceSignedPreKey = generateSignedPreKey(aliceIdentity, 1);
        final aliceOneTimePreKey = generatePreKeys(1, 1).first;
        await aliceStore.storeSignedPreKey(
          aliceSignedPreKey.id,
          aliceSignedPreKey,
        );
        await aliceStore.storePreKey(aliceOneTimePreKey.id, aliceOneTimePreKey);

        final bobRemoteBundle = PreKeyBundle(
          await bobStore.getLocalRegistrationId(),
          1,
          bobOneTimePreKey.id,
          bobOneTimePreKey.getKeyPair().publicKey,
          bobSignedPreKey.id,
          bobSignedPreKey.getKeyPair().publicKey,
          bobSignedPreKey.signature,
          bobIdentity.getPublicKey(),
        );
        final aliceRemoteBundle = PreKeyBundle(
          await aliceStore.getLocalRegistrationId(),
          1,
          aliceOneTimePreKey.id,
          aliceOneTimePreKey.getKeyPair().publicKey,
          aliceSignedPreKey.id,
          aliceSignedPreKey.getKeyPair().publicKey,
          aliceSignedPreKey.signature,
          aliceIdentity.getPublicKey(),
        );

        await aliceService.initializeSessionForPeer(
          'peer-user',
          remoteBundle: bobRemoteBundle,
        );
        await bobService.initializeSessionForPeer(
          'peer-user',
          remoteBundle: aliceRemoteBundle,
        );

        final senderAppDeviceId = const Uuid().v4();
        await bobService.persistSignalDeviceMapping(
          senderUserId: 'peer-user',
          appDeviceId: senderAppDeviceId,
          signalDeviceId: 1,
        );

        final message1 = await aliceService.encryptOutboundMessage(
          'peer-user',
          'hello signal 1',
          senderDeviceId: senderAppDeviceId,
        );
        final message2 = await aliceService.encryptOutboundMessage(
          'peer-user',
          'hello signal 2',
          senderDeviceId: senderAppDeviceId,
        );

        final plaintext1 = await bobService.decryptInboundMessage(
          senderUserId: 'peer-user',
          senderDeviceId: senderAppDeviceId,
          ciphertextBase64: message1.ciphertext,
          type: message1.type,
        );
        final plaintext2 = await bobService.decryptInboundMessage(
          senderUserId: 'peer-user',
          senderDeviceId: senderAppDeviceId,
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

      final aliceIdentity = await aliceStore.getIdentityKeyPair();
      final aliceSignedPreKey = generateSignedPreKey(aliceIdentity, 1);
      final aliceOneTimePreKey = generatePreKeys(1, 1).first;
      await aliceStore.storeSignedPreKey(
        aliceSignedPreKey.id,
        aliceSignedPreKey,
      );
      await aliceStore.storePreKey(aliceOneTimePreKey.id, aliceOneTimePreKey);

      final bobRemoteBundle = PreKeyBundle(
        await bobStore.getLocalRegistrationId(),
        1,
        bobOneTimePreKey.id,
        bobOneTimePreKey.getKeyPair().publicKey,
        bobSignedPreKey.id,
        bobSignedPreKey.getKeyPair().publicKey,
        bobSignedPreKey.signature,
        bobIdentity.getPublicKey(),
      );
      final aliceRemoteBundle = PreKeyBundle(
        await aliceStore.getLocalRegistrationId(),
        1,
        aliceOneTimePreKey.id,
        aliceOneTimePreKey.getKeyPair().publicKey,
        aliceSignedPreKey.id,
        aliceSignedPreKey.getKeyPair().publicKey,
        aliceSignedPreKey.signature,
        aliceIdentity.getPublicKey(),
      );

      await aliceService.initializeSessionForPeer(
        'peer-user',
        remoteBundle: bobRemoteBundle,
      );
      await bobService.initializeSessionForPeer(
        'peer-user',
        remoteBundle: aliceRemoteBundle,
      );

      final senderAppDeviceId = const Uuid().v4();
      await bobService.persistSignalDeviceMapping(
        senderUserId: 'peer-user',
        appDeviceId: senderAppDeviceId,
        signalDeviceId: 1,
      );

      final encrypted = await aliceService.encryptOutboundMessage(
        'peer-user',
        'secret message',
        senderDeviceId: senderAppDeviceId,
      );

      final tampered = base64Encode(
        base64Decode(
          encrypted.ciphertext,
        ).map((byte) => byte == 0 ? 1 : byte).toList(),
      );

      await expectLater(
        bobService.decryptInboundMessage(
          senderUserId: 'peer-user',
          senderDeviceId: senderAppDeviceId,
          ciphertextBase64: tampered,
          type: encrypted.type,
        ),
        throwsA(isA<EncryptionFailureException>()),
      );
    });

    test(
      'rejects inbound decrypts without an explicit app-device mapping',
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

        final missingMappingAppDeviceId = const Uuid().v4();
        final encrypted = await aliceService.encryptOutboundMessage(
          'peer-user',
          'secret message',
          senderDeviceId: missingMappingAppDeviceId,
        );

        await expectLater(
          bobService.decryptInboundMessage(
            senderUserId: 'peer-user',
            senderDeviceId: missingMappingAppDeviceId,
            ciphertextBase64: encrypted.ciphertext,
            type: encrypted.type,
          ),
          throwsA(isA<SignalDeviceMappingException>()),
        );
      },
    );

    test(
      'keeps plaintext only in the in-memory cache and not in secure storage',
      () async {
        final logger = AppLogger();
        final secureStorage = SecureStorageService(
          const FlutterSecureStorage(),
          logger,
        );
        final fakeApiClient = _FakeChatsApiClient();
        final deviceInfoService = DeviceInfoService(logger);
        final db = AppDatabase(NativeDatabase.memory());
        addTearDown(() async => db.close());

        final repo = ChatsRepositoryImpl(
          fakeApiClient,
          db,
          logger,
          'current-user',
          deviceInfoService,
          _FakeE2eeCryptoService(),
          SymmetricCrypto(logger),
          secureStorage,
        );

        await repo.sendMessage(
          conversationId: 'peer-user',
          content: 'hello plaintext cache',
        );

        final historyBefore = await repo.getMessageHistory('peer-user');
        final storedMessageId = historyBefore.isNotEmpty
            ? historyBefore.first.id
            : 'missing';
        expect(
          await secureStorage.read(key: 'chat_plaintext_$storedMessageId'),
          isNull,
          reason:
              'Plaintext chat content must never be stored in secure storage.',
        );

        final history = await repo.getMessageHistory('peer-user');
        expect(history, isNotEmpty);
        expect(history.first.content, 'hello plaintext cache');
      },
    );
  });
}
