// lib\app\bootstrap\logic\startup_runner.dart
import 'dart:async';

import 'package:obywatel_plus/app/bootstrap/app_init_status.dart';
import 'package:obywatel_plus/app/bootstrap/logic/startup_task.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

class StartupRunner {
  final List<StartupTask> sequentialTasks;
  final List<StartupTask> parallelTasks;
  final AppLogger logger;

  StartupRunner({
    required this.sequentialTasks,
    required this.parallelTasks,
    required this.logger,
  });

  Future<AppInitStatus> run() async {
    logger.i('🚀 StartupRunner: Starting bootstrap sequence...');

    for (final task in sequentialTasks) {
      final status = await _executeTask(task);
      if (status != null) return status;
    }

    if (parallelTasks.isNotEmpty) {
      logger.i(
        '⚡ Starting parallel tasks: ${parallelTasks.map((e) => e.name).toList()}',
      );

      final results = await Future.wait(
        parallelTasks.map((task) => _executeTask(task)),
      );

      for (final result in results) {
        if (result != null) return result;
      }
    }

    logger.i('🎉 StartupRunner: All tasks finished successfully.');
    return const AppInitStatus.ready();
  }

  Future<AppInitStatus?> _executeTask(StartupTask task) async {
    try {
      logger.i('⏳ Task [${task.name}] starting...');

      final result = await task.initialize().timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Task ${task.name} timed out'),
      );
      return result;
    } on TimeoutException catch (e) {
      logger.e('⏰ TIMEOUT: Task [${task.name}] took too long ERROR: $e');
      return AppInitStatus.blocked(reason: 'timeout_${task.name}');
    } catch (e, st) {
      logger.e(
        '💥 CRITICAL FAILURE: Task [${task.name}] crashed',
        error: e,
        stackTrace: st,
      );
      return AppInitStatus.blocked(reason: 'task_failed_${task.name}');
    }
  }
}
