// lib/app/bootstrap/app_init_provider.dart
import 'package:obywatel_plus/app/bootstrap/app_init_status.dart';
import 'package:obywatel_plus/app/bootstrap/bootstrap_config.dart';
import 'package:obywatel_plus/app/bootstrap/logic/startup_runner.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_init_provider.g.dart';

@riverpod
class AppInitNotifier extends _$AppInitNotifier {
  @override
  AppInitStatus build() => const AppInitStatus.loading();

  Future<void> initialize() async => await _runBootstrap();

  Future<void> recheck() async {
    state = const AppInitStatus.loading();
    await _runBootstrap();
  }

  Future<void> _runBootstrap() async {
    final logger = ref.read(appLoggerProvider);
    final config = ref.read(bootstrapConfigProvider);
    final stopwatch = Stopwatch()..start();

    try {
      final runner = StartupRunner(
        logger: logger,
        sequentialTasks: config.sequentialTasks,
        parallelTasks: config.parallelTasks,
      );

      final result = await runner.run();

      stopwatch.stop();
      final elapsed = stopwatch.elapsed;

      if (elapsed < apiConstants.minSplashDuration) {
        await Future.delayed(apiConstants.minSplashDuration - elapsed);
      }

      state = result;
    } catch (e, st) {
      logger.e(
        '💥 Bootstrap failed at provider level',
        error: e,
        stackTrace: st,
      );
      state = const AppInitStatus.blocked(reason: 'critical_init_error');
    }
  }
}
