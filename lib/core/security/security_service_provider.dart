// lib/core/security/security_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/security_service.dart';
import 'package:obywatel_plus/core/security/pin_service.dart';
import 'package:obywatel_plus/core/crypto/hash_service.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';

final securityServiceProvider = Provider<SecurityService>((ref) {
  final logger = ref.read(appLoggerProvider);
  final storage = ref.read(secureStorageProvider);
  final hashService = HashService(logger);

  final pinService = PinService(
    storage: storage,
    hashService: hashService,
    logger: logger,
  );

  return SecurityService(
    pinService: pinService,
    secureStorage: storage,
    localAuth: LocalAuthentication(),
    logger: logger,
  );
});
