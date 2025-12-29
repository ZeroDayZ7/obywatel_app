// lib/core/security/application/device_integrity_facade.dart

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/device_integrity/device_integrity_service.dart';
import 'package:obywatel_plus/core/security/device_integrity/security_integrity_config.dart';
import 'package:obywatel_plus/core/security/domain/security_exceptions.dart';

/// INTERFEJS - to rozwiązuje błąd "Undefined class" w startup_task.dart
abstract interface class IDeviceIntegrityFacade {
  Future<bool> isDeviceAllowed();
}

/// PROVIDER - zwraca interfejs, a nie konkretną klasę
final deviceIntegrityServiceProvider = Provider<IDeviceIntegrityFacade>((ref) {
  final logger = ref.read(appLoggerProvider);
  return DeviceIntegrityFacade(logger: logger);
});

/// IMPLEMENTACJA
/// IMPLEMENTACJA
class DeviceIntegrityFacade implements IDeviceIntegrityFacade {
  final AppLogger logger;

  DeviceIntegrityFacade({required this.logger});

  @override
  Future<bool> isDeviceAllowed() async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      logger.i('🔒 Device integrity check skipped (unsupported platform)');
      return true;
    }

    try {
      final service = DeviceIntegrityService();

      // Dynamiczna konfiguracja bezpieczeństwa
      final config = SecurityIntegrityConfig(
        blockRooted: true,
        blockEmulator: true,
        // Developer Mode zazwyczaj zostawiamy na false w dev,
        // ale możesz tu użyć kReleaseMode jeśli chcesz blokować w produkcji
        blockDeveloperMode: kReleaseMode,
        // W wersji 2.1.5 sprawdzanie debuggera i Fridy wpada pod tę flagę
        blockDangerousApps: true,
      );

      await service.verify(config);

      logger.i('🔒 Device integrity check passed');
      return true;
    } on DeviceNotSecureException {
      logger.w('❌ Device integrity failed – security violation detected');
      return false;
    } catch (e, s) {
      logger.e('❌ Device integrity unexpected error', error: e, stackTrace: s);
      // W systemach krytycznych błąd sprawdzania traktujemy jako brak bezpieczeństwa
      return false;
    }
  }
}
