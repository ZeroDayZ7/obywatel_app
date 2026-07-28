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

  /// Sprawdza, czy klucz jest gotowy w pamięci RAM do złożenia podpisu
  Future<bool> hasActiveKey() async {
    return _activeDeviceKeyPair != null;
  }

  /// Wczytuje i odszyfrowuje klucz prywatny z SecureStorage do RAM przy użyciu PIN-u
  Future<void> loadAndUnlockPrivateKey({
    required List<int> pinBytes,
    required List<int> salt,
  }) async {
    final storage = ref.read(secureStorageProvider);
    final encryptedBase64 = await storage.read(
      key: StorageKeys.devicePrivateKey,
    );

    if (encryptedBase64 == null || encryptedBase64.isEmpty) {
      throw Exception('Brak zapisanego klucza prywatnego na urządzeniu.');
    }

    final encryptedData = base64Decode(encryptedBase64);

    // Odszyfrowanie KEK i klucza prywatnego
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

    // Reinterpretacja bajtów jako Ed25519 KeyPair
    final algorithm = Ed25519();
    _activeDeviceKeyPair = await algorithm.newKeyPairFromSeed(
      clearPrivateKeyBytes.sublist(0, 32),
    );

    // Clean memory
    ref.read(kdfServiceProvider).wipe(clearPrivateKeyBytes);
    _log.i('🔓 Klucz prywatny urządzenia został odblokowany w RAM.');
  }

  /// Czyści klucz prywatny z pamięci RAM (wywoływane np. przy zablokowaniu aplikacji lub logout)
  void lockKey() {
    _activeDeviceKeyPair = null;
    _log.i('🔒 Klucz prywatny został usunięty z RAM.');
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

    // Dekodujemy Base64 na surowe bajty binarne zamiast robić utf8.encode
    final challengeBytes = base64Decode(challenge);

    final algorithm = Ed25519();
    final signature = await algorithm.sign(
      challengeBytes,
      keyPair: _activeDeviceKeyPair!,
    );

    return base64Encode(signature.bytes);
  }

  Future<void> finalizeAndPersist(List<int> pinBytes, List<int> salt) async {
    if (_activeDeviceKeyPair == null) return;
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

      await storage.write(
        key: StorageKeys.devicePrivateKey,
        value: base64Encode(encryptedData),
      );

      final publicKey = await _activeDeviceKeyPair!.extractPublicKey();
      await storage.write(
        key: StorageKeys.devicePublicKey,
        value: base64Encode(publicKey.bytes),
      );

      _log.i('✅ Klucze urządzenia zostały zaszyfrowane i zapisane.');

      ref.read(kdfServiceProvider).wipe(privKeyBytes);

      // ❌ USUNIĘTO: _activeDeviceKeyPair = null;
      // Klucz zostaje w RAM, dopóki registerTrustedDevice nie złoży podpisu!
    } catch (e, st) {
      _log.e('❌ Błąd podczas zapisu kluczy', error: e, stackTrace: st);
      rethrow;
    }
  }
}
