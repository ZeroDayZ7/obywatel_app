import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
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
import 'package:uuid/uuid.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('E2EE security refactor', () {
    late AppDatabase db;
    late DriftSignalProtocolStore signalStore;
    late SecureStorageService secureStorage;
    late AppLogger logger;
    late E2eeCryptoService service;

    setUp(() async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
            (methodCall) async {
              switch (methodCall.method) {
                case 'read':
                  return null;
                case 'write':
                  return null;
                case 'delete':
                  return null;
                case 'readAll':
                  return <String, String>{};
                case 'deleteAll':
                  return null;
                default:
                  return null;
              }
            },
          );

      db = AppDatabase(NativeDatabase.memory());
      signalStore = DriftSignalProtocolStore(db);
      logger = AppLogger();
      secureStorage = SecureStorageService(
        const FlutterSecureStorage(),
        logger,
      );
      final deviceInfoService = DeviceInfoService(logger);
      final apiClient = ApiClient(
        dio: Dio(),
        storage: secureStorage,
        logger: logger,
      );
      service = E2eeCryptoService(
        secureStorage,
        logger,
        apiClient,
        deviceInfoService,
        signalStore,
      );
    });

    tearDown(() async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
            null,
          );
      await db.close();
    });

    test('existing one-time prekeys tolerate missing key id 1', () async {
      final identity = generateIdentityKeyPair();
      await signalStore.storeSignedPreKey(1, generateSignedPreKey(identity, 1));

      final preKeys = generatePreKeys(2, 9);
      for (final record in preKeys) {
        await signalStore.storePreKey(record.id, record);
      }

      final material = await service.ensureDeviceIdentityBundle();

      final storedKeyIds = material.oneTimePreKeys.map((key) => key.keyId).toList();
      expect(storedKeyIds, containsAll(preKeys.map((record) => record.id)));
      expect(storedKeyIds, isNot(contains(1)));
    });

    test('registration DTO does not include private key material', () async {
      final localMaterial = await service.ensureDeviceIdentityBundle();
      final request = localMaterial.toRegistrationRequest();
      final payload = request.toJson();

      expect(localMaterial.privateKey, isNotEmpty);
      expect(payload['privateKey'], isNull);
      expect(payload['deviceId'], localMaterial.deviceId);
      expect(payload['identityPublicKey'], localMaterial.identityPublicKey);
    });

    test(
      'inbound device resolution refuses to guess a Signal device from an app UUID',
      () async {
        final uuid = const Uuid().v4();

        expect(
          () => service.resolveInboundSignalDeviceCandidates(
            senderUserId: 'user-42',
            senderDeviceId: uuid,
          ),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test('identity change is rejected before a session is created', () async {
      final currentIdentity = generateIdentityKeyPair();
      final changedIdentity = generateIdentityKeyPair();
      final address = SignalProtocolAddress('user-9', 1);
      await signalStore.saveIdentity(address, currentIdentity.getPublicKey());

      final preKey = generatePreKeys(5, 1).first;
      final signedPreKey = generateSignedPreKey(changedIdentity, 2);
      final remoteBundle = PreKeyBundle(
        123,
        1,
        preKey.id,
        preKey.getKeyPair().publicKey,
        signedPreKey.id,
        signedPreKey.getKeyPair().publicKey,
        signedPreKey.signature,
        changedIdentity.getPublicKey(),
      );

      expect(
        () => service.initializeSessionForPeer(
          'user-9',
          remoteBundle: remoteBundle,
          deviceId: 1,
        ),
        throwsA(isA<StateError>()),
      );
    });
  });
}
