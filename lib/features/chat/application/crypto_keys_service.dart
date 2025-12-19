import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';

class CryptoKeysService {
  static const _privateKeyKey = 'privateKey';
  static const _publicKeyId = 'main'; // id w tabeli Drift

  final SecureStorageService secureStorage;
  final AppDatabase database;

  late SimpleKeyPair _privateKey;
  late SimplePublicKey _publicKey;

  final algorithm = X25519();

  CryptoKeysService({required this.secureStorage, required this.database});

  Future<void> initKeys() async {
    Uint8List? privateBytes;
    Uint8List? publicBytes;

    // ---- Odczyt prywatnego klucza z SecureStorage (BASE64!) ----
    final privateKeyBase64 = await secureStorage.read(key: _privateKeyKey);
    if (privateKeyBase64 != null) {
      privateBytes = base64Decode(privateKeyBase64);
    }

    // ---- Odczyt publicznego z Drift ----
    final record = await database.cryptoKeysDao.getKey(_publicKeyId);
    if (record != null) {
      publicBytes = Uint8List.fromList(record.publicKey);
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

    // ---- Jeśli nie ma kluczy → generujemy ----
    final keyPair = await algorithm.newKeyPair();
    _privateKey = await keyPair.extract();
    _publicKey = await keyPair.extractPublicKey();

    final privateData = await _privateKey.extractPrivateKeyBytes();

    // ---- Zapis prywatnego klucza (SecureStorage, BASE64!) ----
    await secureStorage.write(
      key: _privateKeyKey,
      value: base64Encode(privateData),
    );

    // ---- Zapis publicznego klucza (Drift) ----
    await database.cryptoKeysDao.insertOrUpdateKey(
      id: _publicKeyId,
      privateKey: Uint8List(0), // opcjonalnie pusta
      publicKey: Uint8List.fromList(_publicKey.bytes),
    );
  }

  SimplePublicKey get publicKey => _publicKey;
  SimpleKeyPair get privateKey => _privateKey;
}
