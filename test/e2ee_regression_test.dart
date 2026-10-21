import 'dart:convert';
import 'dart:io';
import 'dart:math';

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
import 'package:obywatel_plus/features/communication/application/contact_identity_verification_service.dart';
import 'package:obywatel_plus/features/communication/application/e2ee_crypto_service.dart';

class _StubDeviceInfoService extends DeviceInfoService {
  _StubDeviceInfoService() : super(AppLogger());

  @override
  Future<String> getOrCreateDeviceId() async => 'stable-device-id';
}

class _StubApiClient extends ApiClient {
  _StubApiClient({required Map<String, dynamic> bundle})
    : _bundle = bundle,
      super(
        dio: Dio(),
        storage: SecureStorageService(
          const FlutterSecureStorage(),
          AppLogger(),
        ),
        logger: AppLogger(),
      );

  final Map<String, dynamic> _bundle;

  @override
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParams,
    Options? options,
    Map<String, String>? headers,
  }) async {
    if (path == '/crypto/keys/prekeys/bob') {
      return Response<dynamic>(
        data: _bundle,
        statusCode: 200,
        requestOptions: RequestOptions(path: path),
      );
    }

    throw StateError('Unexpected GET $path');
  }

  @override
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Options? options,
    Map<String, String>? headers,
  }) async {
    if (path == '/crypto/keys/device') {
      return Response<dynamic>(
        data: {'ok': true},
        statusCode: 200,
        requestOptions: RequestOptions(path: path),
      );
    }

    throw StateError('Unexpected POST $path');
  }
}

Future<PreKeyBundle> _buildBundleForStore(
  DriftSignalProtocolStore store, {
  required String userId,
  required int deviceId,
}) async {
  final identityPair = await store.getIdentityKeyPair();
  final signedPreKey = generateSignedPreKey(identityPair, 1);
  await store.storeSignedPreKey(signedPreKey.id, signedPreKey);

  final preKey = generatePreKeys(1, 1).first;
  await store.storePreKey(preKey.id, preKey);

  return PreKeyBundle(
    await store.getLocalRegistrationId(),
    deviceId,
    preKey.id,
    preKey.getKeyPair().publicKey,
    signedPreKey.id,
    signedPreKey.getKeyPair().publicKey,
    signedPreKey.signature,
    identityPair.getPublicKey(),
  );
}

Map<String, dynamic> _bundleToJson(PreKeyBundle bundle) {
  return {
    'registrationId': bundle.getRegistrationId(),
    'deviceId': bundle.getDeviceId().toString(),
    'preKeyId': bundle.getPreKeyId(),
    'preKeyPublic': base64Encode(bundle.getPreKey()!.serialize()),
    'signedPreKeyId': bundle.getSignedPreKeyId(),
    'signedPreKeyPublic': base64Encode(bundle.getSignedPreKey()!.serialize()),
    'signedPreKeySignature': base64Encode(bundle.getSignedPreKeySignature()!),
    'identityKey': base64Encode(bundle.getIdentityKey().serialize()),
  };
}

