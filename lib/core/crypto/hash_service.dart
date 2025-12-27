import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';

/// A provider that creates a single instance of [HashService] with the app logger.
/// This ensures that all services in the app use the same [HashService] instance,
/// rather than creating separate instances manually.
///
/// Usage example:
/// ```dart
/// final hashService = ref.read(hashServiceProvider);
/// final hash = await hashService.hash('1234');
/// final isValid = await hashService.verify('1234', hash);
/// ```
final hashServiceProvider = Provider<HashService>((ref) {
  final logger = ref.read(appLoggerProvider);
  return HashService(logger);
});

class HashService {
  final AppLogger _logger;
  static final _random = Random.secure();

  HashService(this._logger);

  static const int saltLength = 16;

  // Finalna i jedyna konfiguracja — PROD (silna)
  static final _argon = Argon2id(
    memory: 1 * 1024, // 128MB
    iterations: 1,
    parallelism: 1,
    hashLength: 32, // 32-byte hash (256-bit)
  );

  /// Tworzy hash hasła (BASE64 URL SAFE)
  Future<String> hash(String password) async {
    if (password.isEmpty) throw ArgumentError('Password cannot be empty');

    final salt = List<int>.generate(saltLength, (_) => _random.nextInt(256));

    _logger.d('HashService: Hashing in isolate...');

    final hashBytes = await compute(
      _computeHashInIsolate,
      _HashJob(password, salt, _argon),
    );

    final combined = [...salt, ...hashBytes];

    return base64Url.encode(combined);
  }

  /// Weryfikuje hasło
  Future<bool> verify(String password, String storedHash) async {
    if (password.isEmpty || storedHash.isEmpty) return false;

    try {
      List<int> bytes;
      try {
        bytes = base64Url.decode(storedHash);
      } catch (_) {
        bytes = base64.decode(storedHash); // support legacy
      }

      const minLength = saltLength + 32; // 16 salt + 32 hash = 48 bajtów
      if (bytes.length < minLength) {
        _logger.w('HashService: Hash too short (${bytes.length} bytes)');
        return false;
      }

      final salt = bytes.sublist(0, saltLength);
      final expectedHash = bytes.sublist(saltLength);

      final calculatedHash = await compute(
        _computeHashInIsolate,
        _HashJob(password, salt, _argon),
      );

      final isValid = const ListEquality().equals(calculatedHash, expectedHash);

      _logger.d('HashService: Verification result: $isValid');
      return isValid;
    } catch (e, st) {
      _logger.e('HashService: Verification error', error: e, stackTrace: st);
      return false;
    }
  }
}

/// --- isolate job ---
class _HashJob {
  final String password;
  final List<int> salt;
  final Argon2id algorithm;

  _HashJob(this.password, this.salt, this.algorithm);
}

/// --- isolate function ---
Future<List<int>> _computeHashInIsolate(_HashJob job) async {
  final key = await job.algorithm.deriveKeyFromPassword(
    password: job.password,
    nonce: job.salt,
  );
  return await key.extractBytes();
}
