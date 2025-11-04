import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';
import 'package:collection/collection.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

class HashService {
  final AppLogger _logger;
  final Argon2id _argon2;
  final Random _random;

  HashService(this._logger)
    : _argon2 = Argon2id(
        memory: 8 * 1024, // 8 MiB → 8 razy mniej pamięci
        parallelism: 1, // jeden wątek wystarczy
        iterations: 1, // jedna iteracja
        hashLength: 16, // hash krótszy, nadal bezpieczny lokalnie
      ),
      _random = Random.secure();

  List<int> _generateSalt([int length = 16]) =>
      List<int>.generate(length, (_) => _random.nextInt(256));

  /// Hashuje hasło: generuje salt, derivuje key, zwraca base64(salt + hash)
  /// Loguje entry i ewentualne błędy
  Future<String> hash(String password) async {
    _logger.d(
      'HashService: Rozpoczynam hashowanie hasła (długość: ${password.length})',
    );

    if (password.isEmpty) {
      _logger.e('HashService: Próba hashowania pustego hasła!');
      throw ArgumentError('Hasło nie może być puste!');
    }

    try {
      final salt = _generateSalt();
      final secretKey = await _argon2.deriveKeyFromPassword(
        password: password,
        nonce: salt,
      );
      final hashBytes = await secretKey.extractBytes();
      final result = base64Encode([...salt, ...hashBytes]);

      _logger.i(
        'HashService: Hash wygenerowany pomyślnie (długość: ${result.length})',
      );
      return result;
    } catch (e, s) {
      _logger.e(
        'HashService: Błąd podczas hashowania',
        error: e,
        stackTrace: s,
      );
      rethrow; // Przekaż error wyżej (np. do UI)
    }
  }

  /// Weryfikuje hasło: re-derivuje i porównuje z stored
  /// Loguje entry, warnings i błędy
  Future<bool> verify(String password, String storedHash) async {
    _logger.d(
      'HashService: Rozpoczynam weryfikację hasła (stored hash długość: ${storedHash.length})',
    );

    if (password.isEmpty || storedHash.isEmpty) {
      _logger.w('HashService: Puste hasło lub stored hash – odmowa');
      return false;
    }

    try {
      final decoded = base64Decode(storedHash);
      if (decoded.length < 48) {
        _logger.w(
          'HashService: Invalid stored hash (zbyt krótki: ${decoded.length} bajtów)',
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
      _logger.i('HashService: Weryfikacja zakończona (wynik: $isValid)');
      return isValid;
    } catch (e, s) {
      _logger.e('HashService: Błąd verify()', error: e, stackTrace: s);
      return false;
    }
  }
}
