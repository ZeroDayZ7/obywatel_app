import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'kdf_service.g.dart';

@Riverpod(keepAlive: true)
KdfService kdfService(Ref ref) {
  final logger = ref.watch(appLoggerProvider);
  return KdfService(logger);
}

class KdfService {
  static const int saltLength = 16;
  final _sha256 = Sha256();
  final AppLogger _log;

  KdfService(this._log);

  static const int _iterations = 100_000;
  static const int _keyLengthBits = 256;

  final Pbkdf2 _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: _iterations,
    bits: _keyLengthBits,
  );

  static final Random _secureRandom = Random.secure();

  List<int> generateSalt() {
    final salt = List<int>.generate(
      saltLength,
      (_) => _secureRandom.nextInt(256),
    );
    _log.d('generateSalt salt $salt');
    return salt;
  }

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
      _wipe(pinBytes);
    }
  }

  void _wipe(List<int> bytes) {
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = 0;
    }
  }

  Future<Uint8List> extractKeyBytes(SecretKey key) async {
    final bytes = await key.extractBytes();
    return Uint8List.fromList(bytes);
  }

  Future<String> sha256Hash(List<int> input) async {
    final hash = await _sha256.hash(input);
    return hash.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
