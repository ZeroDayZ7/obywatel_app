// lib/core/security/device_integrity/device_integrity_service.dart

import 'dart:io';

import 'package:flutter_root_jailbreak_checker/flutter_root_jailbreak_checker.dart';
import 'package:obywatel_plus/core/security/device_integrity/security_integrity_config.dart';
import 'package:obywatel_plus/core/security/domain/security_exceptions.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceIntegrityService {
  DeviceIntegrityService({FlutterRootJailbreakChecker? checker})
    : _checker = checker ?? FlutterRootJailbreakChecker();

  final FlutterRootJailbreakChecker _checker;

  Future<void> verify(SecurityIntegrityConfig config) async {
    // 1. Podstawowe skanowanie środowiska (Root, Emulator, Dangerous Apps)
    final result = await _checker.check(config.toPluginConfig());

    bool isThreatDetected = false;

    // Sprawdzanie Root / Jailbreak
    if (config.blockRooted && (result.isRooted || result.isJailbroken)) {
      isThreatDetected = true;
    }

    // Sprawdzanie Emulatora / Real Device
    if (config.blockEmulator && (result.isEmulator || !result.isRealDevice)) {
      isThreatDetected = true;
    }

    // Sprawdzanie trybu programisty
    if (config.blockDeveloperMode && result.isDeveloperModeEnabled) {
      isThreatDetected = true;
    }

    // Wykrywanie narzędzi hackerskich (Frida, Xposed, Magisk)
    if (config.blockDangerousApps && result.hasPotentiallyDangerousApps) {
      isThreatDetected = true;
    }

    // 2. Weryfikacja integralności podpisu binarnego (Anti-Tampering)
    // Sprawdzamy, czy ktoś nie zmodyfikował APK i nie podpisał go własnym kluczem
    if (Platform.isAndroid && config.expectedPackageHash != null) {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentSignature = packageInfo.buildSignature;

      // Jeśli podpis aplikacji nie zgadza się ze wzorcem zaszytym w configu
      if (currentSignature.isNotEmpty &&
          currentSignature != config.expectedPackageHash) {
        isThreatDetected = true;
      }
    }

    // 3. Finalna decyzja
    if (isThreatDetected) {
      throw const DeviceNotSecureException();
    }
  }
}
