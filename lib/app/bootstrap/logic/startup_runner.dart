import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/app_init_status.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';

import 'startup_task.dart';
import 'tasks.dart';

class StartupRunner {
  final Ref ref;

  // Lista zadań w ścisłej kolejności
  final List<StartupTask> _tasks = [
    StorageInitTask(), // 1. Dysk
    SecurityInitTask(), // 2. Bezpieczeństwo
    DeviceIntegrityTask(), // 3. Root check
    VersionCheckTask(), // 4. API check
  ];

  StartupRunner(this.ref);

  Future<AppInitStatus> run() async {
    final logger = ref.read(appLoggerProvider);
    logger.i('🚀 StartupRunner: Starting bootstrap sequence...');

    final stopwatch = Stopwatch()..start();

    for (final task in _tasks) {
      final taskStart = stopwatch.elapsedMilliseconds;
      try {
        // Uruchomienie zadania
        final result = await task.initialize(ref);

        final taskDuration = stopwatch.elapsedMilliseconds - taskStart;
        logger.d('   ✅ Task [${task.name}] finished in ${taskDuration}ms');

        // Jeśli zadanie zwróciło status -> przerywamy (błąd lub blokada)
        if (result != null) {
          logger.w('   ⛔ Startup halted by [${task.name}]: $result');
          return result;
        }
      } catch (e, st) {
        logger.e('   💥 Task [${task.name}] CRASHED', error: e, stackTrace: st);
        return AppInitStatus.blocked(reason: 'Init failed at ${task.name}: $e');
      }
    }

    logger.i(
      '🚀 StartupRunner: Sequence completed in ${stopwatch.elapsedMilliseconds}ms',
    );
    return const AppInitStatus.authorized();
  }
}
