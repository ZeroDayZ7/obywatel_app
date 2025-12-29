// lib/core/security/device_integrity/device_integrity_service.dart

import 'package:flutter_root_jailbreak_checker/flutter_root_jailbreak_checker.dart';
import 'package:obywatel_plus/core/security/device_integrity/security_integrity_config.dart';
import 'package:obywatel_plus/core/security/domain/security_exceptions.dart';

class DeviceIntegrityService {
  DeviceIntegrityService({FlutterRootJailbreakChecker? checker})
    : _checker = checker ?? FlutterRootJailbreakChecker();

  final FlutterRootJailbreakChecker _checker;

  Future<void> verify(SecurityIntegrityConfig config) async {
    // W wersji 2.1.5 metoda nazywa się 'check'
    final result = await _checker.check(config.toPluginConfig());

    bool isThreatDetected = false;

    // Sprawdzanie flag zgodnie z nowym API
    if (config.blockRooted && (result.isRooted || result.isJailbroken)) {
      isThreatDetected = true;
    }

    if (config.blockEmulator && (result.isEmulator || !result.isRealDevice)) {
      isThreatDetected = true;
    }

    if (config.blockDeveloperMode && result.isDeveloperModeEnabled) {
      isThreatDetected = true;
    }

    // Nowość w 2.1.5 - wykrywa Fridę, Xposed i inne narzędzia
    if (config.blockDangerousApps && result.hasPotentiallyDangerousApps) {
      isThreatDetected = true;
    }

    if (isThreatDetected) {
      throw const DeviceNotSecureException();
    }
  }
}
