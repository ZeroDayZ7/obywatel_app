import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hash_service.g.dart';

@Riverpod(keepAlive: true)
HashService hashService(Ref ref) {
  final logger = ref.watch(appLoggerProvider);
  return HashService(logger);
}

class HashService {
  final AppLogger _logger;
  static final _random = Random.secure();

  HashService(this._logger);

  static const int saltLength = 16;

  static final _argon = Argon2id(
    memory: 1 * 1024, // 64 MB
    iterations: 1, //  3
    parallelism: 1,
    hashLength: 32,
  );

  /// Tworzy hash z bajtów (np. z SecureBuffer)
  Future<String> hash(List<int> bytes) async {
    if (bytes.isEmpty) throw ArgumentError('Input bytes cannot be empty');

    final salt = List<int>.generate(saltLength, (_) => _random.nextInt(256));

    _logger.d('HashService: Hashing bytes in isolate...');

    try {
      final hashBytes = await compute(
        _computeHashInIsolate,
        _HashJob(List<int>.from(bytes), salt, _argon),
      );

      final combined = [...salt, ...hashBytes];
      final result = base64Url.encode(combined);

      // Czyścimy naszą lokalną kopię 'combined', bo to zwykła lista
      combined.fillRange(0, combined.length, 0);

      return result;
    } catch (e, st) {
      _logger.e('HashService: Hashing error', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Weryfikuje bajty względem zapisanego hasha
  Future<bool> verify(List<int> bytes, String storedHash) async {
    if (bytes.isEmpty || storedHash.isEmpty) return false;

    try {
      List<int> decodedBytes;
      try {
        decodedBytes = base64Url.decode(storedHash);
      } catch (_) {
        decodedBytes = base64.decode(storedHash);
      }

      const minLength = saltLength + 32;
      if (decodedBytes.length < minLength) {
        _logger.w('HashService: Hash too short');
        return false;
      }

      final salt = decodedBytes.sublist(0, saltLength);
      final expectedHash = decodedBytes.sublist(saltLength);

      final calculatedHash = await compute(
        _computeHashInIsolate,
        _HashJob(List<int>.from(bytes), salt, _argon),
      );

      // Constant-time comparison
      final isValid = const ListEquality().equals(calculatedHash, expectedHash);

      _logger.d('HashService: Verification result: $isValid');
      return isValid;
    } catch (e, st) {
      _logger.e('HashService: Verification error', error: e, stackTrace: st);
      return false;
    }
  }
}

class _HashJob {
  final List<int> bytes;
  final List<int> salt;
  final Argon2id algorithm;

  _HashJob(this.bytes, this.salt, this.algorithm);
}

Future<List<int>> _computeHashInIsolate(_HashJob job) async {
  try {
    final secretKey = await job.algorithm.deriveKeyFromPassword(
      password: String.fromCharCodes(job.bytes),
      nonce: job.salt,
    );

    final result = await secretKey.extractBytes();

    job.bytes.fillRange(0, job.bytes.length, 0);

    return result;
  } catch (e) {
    rethrow;
  }
}
