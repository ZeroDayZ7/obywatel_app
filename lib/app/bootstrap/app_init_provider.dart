// lib/app/bootstrap/app_init_provider.dart
import 'package:obywatel_plus/app/bootstrap/app_init_status.dart';
import 'package:obywatel_plus/app/bootstrap/logic/startup_runner.dart';
import 'package:obywatel_plus/app/bootstrap/logic/tasks.dart';
// import 'package:obywatel_plus/app/bootstrap/logic/version/version_provider.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
// import 'package:obywatel_plus/core/security/device_integrity/device_integrity_facade.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_init_provider.g.dart';

@riverpod
class AppInitNotifier extends _$AppInitNotifier {
  @override
  AppInitStatus build() => const AppInitStatus.loading();

  Future<void> initialize() async => await _runBootstrap();

  Future<void> _runBootstrap() async {
    final logger = ref.read(appLoggerProvider);

    try {
      final runner = StartupRunner(
        logger: logger,
        // Grupa 1: Muszą być gotowe najpierw (Infrastruktura)
        sequentialTasks: [
          StorageInitTask(
            storage: ref.read(secureStorageProvider),
            prefs: ref.read(activePrefsProvider),
            database: ref.read(appDatabaseProvider),
          ),
          SecurityInitTask(ref.read(securityServiceProvider.notifier)),
        ],
        // Grupa 2: Mogą działać w tle jednocześnie (Sieć / System)
        parallelTasks: [
          // DeviceIntegrityTask(ref.read(deviceIntegrityFacadeProvider)),
          // VersionCheckTask(ref.read(versionProvider.notifier)),
        ],
      );

      state = await runner.run();
    } catch (e, st) {
      logger.e(
        '💥 Bootstrap failed at provider level',
        error: e,
        stackTrace: st,
      );
      state = const AppInitStatus.blocked(reason: 'critical_init_error');
    }
  }

  Future<void> recheck() async {
    state = const AppInitStatus.loading();
    await _runBootstrap();
  }
}