AppDatabase _createIsolatedDatabase() {
  final uniquePath =
      '${Directory.systemTemp.path}/obywatel_plus_test_${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(100000)}.db';
  return AppDatabase(NativeDatabase(File(uniquePath)));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final secureStorageValues = <String, String>{};
  const secureStorageChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(secureStorageChannel, (
        MethodCall methodCall,
      ) async {
        switch (methodCall.method) {
          case 'write':
            final key = methodCall.arguments['key'] as String?;
            final value = methodCall.arguments['value'] as String?;
            if (key != null && value != null) {
              secureStorageValues[key] = value;
            }
            return null;
          case 'read':
            final key = methodCall.arguments['key'] as String?;
            return key == null ? null : secureStorageValues[key];
          case 'delete':
            final key = methodCall.arguments['key'] as String?;
            if (key != null) {
              secureStorageValues.remove(key);
            }
            return null;
          case 'deleteAll':
            secureStorageValues.clear();
            return null;
          case 'readAll':
            return Map<String, String>.from(secureStorageValues);
          default:
            return null;
        }
      });

  group('E2EE regression', () {
    test(
      'local identity and registration id remain stable for the same database',
      () async {
        final db = _createIsolatedDatabase();
        addTearDown(() async => db.close());

        final storeA = DriftSignalProtocolStore(db);
        final firstRegistrationId = await storeA.getLocalRegistrationId();
        final firstIdentity = await storeA.getIdentityKeyPair();

        final storeB = DriftSignalProtocolStore(db);
        final secondRegistrationId = await storeB.getLocalRegistrationId();
        final secondIdentity = await storeB.getIdentityKeyPair();

        expect(secondRegistrationId, equals(firstRegistrationId));
        expect(secondIdentity.serialize(), equals(firstIdentity.serialize()));
      },
    );
    test(
      'parallel initialization keeps the original local identity and registration id',
      () async {
        final db = _createIsolatedDatabase();
        addTearDown(() async => db.close());

        final firstStore = DriftSignalProtocolStore(db);
        final firstIdentity = await firstStore.getIdentityKeyPair();
        final firstRegistrationId = await firstStore.getLocalRegistrationId();

        final secondStore = DriftSignalProtocolStore(
          db,
          identityKeyPair: generateIdentityKeyPair(),
          localRegistrationId: generateRegistrationId(false),
        );
        final secondIdentity = await secondStore.getIdentityKeyPair();
        final secondRegistrationId = await secondStore.getLocalRegistrationId();

        expect(secondIdentity.serialize(), equals(firstIdentity.serialize()));
        expect(secondRegistrationId, equals(firstRegistrationId));
      },
    );
    test(
      'session record is readable after storing it at the same address',
      () async {
        final db = _createIsolatedDatabase();
        addTearDown(() async => db.close());

        final store = DriftSignalProtocolStore(db);
        final address = SignalProtocolAddress('user', 1561500965);
        final record = SessionRecord();

        await store.storeSession(address, record);

        expect(await store.containsSession(address), isTrue);
        expect(
          (await store.loadSession(address)).serialize(),
          equals(record.serialize()),
        );
      },
    );

    test('rejects a Signal bundle when deviceId is missing', () {
      final identity = generateIdentityKeyPair();
      final signedPreKey = generateSignedPreKey(identity, 1);
      final oneTimePreKey = generatePreKeys(1, 1).first;

      expect(
        () => E2eeCryptoService.fromPreKeyBundleJson({
          'registrationId': 123,
          'deviceId': '',
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
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test(
      'encryptOutboundMessage uses bundle device id instead of stale fallback 1',
      () async {
        final aliceDb = _createIsolatedDatabase();
        final bobDb = _createIsolatedDatabase();

        final aliceStore = DriftSignalProtocolStore(aliceDb);
        final bobStore = DriftSignalProtocolStore(bobDb);
        final bobBundle = await _buildBundleForStore(
          bobStore,
          userId: 'bob',
          deviceId: 1561500965,
        );

        final apiClient = _StubApiClient(bundle: _bundleToJson(bobBundle));
        final service = E2eeCryptoService(
          SecureStorageService(const FlutterSecureStorage(), AppLogger()),
          AppLogger(),
          apiClient,
          _StubDeviceInfoService(),
          aliceStore,
        );

        final envelope = await service.encryptOutboundMessage('bob', 'hello');

        expect(envelope.ciphertext, isNotEmpty);
        expect(envelope.recipientUserId, equals('bob'));
        expect(
          envelope.recipientDeviceId,
          equals(bobBundle.getDeviceId().toString()),
        );
      },
    );

    test('A can encrypt to B and B can decrypt the message', () async {
      final aliceDb = _createIsolatedDatabase();
      final bobDb = _createIsolatedDatabase();

      final aliceStore = DriftSignalProtocolStore(aliceDb);
      final bobStore = DriftSignalProtocolStore(bobDb);

      final aliceBundle = await _buildBundleForStore(
        aliceStore,
        userId: 'alice',
        deviceId: 1,
      );
      final bobBundle = await _buildBundleForStore(
        bobStore,
        userId: 'bob',
        deviceId: 1561500965,
      );

      final aliceAddress = SignalProtocolAddress(
        'bob',
        bobBundle.getDeviceId(),
      );
      final bobAddress = SignalProtocolAddress(
        'alice',
        aliceBundle.getDeviceId(),
      );

      await SessionBuilder.fromSignalStore(
        aliceStore,
        aliceAddress,
      ).processPreKeyBundle(bobBundle);
      await SessionBuilder.fromSignalStore(
        bobStore,
        bobAddress,
      ).processPreKeyBundle(aliceBundle);

      final aliceCipher = SessionCipher.fromStore(aliceStore, aliceAddress);
      final ciphertext = await aliceCipher.encrypt(
        Uint8List.fromList(utf8.encode('hello')),
      );
      expect(ciphertext, isA<PreKeySignalMessage>());

      final bobCipher = SessionCipher.fromStore(bobStore, bobAddress);
      final plaintext = await bobCipher.decrypt(
        ciphertext as PreKeySignalMessage,
      );

      expect(String.fromCharCodes(plaintext), equals('hello'));
    });

    group('Contact identity verification', () {
      late AppDatabase db;
      late SecureStorageService secureStorage;
      late DriftSignalProtocolStore store;

      setUp(() {
        secureStorageValues.clear();
        db = _createIsolatedDatabase();
        secureStorage = SecureStorageService(
          const FlutterSecureStorage(),
          AppLogger(),
        );
        store = DriftSignalProtocolStore(db, logger: AppLogger());
      });

      tearDown(() async {
        await db.close();
      });

      test('new contact without a known Signal identity is unknown', () async {
        final service = ContactIdentityVerificationService(
          db: db,
          secureStorage: secureStorage,
          logger: AppLogger(),
        );

        final state = await service.resolveForContact('bob', deviceId: 42);

        expect(state.status, ContactIdentityVerificationStatus.unknown);
        expect(state.fingerprint, equals(null));
      });

      test(
        'a known identity without manual verification stays unverified',
        () async {
          final address = SignalProtocolAddress('bob', 42);
          final identity = generateIdentityKeyPair().getPublicKey();
          await store.saveIdentity(address, identity);

          final service = ContactIdentityVerificationService(
            db: db,
            secureStorage: secureStorage,
            logger: AppLogger(),
          );

          final state = await service.resolveForContact('bob', deviceId: 42);

          expect(state.status, ContactIdentityVerificationStatus.unverified);
          expect(state.fingerprint, isNot(equals(null)));
          expect(state.fingerprint, isNot('bob'));
        },
      );

      test(
        'manual verification without a real Signal comparison stays unverified',
        () async {
          final address = SignalProtocolAddress('bob', 42);
          final identity = generateIdentityKeyPair().getPublicKey();
          await store.saveIdentity(address, identity);

          final service = ContactIdentityVerificationService(
            db: db,
            secureStorage: secureStorage,
            logger: AppLogger(),
          );

          final before = await service.resolveForContact('bob', deviceId: 42);
          final attempted = await service.verifyIdentity('bob', deviceId: 42);
          final after = await service.resolveForContact('bob', deviceId: 42);

          expect(before.status, ContactIdentityVerificationStatus.unverified);
          expect(
            attempted.status,
            ContactIdentityVerificationStatus.unverified,
          );
          expect(after.status, ContactIdentityVerificationStatus.unverified);
          expect(attempted.fingerprint, before.fingerprint);
          expect(after.fingerprint, before.fingerprint);
        },
      );

      test(
        'changed Signal identity invalidates the previous verification',
        () async {
          final address = SignalProtocolAddress('bob', 42);
          final originalIdentity = generateIdentityKeyPair().getPublicKey();
          await store.saveIdentity(address, originalIdentity);

          final originalFingerprint = E2eeCryptoService.fingerprintIdentityKey(
            originalIdentity,
          );
          await secureStorage.write(
            key:
                'signal_identity_verification_${base64Url.encode(utf8.encode('bob'))}_42',
            value: jsonEncode({
              'userId': 'bob',
              'deviceId': 42,
              'fingerprint': originalFingerprint,
              'verifiedAt': DateTime.now().toUtc().toIso8601String(),
            }),
          );

          final replacementIdentity = generateIdentityKeyPair().getPublicKey();
          await store.saveIdentity(address, replacementIdentity);

          final service = ContactIdentityVerificationService(
            db: db,
            secureStorage: secureStorage,
            logger: AppLogger(),
          );

          final state = await service.resolveForContact('bob', deviceId: 42);

          expect(state.status, ContactIdentityVerificationStatus.changed);
          expect(state.previousFingerprint, equals(originalFingerprint));
          expect(state.previousFingerprint, isNot(state.fingerprint));
        },
      );

      test(
        'stored verification remains durable after re-creating the service',
        () async {
          final address = SignalProtocolAddress('bob', 42);
          final identity = generateIdentityKeyPair().getPublicKey();
          await store.saveIdentity(address, identity);

          final storageKey =
              'signal_identity_verification_${base64Url.encode(utf8.encode('bob'))}_42';
          final verifiedAt = DateTime.now().toUtc().toIso8601String();
          await secureStorage.write(
            key: storageKey,
            value: jsonEncode({
              'userId': 'bob',
              'deviceId': 42,
              'fingerprint': E2eeCryptoService.fingerprintIdentityKey(identity),
              'verifiedAt': verifiedAt,
            }),
          );

          final firstService = ContactIdentityVerificationService(
            db: db,
            secureStorage: secureStorage,
            logger: AppLogger(),
          );
          final stateBefore = await firstService.resolveForContact(
            'bob',
            deviceId: 42,
          );

          final secondService = ContactIdentityVerificationService(
            db: db,
            secureStorage: secureStorage,
            logger: AppLogger(),
          );
          final stateAfter = await secondService.resolveForContact(
            'bob',
            deviceId: 42,
          );

          expect(
            stateBefore.status,
            ContactIdentityVerificationStatus.verified,
          );
          expect(stateAfter.status, ContactIdentityVerificationStatus.verified);
          expect(stateAfter.fingerprint, stateBefore.fingerprint);
        },
      );
    });
  });
}
