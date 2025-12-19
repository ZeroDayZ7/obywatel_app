import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/bootstrap_step.dart';
import 'package:obywatel_plus/app/bootstrap/startup_providers.dart';

class StartupStep extends BootstrapStep {
  @override
  String get name => 'StartupStep';

  @override
  Future<void> run(Ref ref) async {
    await ref.read(startupServiceProvider).run(ref);
  }
}
