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
  static const int _keyLengthBytes = 32;

  final AppLogger _log;
  final Sha256 _sha256 = Sha256();

  KdfService(this._log);

  static final Random _secureRandom = Random.secure();

  /// Argon2id – RFC 9106
  final Argon2id _argon2id = Argon2id(
    memory: 64 * 1024, // 64 MB
    iterations: 3,
    parallelism: 1,
    hashLength: _keyLengthBytes,
  );

  List<int> generateSalt() {
    final salt = List<int>.generate(
      saltLength,
      (_) => _secureRandom.nextInt(256),
    );
    _log.d('Generated salt (len=${salt.length})');
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
      final key = await _argon2id.deriveKey(
        secretKey: SecretKey(pinBytes),
        nonce: salt,
      );

      return key;
    } finally {
      wipe(pinBytes);
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

  void wipe(List<int> bytes) {
    if (bytes is Uint8List) {
      bytes.fillRange(0, bytes.length, 0);
    }
  }
}
