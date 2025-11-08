import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart'; // for kDebugMode
import 'package:obywatel_plus/core/logger/app_logger.dart';

/// A service for securely hashing and verifying passwords using Argon2id.
/// Automatically adjusts parameters depending on whether the app runs
/// in debug or production mode.
class HashService {
  final AppLogger _logger;
  final Argon2id _argon2;
  final Random _random;

  HashService(this._logger)
    : _argon2 = kDebugMode
          ? Argon2id(
              memory: 4 * 1024, // 4 MiB memory (weak for dev)
              parallelism: 1,
              iterations: 1, // super fast for local testing
              hashLength: 16,
            )
          : Argon2id(
              memory: 64 * 1024, // 64 MiB for production
              parallelism: 4,
              iterations: 3, // strong and resistant to brute force
              hashLength: 32,
            ),
      _random = Random.secure();

  /// Generates a cryptographically secure random salt.
  List<int> _generateSalt([int length = 16]) =>
      List<int>.generate(length, (_) => _random.nextInt(256));

  /// Hashes a password using Argon2id and returns Base64(salt + hash).
  ///
  /// Logs progress and errors. Throws [ArgumentError] if password is empty.
  Future<String> hash(String password) async {
    _logger.d(
      'HashService: Starting password hashing (length: ${password.length})',
    );

    if (password.isEmpty) {
      _logger.e('HashService: Attempted to hash an empty password!');
      throw ArgumentError('Password cannot be empty!');
    }

    try {
      final salt = _generateSalt();
      final secretKey = await _argon2.deriveKeyFromPassword(
        password: password,
        nonce: salt,
      );

      final hashBytes = await secretKey.extractBytes();
      final combined = [...salt, ...hashBytes];
      final result = base64Encode(combined);

      _logger.i(
        'HashService: Hash generated successfully (length: ${result.length}, mode: ${kDebugMode ? 'debug' : 'production'})',
      );

      return result;
    } catch (e, s) {
      _logger.e('HashService: Error during hashing', error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Verifies whether a given password matches the stored Base64 hash.
  ///
  /// Returns `true` if valid, `false` otherwise. Logs all outcomes.
  Future<bool> verify(String password, String storedHash) async {
    _logger.d(
      'HashService: Starting password verification (stored hash length: ${storedHash.length})',
    );

    if (password.isEmpty || storedHash.isEmpty) {
      _logger.w('HashService: Empty password or stored hash – denied');
      return false;
    }

    try {
      final decoded = base64Decode(storedHash);
      final expectedLength = kDebugMode ? 16 + 16 : 16 + 32;
      // 16 bytes salt + 16 bytes hash (dev)
      // 16 bytes salt + 32 bytes hash (prod)

      if (decoded.length < expectedLength) {
        _logger.w(
          'HashService: Invalid stored hash (too short: ${decoded.length} bytes, expected: $expectedLength)',
        );
        return false;
      }

      final salt = decoded.sublist(0, 16);
      final originalHash = decoded.sublist(16);

      final secretKey = await _argon2.deriveKeyFromPassword(
        password: password,
        nonce: salt,
      );
      final newHash = await secretKey.extractBytes();

      final isValid = const ListEquality().equals(newHash, originalHash);
      _logger.i('HashService: Password verification result: $isValid');

      return isValid;
    } catch (e, s) {
      _logger.e(
        'HashService: Error during verification',
        error: e,
        stackTrace: s,
      );
      return false;
    }
  }
}
