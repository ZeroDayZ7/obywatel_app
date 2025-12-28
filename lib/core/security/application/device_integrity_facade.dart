import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/application/device_integrity_service.dart';
import 'package:obywatel_plus/core/security/application/security_integrity_config.dart';
import 'package:obywatel_plus/core/security/domain/security_exceptions.dart';

/// Provider używany w AppInitNotifier
final deviceIntegrityServiceProvider = Provider<DeviceIntegrityFacade>((ref) {
  final logger = ref.read(appLoggerProvider);
  return DeviceIntegrityFacade(logger: logger);
});

class DeviceIntegrityFacade {
  final AppLogger logger;

  DeviceIntegrityFacade({required this.logger});

  Future<bool> isDeviceAllowed() async {
    // 🌐 Web / desktop — pomijamy
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      logger.i('🔒 Device integrity check skipped (unsupported platform)');
      return true;
    }

    try {
      final service = DeviceIntegrityService();
      const config = SecurityIntegrityConfig(
        blockRooted: true,
        blockEmulator: true,
        blockDeveloperMode: false,
      );

      await service.verify(config);

      logger.i('🔒 Device integrity check passed');
      return true;
    } on DeviceNotSecureException {
      logger.w('❌ Device integrity failed – device not secure');
      return false;
    } catch (e, s) {
      logger.e('❌ Device integrity unexpected error', error: e, stackTrace: s);
      return false;
    }
  }
}
