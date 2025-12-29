// startup_runner.dart
import 'package:obywatel_plus/app/bootstrap/app_init_status.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

import 'tasks.dart';

class StartupRunner {
  final List<StartupTask> tasks;
  final AppLogger logger;

  StartupRunner({required this.tasks, required this.logger});

  Future<AppInitStatus> run() async {
    logger.i('🚀 StartupRunner: Starting bootstrap sequence...');

    for (final task in tasks) {
      try {
        // Logujemy start każdego zadania, by wiedzieć gdzie proces "wisi"
        logger.i('⏳ Task [${task.name}] starting...');

        final result = await task.initialize();

        if (result != null) {
          logger.w(
            '⚠️ Task [${task.name}] returned non-null status: $result. Aborting sequence.',
          );
          return result;
        }

        logger.i('✅ Task [${task.name}] completed successfully.');
      } catch (e, st) {
        // CRITICAL: Logowanie do systemów zewnętrznych (Sentry/Crashlytics)
        // powinno odbywać się wewnątrz loggera.
        logger.e(
          '💥 CRITICAL FAILURE: Task [${task.name}] crashed',
          error: e,
          stackTrace: st,
        );

        // Zwracamy stan zablokowany, co pozwoli UI pokazać ErrorApp
        return AppInitStatus.blocked(reason: 'task_failed_${task.name}');
      }
    }

    logger.i('🎉 StartupRunner: All tasks finished. App authorized.');
    return const AppInitStatus.authorized();
  }
}
