import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/security/pin_service.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/crypto/hash_service_provider.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';

final pinServiceProvider = Provider<PinService>((ref) {
  final storage = ref.read(secureStorageProvider);
  final hash = ref.read(hashServiceProvider);
  final logger = ref.read(appLoggerProvider);

  return PinService(storage: storage, hashService: hash, logger: logger);
});
