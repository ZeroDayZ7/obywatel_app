import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/crypto/hash_service.dart';
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
