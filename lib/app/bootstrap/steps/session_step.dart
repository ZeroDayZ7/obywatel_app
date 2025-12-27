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
    final session = ref.read(sessionServiceProvider);

    final hasToken = await session.hasSession();

    if (hasToken) {
      logger.i('🔑 Session found. AuthController will handle state.');
      // AuthController w swojej metodzie build() lub po starcie
      // i tak sprawdzi sesję, więc tutaj tylko potwierdzamy jej obecność w logach.
    } else {
      logger.i('👤 No session found.');
    }
  }
}
