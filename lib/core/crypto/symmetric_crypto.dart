import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'symmetric_crypto.g.dart';

@Riverpod(keepAlive: true)
SymmetricCrypto symmetricCrypto(Ref ref) {
  return SymmetricCrypto();
}

///
/// ENTERPRISE Symmetric Crypto Service
///
/// Odpowiedzialność:
/// - Szyfrowanie / deszyfrowanie danych binarnych
/// - Algorytm: AES-256-GCM
///
///
class SymmetricCrypto {
  static final _algorithm = AesGcm.with256bits();
  static final _log = Logger();

  /// ============================================
  /// 🔐 ENCRYPT
  /// ============================================

  /// Szyfruje dane binarne
  ///
  /// Zwraca base64(nonce + ciphertext + mac)
  Future<String> encryptBytes({
    required List<int> clearBytes,
    required SecretKey secretKey,
    List<int>? aad,
  }) async {
    if (clearBytes.isEmpty) {
      throw ArgumentError('clearBytes cannot be empty');
    }

    try {
      final nonce = _algorithm.newNonce();

      final box = await _algorithm.encrypt(
        clearBytes,
        secretKey: secretKey,
        nonce: nonce,
        aad: aad ?? [],
      );

      return base64Encode(box.concatenation());
    } catch (e, st) {
      _log.e('AES encryptBytes failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Szyfruje tekst UTF-8
  Future<String> encryptString({
    required String clearText,
    required SecretKey secretKey,
    List<int>? aad,
  }) async {
    return encryptBytes(
      clearBytes: utf8.encode(clearText),
      secretKey: secretKey,
      aad: aad,
    );
  }

  /// ============================================
  /// 🔓 DECRYPT
  /// ============================================

  /// Deszyfruje dane binarne
  ///
  /// Oczekuje base64(nonce + ciphertext + mac)
  Future<Uint8List> decryptBytes({
    required String encryptedBase64,
    required SecretKey secretKey,
    List<int>? aad,
  }) async {
    try {
      final combined = base64Decode(encryptedBase64);

      final box = SecretBox.fromConcatenation(
        combined,
        nonceLength: _algorithm.nonceLength,
        macLength: _algorithm.macAlgorithm.macLength,
      );

      final clear = await _algorithm.decrypt(
        box,
        secretKey: secretKey,
        aad: aad ?? [],
      );

      return Uint8List.fromList(clear);
    } on SecretBoxAuthenticationError {
      _log.w('AES authentication failed (wrong key or corrupted data)');
      throw Exception('Invalid encryption key or corrupted data');
    } catch (e, st) {
      _log.e('AES decryptBytes failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Deszyfruje tekst UTF-8
  Future<String> decryptString({
    required String encryptedBase64,
    required SecretKey secretKey,
    List<int>? aad,
  }) async {
    final bytes = await decryptBytes(
      encryptedBase64: encryptedBase64,
      secretKey: secretKey,
      aad: aad,
    );

    return utf8.decode(bytes);
  }

  /// ============================================
  /// 🔁 RE-WRAP (PIN CHANGE USE CASE)
  /// ============================================

  /// Przepisuje zaszyfrowane dane z jednego klucza na drugi
  ///
  /// NIE odsłania plaintextu poza RAM
  Future<String> reEncrypt({
    required String encryptedBase64,
    required SecretKey oldKey,
    required SecretKey newKey,
    List<int>? aad,
  }) async {
    final clear = await decryptBytes(
      encryptedBase64: encryptedBase64,
      secretKey: oldKey,
      aad: aad,
    );

    final reEncrypted = await encryptBytes(
      clearBytes: clear,
      secretKey: newKey,
      aad: aad,
    );

    // Czyścimy RAM
    clear.fillRange(0, clear.length, 0);

    return reEncrypted;
  }

  Future<SecretKey> generateMasterKey() async {
    final algorithm = AesGcm.with256bits();
    return algorithm.newSecretKey();
  }
}
