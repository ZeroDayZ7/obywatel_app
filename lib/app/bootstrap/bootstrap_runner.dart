import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'bootstrap_step.dart';

class BootstrapRunner {
  final List<BootstrapStep> steps;

  const BootstrapRunner(this.steps);

  Future<void> run(Ref ref) async {
    final logger = ref.read(appLoggerProvider);

    for (final step in steps) {
      if (!step.shouldRun(ref)) {
        logger.i('⏭️ Skipping ${step.name}');
        continue;
      }

      logger.i('▶️ Running ${step.name}');
      try {
        await step.run(ref);
      } catch (e, st) {
        logger.e('❌ Step ${step.name} failed', error: e, stackTrace: st);
        // przerwij bootstrap
        rethrow;
      }
    }
  }
}
