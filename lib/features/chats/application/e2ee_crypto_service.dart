import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'e2ee_crypto_service.g.dart';

/// Wynik operacji szyfrowania zawierający zaszyfrowane bajty oraz nonce (IV).
class EncryptedData {
  final String ciphertextBase64;
  final String nonceBase64;

  const EncryptedData({
    required this.ciphertextBase64,
    required this.nonceBase64,
  });
}

/// Funkcja pomocnicza do pobierania algorytmu AES-GCM (256-bit).
AesGcm getAesGcmAlgorithm() => AesGcm.with256bits();

/// Szyfruje tekst jawny przy użyciu dostarczonego klucza AES w formacie Raw (32 bajty).
Future<EncryptedData> encryptPayload(
  String plaintext,
  List<int> secretKeyBytes,
) async {
  final algorithm = getAesGcmAlgorithm();
  final secretKey = SecretKey(secretKeyBytes);
  final nonce = algorithm.newNonce();

  final secretBox = await algorithm.encrypt(
    utf8.encode(plaintext),
    secretKey: secretKey,
    nonce: nonce,
  );

  return EncryptedData(
    ciphertextBase64: base64Encode(secretBox.cipherText + secretBox.mac.bytes),
    nonceBase64: base64Encode(secretBox.nonce),
  );
}

/// Odszyfrowuje tekst z zaszyfrowanego ładunku Base64 oraz nonce Base64.
Future<String> decryptPayload(
  String ciphertextBase64,
  String nonceBase64,
  List<int> secretKeyBytes,
) async {
  final algorithm = getAesGcmAlgorithm();
  final secretKey = SecretKey(secretKeyBytes);

  final rawCiphertextWithMac = base64Decode(ciphertextBase64);
  final nonce = base64Decode(nonceBase64);

  // MAC w AES-GCM ma długość 16 bajtów (128 bitów) na końcu ciphertextu
  final macLength = 16;
  final cipherText = rawCiphertextWithMac.sublist(
    0,
    rawCiphertextWithMac.length - macLength,
  );
  final macBytes = rawCiphertextWithMac.sublist(
    rawCiphertextWithMac.length - macLength,
  );

  final secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes));

  final clearTextBytes = await algorithm.decrypt(
    secretBox,
    secretKey: secretKey,
  );

  return utf8.decode(clearTextBytes);
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

class E2eeCryptoService {
  final SecureStorageService _secureStorage;
  final AppLogger _logger;
  final ApiClient _apiClient;
  final DeviceInfoService _deviceInfoService;

  static const String _sessionKeyPrefix = 'e2ee_session_key_';

  const E2eeCryptoService(
    this._secureStorage,
    this._logger,
    this._apiClient,
    this._deviceInfoService,
  );

  Future<DeviceKeyBundle> ensureDeviceIdentityBundle() async {
    final deviceId = await _deviceInfoService.getOrCreateDeviceId();

    final storedPrivate = await _secureStorage.read(key: StorageKeys.devicePrivateKey);
    final storedPublic = await _secureStorage.read(key: StorageKeys.devicePublicKey);

    if (storedPrivate != null && storedPrivate.isNotEmpty &&
        storedPublic != null && storedPublic.isNotEmpty) {
      final signedPreKey = base64Encode(
        List<int>.generate(32, (_) => Random.secure().nextInt(256)),
      );
      final signedPreKeySignature = base64Encode(
        sha256.convert(utf8.encode('$deviceId:$signedPreKey')).bytes,
      );

      return DeviceKeyBundle(
        deviceId: deviceId,
        publicKey: storedPublic,
        privateKey: storedPrivate,
        signedPreKey: signedPreKey,
        signedPreKeySignature: signedPreKeySignature,
        signedPreKeyId: 1,
        oneTimePreKeys: const [],
      );
    }

    final privateKeyBytes = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    final privateKey = base64Encode(privateKeyBytes);
    final publicKey = base64Encode(
      sha256.convert(utf8.encode(privateKey)).bytes,
    );

    await _secureStorage.write(key: StorageKeys.devicePrivateKey, value: privateKey);
    await _secureStorage.write(key: StorageKeys.devicePublicKey, value: publicKey);

    final signedPreKey = base64Encode(
      List<int>.generate(32, (_) => Random.secure().nextInt(256)),
    );
    final signedPreKeySignature = base64Encode(
      sha256.convert(utf8.encode('$deviceId:$signedPreKey')).bytes,
    );

    return DeviceKeyBundle(
      deviceId: deviceId,
      publicKey: publicKey,
      privateKey: privateKey,
      signedPreKey: signedPreKey,
      signedPreKeySignature: signedPreKeySignature,
      signedPreKeyId: 1,
      oneTimePreKeys: const [],
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

  /// Zapisuje klucz sesyjny dla danej konwersacji w bezpiecznej pamięci.
  Future<void> storeSessionKey(String conversationId, String base64Key) async {
    await _secureStorage.write(
      key: '$_sessionKeyPrefix$conversationId',
      value: base64Key,
    );
  }

  /// Pobiera klucz sesyjny dla konwersacji.
  Future<String?> getSessionKey(String conversationId) async {
    return _secureStorage.read(key: '$_sessionKeyPrefix$conversationId');
  }

  /// Szyfruje tekst wiadomości z użyciem klucza dedykowanego dla konwersacji.
  Future<EncryptedData?> encryptMessage(
    String conversationId,
    String plaintext,
  ) async {
    try {
      final keyBase64 = await getSessionKey(conversationId);
      if (keyBase64 == null) {
        _logger.e(
          'Brak klucza sesyjnego dla konwersacji: $conversationId',
          module: 'E2eeCrypto',
        );
        return null;
      }

      final keyBytes = base64Decode(keyBase64);
      return await encryptPayload(plaintext, keyBytes);
    } catch (e, st) {
      _logger.e(
        'Błąd szyfrowania wiadomości',
        error: e,
        stackTrace: st,
        module: 'E2eeCrypto',
      );
      return null;
    }
  }

  /// Odszyfrowuje wiadomość z użyciem klucza konwersacji.
  Future<String?> decryptMessage(
    String conversationId,
    String ciphertextBase64,
    String nonceBase64,
  ) async {
    try {
      final keyBase64 = await getSessionKey(conversationId);
      if (keyBase64 == null) {
        _logger.e(
          'Brak klucza sesyjnego dla konwersacji: $conversationId',
          module: 'E2eeCrypto',
        );
        return null;
      }

      final keyBytes = base64Decode(keyBase64);
      return await decryptPayload(ciphertextBase64, nonceBase64, keyBytes);
    } catch (e, st) {
      _logger.e(
        'Błąd odszyfrowywania wiadomości',
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

  return E2eeCryptoService(
    secureStorage,
    logger,
    apiClient,
    deviceInfoService,
  );
}
