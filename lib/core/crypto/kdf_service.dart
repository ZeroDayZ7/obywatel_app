import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'kdf_service.g.dart';

/// KDFService
///
/// Odpowiedzialność:
/// - wyprowadzanie klucza AES z PIN-u użytkownika
/// - generowanie i obsługa SALT
///
/// NIE:
/// - nie przechowuje danych
/// - nie zna deviceId
/// - nie hashuje PIN-u (to robi HashService)
@Riverpod(keepAlive: true)
KdfService kdfService(Ref ref) {
  return KdfService();
}

class KdfService {
  /// Długość SALT (16 bajtów = minimum, 32 byłoby też OK)
  static const int saltLength = 16;
  final _sha256 = Sha256();

  /// Parametry PBKDF2
  static const int _iterations = 100_000;
  static const int _keyLengthBits = 256;

  final Pbkdf2 _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: _iterations,
    bits: _keyLengthBits,
  );

  static final Random _secureRandom = Random.secure();

  /// Generuje nowy losowy SALT
  ///
  /// Wywoływane:
  /// - przy pierwszym ustawieniu PIN-u
  /// - przy resetowaniu security
  List<int> generateSalt() {
    final salt = List<int>.generate(
      saltLength,
      (_) => _secureRandom.nextInt(256),
    );
    return salt;
  }

  /// Wyprowadza klucz AES z PIN-u i SALT
  ///
  /// ⚠️ PIN:
  /// - MUSI być przekazany jako List `int`
  /// - NIE string
  ///
  /// SALT:
  /// - MUSI pochodzić ze storage
  /// - nigdy z deviceId
  Future<SecretKey> deriveKeyFromPin({
    required List<int> pinBytes,
    required List<int> salt,
  }) async {
    if (pinBytes.isEmpty) {
      throw ArgumentError('PIN bytes cannot be empty');
    }
    if (salt.length < saltLength) {
      throw ArgumentError('Salt too short');
    }

    try {
      final key = await _pbkdf2.deriveKey(
        secretKey: SecretKey(pinBytes),
        nonce: salt,
      );

      return key;
    } finally {
      // Czyścimy PIN z RAM (best-effort)
      _wipe(pinBytes);
    }
  }

  /// Helper do bezpiecznego czyszczenia List `int`
  void _wipe(List<int> bytes) {
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = 0;
    }
  }

  /// Utility: konwersja SecretKey → bytes (np. do testów)
  ///
  /// ⚠️ NIE zapisuj tych bajtów w storage
  Future<Uint8List> extractKeyBytes(SecretKey key) async {
    final bytes = await key.extractBytes();
    return Uint8List.fromList(bytes);
  }

  /// Hashuje dowolne bajty SHA-256
  Future<String> sha256Hash(List<int> input) async {
    final hash = await _sha256.hash(input);
    return hash.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
