import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:hive/hive.dart';

class CryptoKeysService {
  static const _privateKeyKey = 'privateKey';
  static const _publicKeyKey = 'publicKey';

  final SecureStorageService secureStorage;
  final Box? hiveBox;

  late SimpleKeyPair _privateKey;
  late SimplePublicKey _publicKey;

  final algorithm = X25519();

  CryptoKeysService({required this.secureStorage, this.hiveBox});

  Future<void> initKeys() async {
    Uint8List? privateBytes;
    Uint8List? publicBytes;

    // ---- Odczyt klucza prywatnego z SecureStorage (BASE64!) ----
    final privateKeyBase64 = await secureStorage.read(key: _privateKeyKey);
    if (privateKeyBase64 != null) {
      privateBytes = base64Decode(privateKeyBase64);
    }

    // ---- Odczyt publicznego z Hive ----
    if (hiveBox != null && hiveBox!.containsKey(_publicKeyKey)) {
      publicBytes = hiveBox!.get(_publicKeyKey) as Uint8List;
    }

    // ---- Jeśli istnieją oba klucze → ładujemy ----
    if (privateBytes != null && publicBytes != null) {
      _publicKey = SimplePublicKey(publicBytes, type: KeyPairType.x25519);

      _privateKey = SimpleKeyPairData(
        privateBytes,
        publicKey: _publicKey,
        type: KeyPairType.x25519,
      );
      return;
    }

    // ---- Jeśli kluczy nie ma → generujemy ----
    final keyPair = await algorithm.newKeyPair();
    _privateKey = await keyPair.extract();
    _publicKey = await keyPair.extractPublicKey();

    final privateData = await _privateKey.extractPrivateKeyBytes();

    // ---- Zapis prywatnego klucza (BASE64!) ----
    await secureStorage.write(
      key: _privateKeyKey,
      value: base64Encode(privateData),
    );

    // ---- Zapis publicznego klucza (nie trzeba kodować) ----
    if (hiveBox != null) {
      await hiveBox!.put(_publicKeyKey, _publicKey.bytes);
    }
  }

  SimplePublicKey get publicKey => _publicKey;
  SimpleKeyPair get privateKey => _privateKey;
}
