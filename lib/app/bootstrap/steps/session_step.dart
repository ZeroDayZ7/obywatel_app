import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/bootstrap_step.dart';

import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';

class SessionStep extends BootstrapStep {
  @override
  String get name => 'SessionStep';

  @override
  Future<void> run(Ref ref) async {
    final logger = ref.read(appLoggerProvider);
    final session = ref.read(sessionServiceProvider.notifier);

    await session.init();
    logger.i('🔑 SessionService initialized');
  }
}
