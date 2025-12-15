import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:obywatel_plus/app/bootstrap/startup_service.dart';
import '../bootstrap_step.dart';

class StartupStep extends BootstrapStep {
  @override
  String get name => 'StartupStep';

  @override
  Future<void> run(Ref ref) async {
    // final startup = ref.read(startupServiceProvider);
    // await startup.run();
  }
}
