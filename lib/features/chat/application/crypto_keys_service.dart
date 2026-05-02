import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';

class CryptoKeysService {
  static const _privateKeyKey = 'privateKey';
  static const _publicKeyId = 'main'; 

  final SecureStorageService secureStorage;
  final AppDatabase database;

  late SimpleKeyPair _privateKey;
  late SimplePublicKey _publicKey;

  final algorithm = X25519();

  CryptoKeysService({required this.secureStorage, required this.database});

  Future<void> initKeys() async {
    Uint8List? privateBytes;
    Uint8List? publicBytes;

    
    final privateKeyBase64 = await secureStorage.read(key: _privateKeyKey);
    if (privateKeyBase64 != null) {
      privateBytes = base64Decode(privateKeyBase64);
    }

    
    final record = await database.cryptoKeysDao.getKey(_publicKeyId);
    if (record != null) {
      publicBytes = Uint8List.fromList(record.publicKey);
    }

    
    if (privateBytes != null && publicBytes != null) {
      _publicKey = SimplePublicKey(publicBytes, type: KeyPairType.x25519);
      _privateKey = SimpleKeyPairData(
        privateBytes,
        publicKey: _publicKey,
        type: KeyPairType.x25519,
      );
      return;
    }

    
    final keyPair = await algorithm.newKeyPair();
    _privateKey = await keyPair.extract();
    _publicKey = await keyPair.extractPublicKey();

    final privateData = await _privateKey.extractPrivateKeyBytes();

    
    await secureStorage.write(
      key: _privateKeyKey,
      value: base64Encode(privateData),
    );

    
    await database.cryptoKeysDao.insertOrUpdateKey(
      id: _publicKeyId,
      privateKey: Uint8List(0), 
      publicKey: Uint8List.fromList(_publicKey.bytes),
    );
  }

  SimplePublicKey get publicKey => _publicKey;
  SimpleKeyPair get privateKey => _privateKey;
}
