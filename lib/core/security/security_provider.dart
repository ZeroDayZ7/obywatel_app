// lib/core/security/security_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/security_service.dart';
import 'package:obywatel_plus/core/security/pin_service.dart';
import 'package:obywatel_plus/core/crypto/hash_service.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';

final securityServiceProvider =
    Provider.family<SecurityService, SecureStorageService>((ref, storage) {
      final logger = ref.read(appLoggerProvider);
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
