// lib/core/security/device_integrity/device_integrity_service.dart

import 'dart:io';

import 'package:flutter_root_jailbreak_checker/flutter_root_jailbreak_checker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/security_exceptions.dart';
import 'security_integrity_config.dart';

part 'device_integrity_service.g.dart';

@riverpod
DeviceIntegrityService deviceIntegrityService(Ref ref) {
  return DeviceIntegrityService();
}

class DeviceIntegrityService {
  DeviceIntegrityService({FlutterRootJailbreakChecker? checker})
    : _checker = checker ?? FlutterRootJailbreakChecker();

  final FlutterRootJailbreakChecker _checker;

  Future<void> verify(SecurityIntegrityConfig config) async {
    // 1. Podstawowe skanowanie środowiska
    final result = await _checker.check(config.toPluginConfig());

    bool isThreatDetected = false;

    if (config.blockRooted && (result.isRooted || result.isJailbroken)) {
      isThreatDetected = true;
    }

    if (config.blockEmulator && (result.isEmulator || !result.isRealDevice)) {
      isThreatDetected = true;
    }

    if (config.blockDeveloperMode && result.isDeveloperModeEnabled) {
      isThreatDetected = true;
    }

    if (config.blockDangerousApps && result.hasPotentiallyDangerousApps) {
      isThreatDetected = true;
    }

    // 2. Weryfikacja integralności podpisu binarnego
    if (Platform.isAndroid && config.expectedPackageHash != null) {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentSignature = packageInfo.buildSignature;

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
