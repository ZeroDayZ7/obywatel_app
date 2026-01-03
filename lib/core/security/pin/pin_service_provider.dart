import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/crypto/hash_service.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';

final pinServiceProvider = Provider<PinService>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final hash = ref.watch(hashServiceProvider);
  final logger = ref.watch(appLoggerProvider);

  return PinService(
    storage: storage,
    hashService: hash,
    logger: logger,
  );
});
