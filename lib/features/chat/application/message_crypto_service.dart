import 'dart:convert';

import 'package:cryptography/cryptography.dart';

class MessageCryptoService {
  final cipher = AesGcm.with256bits();

  // ───────────────────────────────────────────────────
  // Wspólny klucz wyliczony z Diffie–Hellman (X25519)
  // ───────────────────────────────────────────────────
  final SecretKey sharedSecretKey;

  MessageCryptoService({required this.sharedSecretKey});

  // FORMUŁA: version(1B) + nonce(12B) + ciphertext + mac(16B)
  static const int version = 1;

  Future<String> encrypt(Map<String, dynamic> json) async {
    final plainText = utf8.encode(jsonEncode(json));

    final nonce = cipher.newNonce();

    // AAD — chroni metadane
    final aad = utf8.encode('v$version|msg');

    final secretBox = await cipher.encrypt(
      plainText,
      secretKey: sharedSecretKey,
      nonce: nonce,
      aad: aad,
    );

    final combined = <int>[version];
    combined.addAll(nonce);
    combined.addAll(secretBox.cipherText);
    combined.addAll(secretBox.mac.bytes);

    return base64Encode(combined);
  }

  Future<Map<String, dynamic>> decrypt(String base64Str) async {
    final data = base64Decode(base64Str);

    final messageVersion = data.first;
    if (messageVersion != version) {
      throw Exception('Unsupported encryption version: $messageVersion');
    }

    final nonce = data.sublist(1, 13);
    final macBytes = data.sublist(data.length - 16);
    final cipherText = data.sublist(13, data.length - 16);

    final secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes));

    final aad = utf8.encode('v$version|msg');

    final decrypted = await cipher.decrypt(
      secretBox,
      secretKey: sharedSecretKey,
      aad: aad,
    );

    return jsonDecode(utf8.decode(decrypted)) as Map<String, dynamic>;
  }
}
