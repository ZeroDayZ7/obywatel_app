import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/bootstrap_step.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/security/security/security_notifier.dart';

class SecurityStep extends BootstrapStep {
  @override
  String get name => 'SecurityStep';

  @override
  Future<void> run(Ref ref) async {
    final logger = ref.read(appLoggerProvider);
    final security = ref.read(securityServiceProvider.notifier);

    await security.init();
    logger.i('🔒 SecurityService initialized');
  }
}
