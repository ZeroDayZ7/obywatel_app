import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:isolate_manager/isolate_manager.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:obywatel_plus/core/crypto/kdf_service.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crypto_service.g.dart';

class SignRequest {
  final List<int> message;
  final List<int> encryptedPrivateKey;
  final String pin;
  final List<int> salt;

  SignRequest({
    required this.message,
    required this.encryptedPrivateKey,
    required this.pin,
    required this.salt,
  });
}

@pragma('vm:entry-point')
Future<List<int>> secureSignWorker(SignRequest request) async {
  final kdf = KdfService(AppLogger());
  final kek = await kdf.deriveKeyFromPin(
    pinBytes: utf8.encode(request.pin),
    salt: request.salt,
  );
  
  final secretBox = SecretBox.fromConcatenation(
    request.encryptedPrivateKey,
    nonceLength: 12,
    macLength: 16,
  );
  
  final clearPrivateKeyBytes = await AesGcm.with256bits().decrypt(
    secretBox,
    secretKey: kek,
  );

  final privateKeyBytes = Uint8List.fromList(clearPrivateKeyBytes);
  final messageBytes = Uint8List.fromList(request.message);

  final privateKey = Curve.decodePrivatePoint(privateKeyBytes);
  final signature = Curve.calculateSignature(privateKey, messageBytes);
  
  kdf.wipe(clearPrivateKeyBytes);
  kdf.wipe(privateKeyBytes);

  return signature;
}

@Riverpod(keepAlive: true)
class CryptoService extends _$CryptoService {
  late final IsolateManager<List<int>, SignRequest> _worker;
  SimpleKeyPair? _activeDeviceKeyPair;
  AppLogger get _log => ref.read(appLoggerProvider);

  @override
  void build() {
    _worker = IsolateManager.create(
      secureSignWorker,
      workerName: 'crypto_signing_worker',
      concurrent: 1,
    );
    ref.onDispose(() => _worker.stop());
  }

  Future<bool> hasActiveKey() async {
    return _activeDeviceKeyPair != null;
  }

  Future<void> loadAndUnlockPrivateKey({
    required List<int> pinBytes,
    required List<int> salt,
  }) async {
    final storage = ref.read(secureStorageProvider);
    final encryptedBase64 = await storage.read(
      key: StorageKeys.devicePrivateKey,
    );

    if (encryptedBase64 == null || encryptedBase64.isEmpty) {
      _log.e('[CryptoService] Brak zapisanego klucza prywatnego w SecureStorage.');
      throw Exception('Brak zapisanego klucza prywatnego na urządzeniu.');
    }

    try {
      final encryptedData = base64Decode(encryptedBase64);
      
      final kek = await ref
          .read(kdfServiceProvider)
          .deriveKeyFromPin(pinBytes: pinBytes, salt: salt);

      final secretBox = SecretBox.fromConcatenation(
        encryptedData,
        nonceLength: 12,
        macLength: 16,
      );

      final clearPrivateKeyBytes = await AesGcm.with256bits().decrypt(
        secretBox,
        secretKey: kek,
      );

      final seed = clearPrivateKeyBytes.sublist(0, 32);
      final algorithm = Ed25519();
      _activeDeviceKeyPair = await algorithm.newKeyPairFromSeed(seed);

      ref.read(kdfServiceProvider).wipe(clearPrivateKeyBytes);
      _log.i('[CryptoService] Klucz prywatny został pomyślnie odblokowany i załadowany do RAM.');
    } catch (e, st) {
      _log.e('[CryptoService] Błąd podczas odszyfrowywania klucza prywatnego', error: e, stackTrace: st);
      rethrow;
    }
  }

  void lockKey() {
    _activeDeviceKeyPair = null;
    _log.i('[CryptoService] Klucz prywatny został usunięty z RAM.');
  }

  Future<List<int>> signMessage({
    required List<int> message,
    required List<int> encryptedKey,
    required String pin,
    required List<int> salt,
  }) async {
    try {
      final result = await _worker.compute(
        SignRequest(
          message: message,
          encryptedPrivateKey: encryptedKey,
          pin: pin,
          salt: salt,
        ),
      );
      return result;
    } catch (e, st) {
      _log.e('[CryptoService] Błąd podczas podpisywania wiadomości w workerze', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<List<int>> generateAndHoldKeyPair() async {
    final algorithm = Ed25519();
    _activeDeviceKeyPair = await algorithm.newKeyPair();

    final publicKey = await _activeDeviceKeyPair!.extractPublicKey();
    return publicKey.bytes;
  }

  Future<String> signWithActiveKey(
    String challenge, {
    String domain = 'obywatel.gov.pl',
  }) async {
    if (_activeDeviceKeyPair == null) {
      _log.e('[CryptoService] Brak aktywnego klucza w RAM podczas próby podpisania challenge\'a.');
      throw Exception('No active key');
    }

    try {
      final normalizedChallenge = base64.normalize(challenge);
      final challengeBytes = base64.decode(normalizedChallenge);

      final prefixBytes = utf8.encode('$domain:');
      final payloadBytes = <int>[...prefixBytes, ...challengeBytes];

      final algorithm = Ed25519();
      final signature = await algorithm.sign(
        payloadBytes,
        keyPair: _activeDeviceKeyPair!,
      );

      return base64Encode(signature.bytes);
    } catch (e, st) {
      _log.e('[CryptoService] Błąd podczas podpisywania challenge\'a', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> finalizeAndPersist(List<int> pinBytes, List<int> salt) async {
    if (_activeDeviceKeyPair == null) {
      _log.e('[CryptoService] _activeDeviceKeyPair jest null podczas finalizeAndPersist.');
      return;
    }

    try {
      final privateKeyData = await _activeDeviceKeyPair!.extract();
      final privKeyBytes = privateKeyData.bytes;

      final kek = await ref
          .read(kdfServiceProvider)
          .deriveKeyFromPin(pinBytes: pinBytes, salt: salt);

      final secretBox = await AesGcm.with256bits().encrypt(
        privKeyBytes,
        secretKey: kek,
      );

      final encryptedData = secretBox.concatenation();
      final storage = ref.read(secureStorageProvider);
      final encryptedBase64 = base64Encode(encryptedData);

      await storage.write(
        key: StorageKeys.devicePrivateKey,
        value: encryptedBase64,
      );

      final publicKey = await _activeDeviceKeyPair!.extractPublicKey();
      final pubKeyBase64 = base64Encode(publicKey.bytes);

      await storage.write(
        key: StorageKeys.devicePrivateKey,
        value: pubKeyBase64,
      );

      ref.read(kdfServiceProvider).wipe(privKeyBytes);
      _log.i('[CryptoService] Klucze urządzenia zostały zaszyfrowane i zapisane w SecureStorage.');
    } catch (e, st) {
      _log.e('[CryptoService] Błąd podczas zapisu kluczy', error: e, stackTrace: st);
      rethrow;
    }
  }
}