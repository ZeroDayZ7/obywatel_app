import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/bootstrap_step.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/security/application/device_integrity_service.dart';
import 'package:obywatel_plus/core/security/application/security_integrity_config.dart';

class SecurityIntegrationStep extends BootstrapStep {
  @override
  String get name => 'SecurityIntegrationStep';

  @override
  bool shouldRun(Ref ref) {
    return true;
  }

  @override
  Future<void> run(Ref ref) async {
    final logger = ref.read(appLoggerProvider);

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final service = DeviceIntegrityService();
      const config = SecurityIntegrityConfig(
        blockRooted: true,
        blockEmulator: true,
        blockDeveloperMode: false,
      );
      await service.verify(config);
      logger.i('🔒 Device integrity check completed');
    } else {
      // Na Web lub desktop pomijamy integrację
      logger.i(
        '🔒 SecurityIntegrationStep pominięty (platforma nie wspierana)',
      );
    }
  }
}
