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

  // 1️⃣ Wyprowadzenie KEK z PIN-u i salt
  final kek = await kdf.deriveKeyFromPin(
    pinBytes: utf8.encode(request.pin),
    salt: request.salt,
  );

  // 2️⃣ Odszyfrowanie prywatnego klucza
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

  // 3️⃣ Obliczenie podpisu
  final privateKey = Curve.decodePrivatePoint(privateKeyBytes);
  final signature = Curve.calculateSignature(privateKey, messageBytes);

  // 4️⃣ Wipe wrażliwych danych
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

  /// Sign a message using the user's encrypted key + PIN
  Future<List<int>> signMessage({
    required List<int> message,
    required List<int> encryptedKey,
    required String pin,
    required List<int> salt,
  }) async {
    return await _worker.compute(
      SignRequest(
        message: message,
        encryptedPrivateKey: encryptedKey,
        pin: pin,
        salt: salt,
      ),
    );
  }

  Future<List<int>> generateAndHoldKeyPair() async {
    final algorithm = Ed25519();
    _activeDeviceKeyPair = await algorithm.newKeyPair();
    final publicKey = await _activeDeviceKeyPair!.extractPublicKey();
    return publicKey.bytes;
  }

  // Podpisuje challenge używając klucza z RAM
  Future<String> signWithActiveKey(String challenge) async {
    if (_activeDeviceKeyPair == null) throw Exception('No active key');

    final algorithm = Ed25519();
    final signature = await algorithm.sign(
      utf8.encode(challenge),
      keyPair: _activeDeviceKeyPair!,
    );
    return base64Encode(signature.bytes);
  }

  @pragma('vm:entry-point')
  Future<List<int>> secureSignWorker(SignRequest request) async {
    final kdf = KdfService(
      AppLogger(),
    ); // tutaj w workerze możesz wstrzyknąć logger
    // Wyprowadzenie KEK z PIN-u + salt
    final kek = await kdf.deriveKeyFromPin(
      pinBytes: utf8.encode(request.pin),
      salt: request.salt,
    );

    // Odszyfrowanie klucza prywatnego
    final secretBox = SecretBox.fromConcatenation(
      request.encryptedPrivateKey,
      nonceLength: 12,
      macLength: 16,
    );

    final clearPrivateKeyBytes = await AesGcm.with256bits().decrypt(
      secretBox,
      secretKey: kek,
    );

    // Konwersja do Uint8List
    final uint8PrivateKey = Uint8List.fromList(clearPrivateKeyBytes);
    final uint8Message = Uint8List.fromList(request.message);

    // Obliczenie podpisu (libsignal)
    final privateKey = Curve.decodePrivatePoint(uint8PrivateKey);
    final signature = Curve.calculateSignature(privateKey, uint8Message);

    // Wipe KEK i clearPrivateKeyBytes
    kdf.wipe(clearPrivateKeyBytes);
    kdf.wipe(uint8PrivateKey);
    return signature;
  }

  // Na koniec setupu: szyfrujemy i zapisujemy klucz
  Future<void> finalizeAndPersist(String pin, List<int> salt) async {
    if (_activeDeviceKeyPair == null) return;

    try {
      final privateKeyData = await _activeDeviceKeyPair!.extract();
      final privKeyBytes = privateKeyData.bytes;

      // Wyprowadzenie KEK z PIN-u
      final kek = await ref
          .read(kdfServiceProvider)
          .deriveKeyFromPin(pinBytes: utf8.encode(pin), salt: salt);

      // Szyfrowanie klucza prywatnego
      final secretBox = await AesGcm.with256bits().encrypt(
        privKeyBytes,
        secretKey: kek,
      );

      // Połączenie Nonce + CipherText + MAC
      final encryptedData = secretBox.concatenation();

      // Zapis do Secure Storage
      final storage = ref.read(secureStorageProvider);
      await storage.write(
        key: StorageKeys.devicePrivateKey,
        value: base64Encode(encryptedData),
      );

      // Zapis klucza publicznego
      final publicKey = await _activeDeviceKeyPair!.extractPublicKey();
      await storage.write(
        key: StorageKeys.devicePublicKey,
        value: base64Encode(publicKey.bytes),
      );

      _log.i('✅ Klucze urządzenia zostały zaszyfrowane i zapisane.');

      // Wipe KEK i prywatny klucz
      ref.read(kdfServiceProvider).wipe(privKeyBytes);
      _activeDeviceKeyPair = null;
    } catch (e, st) {
      _log.e('❌ Błąd podczas zapisu kluczy', error: e, stackTrace: st);
      rethrow;
    }
  }
}
