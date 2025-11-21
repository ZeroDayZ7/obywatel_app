import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

class MessageCryptoService {
  final cipher = AesGcm.with256bits();
  final secretKey = SecretKey(
    Uint8List.fromList(List.generate(32, (i) => i)),
  ); // tymczasowy klucz 32-bajtowy

  MessageCryptoService();

  Future<String> encrypt(Map<String, dynamic> json) async {
    final plainText = utf8.encode(jsonEncode(json));
    final nonce = cipher.newNonce(); // 12-bajtowy nonce
    final secretBox = await cipher.encrypt(
      plainText,
      secretKey: secretKey,
      nonce: nonce,
    );
    // Zwracamy base64: nonce + ciphertext + mac
    final combined = <int>[];
    combined.addAll(nonce);
    combined.addAll(secretBox.cipherText);
    combined.addAll(secretBox.mac.bytes);
    return base64Encode(combined);
  }

  Future<Map<String, dynamic>> decrypt(String base64Str) async {
    final bytes = base64Decode(base64Str);
    final nonce = bytes.sublist(0, 12);
    final macBytes = bytes.sublist(bytes.length - 16);
    final cipherText = bytes.sublist(12, bytes.length - 16);

    final secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes));

    final decrypted = await cipher.decrypt(secretBox, secretKey: secretKey);

    return jsonDecode(utf8.decode(decrypted)) as Map<String, dynamic>;
  }
}
