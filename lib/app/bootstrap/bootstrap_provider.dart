import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    SecurityStep(),
    SessionStep(),
    StartupStep(),
  ]);

  await runner.run(ref);
});
