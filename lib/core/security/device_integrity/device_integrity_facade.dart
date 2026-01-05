// lib/core/security/application/device_integrity_facade.dart

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/device_integrity/device_integrity_service.dart';
import 'package:obywatel_plus/core/security/device_integrity/security_integrity_config.dart';
import 'package:obywatel_plus/core/security/domain/security_exceptions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_integrity_facade.g.dart';

@riverpod
IDeviceIntegrityFacade deviceIntegrityFacade(Ref ref) {
  return DeviceIntegrityFacade(
    logger: ref.watch(appLoggerProvider),
    service: ref.watch(deviceIntegrityServiceProvider),
  );
}

abstract interface class IDeviceIntegrityFacade {
  Future<bool> isDeviceAllowed();
}

class DeviceIntegrityFacade implements IDeviceIntegrityFacade {
  final AppLogger _logger;
  final DeviceIntegrityService _service;

  // Klasa nie przechowuje Ref, tylko konkretne obiekty
  DeviceIntegrityFacade({
    required AppLogger logger,
    required DeviceIntegrityService service,
  }) : _logger = logger,
       _service = service;

  @override
  Future<bool> isDeviceAllowed() async {
    // Brak użycia _ref.read(...) zapobiega błędom cyklu życia
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      _logger.i('🔒 Device integrity check skipped (unsupported platform)');
      return true;
    }

    try {
      final config = SecurityIntegrityConfig(
        blockRooted: kReleaseMode,
        blockEmulator: kReleaseMode,
        blockDeveloperMode: kReleaseMode,
        blockDangerousApps: kReleaseMode,
        expectedPackageHash: kReleaseMode
            ? 'v7N8xP9qW2zL5mR1tK0jY4uS6bX3cA8vE9nG2fD4hI1='
            : null,
      );

      await _service.verify(config);

      _logger.i('🔒 Device integrity check passed');
      return true;
    } on DeviceNotSecureException {
      _logger.w('❌ Device integrity failed – security violation detected');
      return false;
    } catch (e, s) {
      _logger.e('❌ Device integrity unexpected error', error: e, stackTrace: s);
      return false;
    }
  }
}
