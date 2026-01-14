import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'asymmetric_crypto.g.dart';

@Riverpod(keepAlive: true)
AsymmetricCrypto asymmetricCrypto(Ref ref) {
  return AsymmetricCrypto();
}

///
/// ENTERPRISE Asymmetric Cryptography Service
///
/// Responsibility:
/// - Generating asymmetric key pairs
/// - Signing data
/// - Verifying signatures
///
/// Algorithm:
/// - Ed25519
///
/// Non-responsibility:
/// - No key storage
/// - No encryption
/// - No PIN or KDF handling
///
class AsymmetricCrypto {
  static final _algorithm = Ed25519();
  static final _log = Logger();

  // ============================================================
  // 🔑 KEY GENERATION
  // ============================================================

  /// Generates a new Ed25519 key pair
  Future<SimpleKeyPair> generateKeyPair() async {
    try {
      return await _algorithm.newKeyPair();
    } catch (e, st) {
      _log.e('Key pair generation failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  // ============================================================
  // 📤 KEY EXPORT
  // ============================================================

  /// Exports private key as raw bytes
  ///
  /// WARNING:
  /// - Intended for immediate in-memory processing
  /// - Must NOT be persisted unencrypted
  Future<Uint8List> exportPrivateKeyBytes(SimpleKeyPair keyPair) async {
    try {
      final bytes = await keyPair.extractPrivateKeyBytes();
      return Uint8List.fromList(bytes);
    } catch (e, st) {
      _log.e('Private key export failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Exports public key as raw bytes
  Future<Uint8List> exportPublicKeyBytes(SimpleKeyPair keyPair) async {
    try {
      final publicKey = await keyPair.extractPublicKey();
      return Uint8List.fromList(publicKey.bytes);
    } catch (e, st) {
      _log.e('Public key export failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  // ============================================================
  // 📥 KEY IMPORT
  // ============================================================

  /// Imports a private key from raw bytes
  ///
  /// Used for reconstructing a key pair after decryption
  Future<SimpleKeyPair> importPrivateKeyBytes(Uint8List privateKeyBytes) async {
    try {
      return await _algorithm.newKeyPairFromSeed(privateKeyBytes);
    } catch (e, st) {
      _log.e('Private key import failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Imports a public key from raw bytes
  Future<PublicKey> importPublicKeyBytes(Uint8List publicKeyBytes) async {
    try {
      return SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519);
    } catch (e, st) {
      _log.e('Public key import failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  // ============================================================
  // ✍️ SIGNING
  // ============================================================

  /// Signs arbitrary binary data
  ///
  /// Returns Base64-encoded signature
  Future<String> signBytes({
    required Uint8List message,
    required SimpleKeyPair keyPair,
  }) async {
    try {
      final signature = await _algorithm.sign(message, keyPair: keyPair);

      return base64Encode(signature.bytes);
    } catch (e, st) {
      _log.e('Signing failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Signs UTF-8 text
  Future<String> signString({
    required String message,
    required SimpleKeyPair keyPair,
  }) async {
    return signBytes(
      message: Uint8List.fromList(utf8.encode(message)),
      keyPair: keyPair,
    );
  }

  // ============================================================
  // ✅ VERIFICATION
  // ============================================================

  /// Verifies a Base64-encoded signature against binary data
  Future<bool> verifyBytes({
    required Uint8List message,
    required String signatureBase64,
    required PublicKey publicKey,
  }) async {
    try {
      final signature = Signature(
        base64Decode(signatureBase64),
        publicKey: publicKey,
      );

      return await _algorithm.verify(message, signature: signature);
    } catch (e, st) {
      _log.e('Signature verification failed', error: e, stackTrace: st);
      return false;
    }
  }

  /// Verifies a Base64-encoded signature against UTF-8 text
  Future<bool> verifyString({
    required String message,
    required String signatureBase64,
    required PublicKey publicKey,
  }) async {
    return verifyBytes(
      message: Uint8List.fromList(utf8.encode(message)),
      signatureBase64: signatureBase64,
      publicKey: publicKey,
    );
  }

  /// Dekryptuj klucz prywatny i zwróć SimpleKeyPair
  Future<SimpleKeyPair> getStoredKeyPair({
    required List<int> privateKeyBytes,
  }) async {
    return importPrivateKeyBytes(Uint8List.fromList(privateKeyBytes));
  }
}
