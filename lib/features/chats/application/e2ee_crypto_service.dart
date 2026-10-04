import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:obywatel_plus/core/crypto/drift_signal_protocol_store.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'e2ee_crypto_service.g.dart';

class EncryptedData {
  final String ciphertextBase64;
  final String nonceBase64;

  const EncryptedData({
    required this.ciphertextBase64,
    required this.nonceBase64,
  });
}

class DeviceKeyBundle {
  final String deviceId;
  final String publicKey;
  final String privateKey;
  final String signedPreKey;
  final String signedPreKeySignature;
  final int signedPreKeyId;
  final List<String> oneTimePreKeys;

  const DeviceKeyBundle({
    required this.deviceId,
    required this.publicKey,
    required this.privateKey,
    required this.signedPreKey,
    required this.signedPreKeySignature,
    required this.signedPreKeyId,
    required this.oneTimePreKeys,
  });
}

class EncryptionFailureException implements Exception {
  final String message;

  const EncryptionFailureException(this.message);

  @override
  String toString() => 'EncryptionFailureException: $message';
}

class E2eeCryptoService {
  E2eeCryptoService(
    this._secureStorage,
    this._logger,
    this._apiClient,
    this._deviceInfoService,
    this._signalStore,
  );

  final SecureStorageService _secureStorage;
  final AppLogger _logger;
  final ApiClient _apiClient;
  final DeviceInfoService _deviceInfoService;
  final DriftSignalProtocolStore _signalStore;

  static const String _sessionKeyPrefix = 'e2ee_session_key_';

  Future<void> initializeSessionForPeer(
    String remoteUserId, {
    required PreKeyBundle remoteBundle,
    int deviceId = 1,
  }) async {
    final address = SignalProtocolAddress(remoteUserId, deviceId);
    final builder = SessionBuilder.fromSignalStore(_signalStore, address);

    await builder.processPreKeyBundle(remoteBundle);
    await _signalStore.saveIdentity(address, remoteBundle.getIdentityKey());
  }

  Future<DeviceKeyBundle> ensureDeviceIdentityBundle() async {
    final deviceId = await _deviceInfoService.getOrCreateDeviceId();

    final storedPrivate = await _secureStorage.read(key: StorageKeys.devicePrivateKey);
    final storedPublic = await _secureStorage.read(key: StorageKeys.devicePublicKey);

    if (storedPrivate != null && storedPrivate.isNotEmpty &&
        storedPublic != null && storedPublic.isNotEmpty) {
      final identityKeyPair = await _signalStore.getIdentityKeyPair();
      final signedPreKey = generateSignedPreKey(identityKeyPair, 1);
      final oneTimePreKeys = generatePreKeys(1, 10)
          .map((record) => base64Encode(record.getKeyPair().publicKey.serialize()))
          .toList();

      return DeviceKeyBundle(
        deviceId: deviceId,
        publicKey: storedPublic,
        privateKey: storedPrivate,
        signedPreKey: base64Encode(signedPreKey.getKeyPair().publicKey.serialize()),
        signedPreKeySignature: base64Encode(signedPreKey.signature),
        signedPreKeyId: signedPreKey.id,
        oneTimePreKeys: oneTimePreKeys,
      );
    }

    final privateIdentityKey = generateIdentityKeyPair();
    final signedPreKey = generateSignedPreKey(privateIdentityKey, 1);
    final oneTimePreKeys = generatePreKeys(1, 10)
        .map((record) => base64Encode(record.getKeyPair().publicKey.serialize()))
        .toList();
    final privateKey = base64Encode(privateIdentityKey.getPrivateKey().serialize());
    final publicKey = base64Encode(privateIdentityKey.getPublicKey().serialize());

    await _secureStorage.write(key: StorageKeys.devicePrivateKey, value: privateKey);
    await _secureStorage.write(key: StorageKeys.devicePublicKey, value: publicKey);

    return DeviceKeyBundle(
      deviceId: deviceId,
      publicKey: publicKey,
      privateKey: privateKey,
      signedPreKey: base64Encode(signedPreKey.getKeyPair().publicKey.serialize()),
      signedPreKeySignature: base64Encode(signedPreKey.signature),
      signedPreKeyId: signedPreKey.id,
      oneTimePreKeys: oneTimePreKeys,
    );
  }

  Future<void> registerDeviceIdentity() async {
    final bundle = await ensureDeviceIdentityBundle();
    await _apiClient.post(
      '/crypto/keys/device',
      data: {
        'device_id': bundle.deviceId,
        'public_key': bundle.publicKey,
        'signed_pre_key': bundle.signedPreKey,
        'signed_pre_key_sig': bundle.signedPreKeySignature,
        'signed_pre_key_id': bundle.signedPreKeyId,
        'one_time_pre_keys': bundle.oneTimePreKeys,
      },
    );
  }

  Future<void> storeSessionKey(String conversationId, String base64Key) async {
    await _secureStorage.write(
      key: '$_sessionKeyPrefix$conversationId',
      value: base64Key,
    );
  }

  Future<String?> getSessionKey(String conversationId) async {
    return _secureStorage.read(key: '$_sessionKeyPrefix$conversationId');
  }

  Future<EncryptedData> encryptMessage(
    String conversationId,
    String plaintext,
  ) async {
    try {
      final peerAddress = SignalProtocolAddress(conversationId, 1);
      if (!await _signalStore.containsSession(peerAddress)) {
        throw const EncryptionFailureException(
          'Brak zainicjalizowanej sesji Signal dla konwersacji',
        );
      }

      final sessionCipher = SessionCipher.fromStore(_signalStore, peerAddress);
      final ciphertext = await sessionCipher.encrypt(
        Uint8List.fromList(utf8.encode(plaintext)),
      );

      return EncryptedData(
        ciphertextBase64: base64Encode(ciphertext.serialize()),
        nonceBase64: '',
      );
    } catch (e, st) {
      if (e is EncryptionFailureException) {
        rethrow;
      }

      _logger.e(
        'Błąd szyfrowania wiadomości Signal',
        error: e,
        stackTrace: st,
        module: 'E2eeCrypto',
      );
      throw EncryptionFailureException(
        'Nie można zaszyfrować wiadomości dla konwersacji $conversationId',
      );
    }
  }

  Future<String?> decryptMessage(
    String conversationId,
    String ciphertextBase64,
    String nonceBase64,
  ) async {
    try {
      final peerAddress = SignalProtocolAddress(conversationId, 1);
      final ciphertextBytes = base64Decode(ciphertextBase64);
      final sessionCipher = SessionCipher.fromStore(_signalStore, peerAddress);

      Uint8List plaintext;
      try {
        plaintext = await sessionCipher.decrypt(PreKeySignalMessage(ciphertextBytes));
      } catch (_) {
        plaintext = await sessionCipher.decryptFromSignal(
          SignalMessage.fromSerialized(ciphertextBytes),
        );
      }

      return utf8.decode(plaintext);
    } catch (e, st) {
      _logger.e(
        'Błąd odszyfrowywania wiadomości Signal',
        error: e,
        stackTrace: st,
        module: 'E2eeCrypto',
      );
      return null;
    }
  }
}

@riverpod
E2eeCryptoService e2eeCryptoService(Ref ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final logger = ref.watch(appLoggerProvider);
  final apiClient = ref.watch(apiClientProvider);
  final deviceInfoService = ref.watch(deviceInfoServiceProvider);
  final db = ref.watch(appDatabaseProvider);
  final signalStore = DriftSignalProtocolStore(db);

  return E2eeCryptoService(
    secureStorage,
    logger,
    apiClient,
    deviceInfoService,
    signalStore,
  );
}
