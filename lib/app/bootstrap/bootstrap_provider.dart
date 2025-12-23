import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/steps/security_integration_step.dart';
import 'bootstrap_runner.dart';
import 'steps/background_step.dart';
import 'steps/debug_storage_step.dart';
import 'steps/security_step.dart';
import 'steps/session_step.dart';
import 'steps/startup_step.dart';

final bootstrapProvider = FutureProvider<void>((ref) async {
  final runner = BootstrapRunner([
    BackgroundStep(),
    DebugStorageStep(),

    SecurityIntegrationStep(),

    StartupStep(),

    SecurityStep(),
    SessionStep(),
  ]);

  try {
    await runner.run(ref);
  } catch (e) {
    rethrow;
  }
});
