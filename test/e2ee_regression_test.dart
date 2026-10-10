import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('E2EE regression', () {
    test('local identity and registration id remain stable for the same database', () async {
      final db = AppDatabase(NativeDatabase.memory());
      final storeA = DriftSignalProtocolStore(db);
      final firstRegistrationId = await storeA.getLocalRegistrationId();
      final firstIdentity = await storeA.getIdentityKeyPair();

      final storeB = DriftSignalProtocolStore(db);
      final secondRegistrationId = await storeB.getLocalRegistrationId();
      final secondIdentity = await storeB.getIdentityKeyPair();

      expect(secondRegistrationId, equals(firstRegistrationId));
      expect(secondIdentity.serialize(), equals(firstIdentity.serialize()));
    });

    test('session record is readable after storing it at the same address', () async {
      final db = AppDatabase(NativeDatabase.memory());
      final store = DriftSignalProtocolStore(db);
      final address = SignalProtocolAddress('user', 1561500965);
      final record = SessionRecord();

      await store.storeSession(address, record);

      expect(await store.containsSession(address), isTrue);
      expect((await store.loadSession(address)).serialize(), equals(record.serialize()));
    });

    test('encryptOutboundMessage uses bundle device id instead of stale fallback 1', () async {
      final aliceDb = AppDatabase(NativeDatabase.memory());
      final bobDb = AppDatabase(NativeDatabase.memory());

      final aliceStore = DriftSignalProtocolStore(aliceDb);
      final bobStore = DriftSignalProtocolStore(bobDb);
      final bobBundle = await _buildBundleForStore(bobStore, userId: 'bob', deviceId: 1561500965);

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
      expect(envelope.recipientDeviceId, equals(bobBundle.getDeviceId().toString()));
    });

    test('A can encrypt to B and B can decrypt the message', () async {
      final aliceDb = AppDatabase(NativeDatabase.memory());
      final bobDb = AppDatabase(NativeDatabase.memory());

      final aliceStore = DriftSignalProtocolStore(aliceDb);
      final bobStore = DriftSignalProtocolStore(bobDb);

      final aliceBundle = await _buildBundleForStore(aliceStore, userId: 'alice', deviceId: 1);
      final bobBundle = await _buildBundleForStore(bobStore, userId: 'bob', deviceId: 1561500965);

      final aliceAddress = SignalProtocolAddress('bob', bobBundle.getDeviceId());
      final bobAddress = SignalProtocolAddress('alice', aliceBundle.getDeviceId());

      await SessionBuilder.fromSignalStore(aliceStore, aliceAddress)
          .processPreKeyBundle(bobBundle);
      await SessionBuilder.fromSignalStore(bobStore, bobAddress)
          .processPreKeyBundle(aliceBundle);

      final aliceCipher = SessionCipher.fromStore(aliceStore, aliceAddress);
      final ciphertext = await aliceCipher.encrypt(Uint8List.fromList(utf8.encode('hello')));
      expect(ciphertext, isA<PreKeySignalMessage>());

      final bobCipher = SessionCipher.fromStore(bobStore, bobAddress);
      final plaintext = await bobCipher.decrypt(ciphertext as PreKeySignalMessage);

      expect(String.fromCharCodes(plaintext), equals('hello'));
    });
  });
}
