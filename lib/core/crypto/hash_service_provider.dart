import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/crypto/hash_service.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';

/// Provider tworzący instancję [HashService] z loggerem.
/// Dzięki temu wszystkie serwisy mogą korzystać z tego samego providera,
/// zamiast tworzyć własny obiekt HashService.
///
/// Użycie:
/// ```dart
/// final hashService = ref.read(hashServiceProvider);
/// final hash = await hashService.hash('1234');
/// ```
final hashServiceProvider = Provider<HashService>((ref) {
  final logger = ref.read(appLoggerProvider);
  return HashService(logger);
});
