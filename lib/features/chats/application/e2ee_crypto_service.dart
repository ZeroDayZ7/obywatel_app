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

class SignalCiphertextEnvelope {
  final int type;
  final String ciphertext;
  final String senderDeviceId;
  final String recipientUserId;
  final String recipientDeviceId;

  const SignalCiphertextEnvelope({
    required this.type,
    required this.ciphertext,
    required this.senderDeviceId,
    required this.recipientUserId,
    required this.recipientDeviceId,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'ciphertext': ciphertext,
    'senderDeviceId': senderDeviceId,
    'recipientUserId': recipientUserId,
    'recipientDeviceId': recipientDeviceId,
  };

  factory SignalCiphertextEnvelope.fromJson(Map<String, dynamic> json) {
    final typeValue = json['type'] ?? json['signal_message_type'] ?? 1;
    return SignalCiphertextEnvelope(
      type: typeValue is int
          ? typeValue
          : int.tryParse(typeValue.toString()) ?? 1,
      ciphertext: (json['ciphertext'] ?? '').toString(),
      senderDeviceId: (json['senderDeviceId'] ?? json['sender_device_id'] ?? '')
          .toString(),
      recipientUserId:
          (json['recipientUserId'] ?? json['recipient_user_id'] ?? '')
              .toString(),
      recipientDeviceId:
          (json['recipientDeviceId'] ?? json['recipient_device_id'] ?? '1')
              .toString(),
    );
  }
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

  static int _readIntValue(
    Map<String, dynamic> json,
    List<String> keys, {
    int fallback = 0,
  }) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) continue;
      if (value is int) return value;
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;
      }
    }
    return fallback;
  }

  static Uint8List? _readBytesValue(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) continue;
      if (value is String && value.isNotEmpty) {
        return base64Decode(value);
      }
      if (value is List) {
        return Uint8List.fromList(
          value.map((item) {
            if (item is int) return item;
            return int.tryParse(item.toString()) ?? 0;
          }).toList(),
        );
      }
    }
    return null;
  }

  static PreKeyBundle fromPreKeyBundleJson(Map<String, dynamic> json) {
    final registrationId = _readIntValue(json, [
      'registrationId',
      'registration_id',
    ], fallback: 0);
    final deviceId = _readIntValue(json, [
      'deviceId',
      'device_id',
    ], fallback: 1);
    final preKeyId = _readIntValue(json, [
      'preKeyId',
      'pre_key_id',
      'oneTimePreKeyId',
      'one_time_pre_key_id',
    ], fallback: 0);
    final signedPreKeyId = _readIntValue(json, [
      'signedPreKeyId',
      'signed_pre_key_id',
    ], fallback: 1);

    final identityKeyBytes = _readBytesValue(json, [
      'identityKey',
      'identity_key',
    ]);
    final signedPreKeyPublicBytes = _readBytesValue(json, [
      'signedPreKeyPublic',
      'signed_pre_key_public',
      'signedPreKey', // <-- DODANE: alias z Go
      'signed_pre_key', // <-- DODANE: alias z Go
    ]);
    final signedPreKeySignatureBytes = _readBytesValue(json, [
      'signedPreKeySignature',
      'signed_pre_key_signature',
      'signedPreKeySig', // <-- DODANE: alias z Go
      'signed_pre_key_sig', // <-- DODANE: alias z Go
    ]);
    final preKeyPublicBytes = _readBytesValue(json, [
      'preKeyPublic',
      'pre_key_public',
      'oneTimePreKey', // <-- DODANE: alias z Go
      'one_time_pre_key', // <-- DODANE: alias z Go
    ]);

    if (identityKeyBytes == null ||
        signedPreKeyPublicBytes == null ||
        signedPreKeySignatureBytes == null) {
      throw const FormatException(
        'Missing required Signal pre-key bundle fields',
      );
    }

    final identityKey = IdentityKey.fromBytes(identityKeyBytes, 0);
    final signedPreKeyPublic = Curve.decodePoint(signedPreKeyPublicBytes, 0);
    final preKeyPublic = preKeyPublicBytes == null
        ? null
        : Curve.decodePoint(preKeyPublicBytes, 0);

    return PreKeyBundle(
      registrationId,
      deviceId,
      preKeyId == 0 ? null : preKeyId,
      preKeyPublic,
      signedPreKeyId,
      signedPreKeyPublic,
      signedPreKeySignatureBytes,
      identityKey,
    );
  }

  Future<PreKeyBundle> fetchRemotePreKeyBundle(String remoteUserId) async {
    final response = await _apiClient.get('/crypto/keys/prekeys/$remoteUserId');
    final payload = response.data;

    if (payload is! Map) {
      throw const FormatException('Invalid remote pre-key bundle payload');
    }

    final map = Map<String, dynamic>.from(payload);
    return fromPreKeyBundleJson(map);
  }

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

  Future<void> ensureSessionForPeer(
    String remoteUserId, {
    int deviceId = 1,
  }) async {
    final address = SignalProtocolAddress(remoteUserId, deviceId);
    final sessionExists = await _signalStore.containsSession(address);
    if (sessionExists) {
      return;
    }

    final remoteBundle = await fetchRemotePreKeyBundle(remoteUserId);
    await initializeSessionForPeer(
      remoteUserId,
      remoteBundle: remoteBundle,
      deviceId: deviceId,
    );
  }

  Future<DeviceKeyBundle> ensureDeviceIdentityBundle() async {
    final deviceId = await _deviceInfoService.getOrCreateDeviceId();

    final storedPrivate = await _secureStorage.read(
      key: StorageKeys.devicePrivateKey,
    );
    final storedPublic = await _secureStorage.read(
      key: StorageKeys.devicePublicKey,
    );

    if (storedPrivate != null &&
        storedPrivate.isNotEmpty &&
        storedPublic != null &&
        storedPublic.isNotEmpty) {
      final identityKeyPair = await _signalStore.getIdentityKeyPair();
      final signedPreKey = generateSignedPreKey(identityKeyPair, 1);
      final oneTimePreKeys = generatePreKeys(1, 10)
          .map(
            (record) => base64Encode(record.getKeyPair().publicKey.serialize()),
          )
          .toList();

      return DeviceKeyBundle(
        deviceId: deviceId,
        publicKey: storedPublic,
        privateKey: storedPrivate,
        signedPreKey: base64Encode(
          signedPreKey.getKeyPair().publicKey.serialize(),
        ),
        signedPreKeySignature: base64Encode(signedPreKey.signature),
        signedPreKeyId: signedPreKey.id,
        oneTimePreKeys: oneTimePreKeys,
      );
    }

    final privateIdentityKey = generateIdentityKeyPair();
    final signedPreKey = generateSignedPreKey(privateIdentityKey, 1);
    final oneTimePreKeys = generatePreKeys(1, 10)
        .map(
          (record) => base64Encode(record.getKeyPair().publicKey.serialize()),
        )
        .toList();
    final privateKey = base64Encode(
      privateIdentityKey.getPrivateKey().serialize(),
    );
    final publicKey = base64Encode(
      privateIdentityKey.getPublicKey().serialize(),
    );

    await _secureStorage.write(
      key: StorageKeys.devicePrivateKey,
      value: privateKey,
    );
    await _secureStorage.write(
      key: StorageKeys.devicePublicKey,
      value: publicKey,
    );

    return DeviceKeyBundle(
      deviceId: deviceId,
      publicKey: publicKey,
      privateKey: privateKey,
      signedPreKey: base64Encode(
        signedPreKey.getKeyPair().publicKey.serialize(),
      ),
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

  Future<SignalCiphertextEnvelope> encryptOutboundMessage(
    String recipientUserId,
    String plaintext, {
    int recipientDeviceId = 1,
    String? senderDeviceId,
  }) async {
    try {
      final address = SignalProtocolAddress(recipientUserId, recipientDeviceId);
      if (!await _signalStore.containsSession(address)) {
        final remoteBundle = await fetchRemotePreKeyBundle(recipientUserId);
        await initializeSessionForPeer(
          recipientUserId,
          remoteBundle: remoteBundle,
          deviceId: recipientDeviceId,
        );
      }

      final sessionCipher = SessionCipher.fromStore(_signalStore, address);
      final cipherText = await sessionCipher.encrypt(
        Uint8List.fromList(utf8.encode(plaintext)),
      );

      return SignalCiphertextEnvelope(
        type: cipherText.getType(),
        ciphertext: base64Encode(cipherText.serialize()),
        senderDeviceId:
            senderDeviceId ?? await _deviceInfoService.getOrCreateDeviceId(),
        recipientUserId: recipientUserId,
        recipientDeviceId: recipientDeviceId.toString(),
      );
    } catch (e, st) {
      _logger.e(
        'Błąd szyfrowania wiadomości Signal outbound',
        error: e,
        stackTrace: st,
        module: 'E2eeCrypto',
      );
      throw EncryptionFailureException(
        'Nie można zaszyfrować wiadomości dla użytkownika $recipientUserId',
      );
    }
  }

  Future<String> decryptInboundMessage({
    required String senderUserId,
    required String senderDeviceId,
    required String ciphertextBase64,
    required int type,
  }) async {
    try {
      final address = SignalProtocolAddress(
        senderUserId,
        int.tryParse(senderDeviceId) ?? 1,
      );
      final ciphertextBytes = base64Decode(ciphertextBase64);
      final sessionCipher = SessionCipher.fromStore(_signalStore, address);

      final Uint8List plaintext;
      if (type == CiphertextMessage.prekeyType) {
        plaintext = await sessionCipher.decrypt(
          PreKeySignalMessage(ciphertextBytes),
        );
      } else {
        plaintext = await sessionCipher.decryptFromSignal(
          SignalMessage.fromSerialized(ciphertextBytes),
        );
      }

      return utf8.decode(plaintext);
    } catch (e, st) {
      _logger.e(
        'Błąd odszyfrowywania wiadomości Signal inbound',
        error: e,
        stackTrace: st,
        module: 'E2eeCrypto',
      );
      throw EncryptionFailureException(
        'Nie można odszyfrować wiadomości od użytkownika $senderUserId',
      );
    }
  }

  Future<EncryptedData> encryptMessage(
    String conversationId,
    String plaintext,
  ) async {
    try {
      final envelope = await encryptOutboundMessage(conversationId, plaintext);
      return EncryptedData(
        ciphertextBase64: envelope.ciphertext,
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
      final ciphertextBytes = base64Decode(ciphertextBase64);
      final peerAddress = SignalProtocolAddress(conversationId, 1);
      final sessionCipher = SessionCipher.fromStore(_signalStore, peerAddress);

      Uint8List plaintext;
      try {
        plaintext = await sessionCipher.decrypt(
          PreKeySignalMessage(ciphertextBytes),
        );
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
