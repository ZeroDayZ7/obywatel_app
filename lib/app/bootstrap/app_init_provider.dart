import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/app_init_status.dart';
import 'package:obywatel_plus/app/bootstrap/logic/startup_runner.dart';
import 'package:obywatel_plus/app/bootstrap/logic/startup_task.dart';
import 'package:obywatel_plus/app/bootstrap/logic/version/version_logic.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/device_integrity/device_integrity_facade.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_service.dart';

final appInitProvider = NotifierProvider<AppInitNotifier, AppInitStatus>(
  AppInitNotifier.new,
);

class AppInitNotifier extends Notifier<AppInitStatus> {
  @override
  AppInitStatus build() {
    // Odpalamy bootstrap bezpiecznie po zbudowaniu notifiera
    Future.microtask(() => _runBootstrap());
    return const AppInitStatus.loading();
  }

  Future<void> _runBootstrap() async {
    final logger = ref.read(appLoggerProvider);

    try {
      final prefs = ref.read(activePrefsProvider);
      final storage = ref.read(secureStorageProvider);
      final database = ref.watch(appDatabaseProvider);

      final runner = StartupRunner(
        logger: logger,
        tasks: [
          StorageInitTask(storage: storage, prefs: prefs, database: database),
          // Używamy .notifier, aby przekazać obiekt implementujący ISecurityService
          SecurityInitTask(ref.read(securityServiceProvider.notifier)),

          // Korzystamy z interfejsu fasady
          DeviceIntegrityTask(ref.read(deviceIntegrityServiceProvider)),

          // Zmiana: bezpośrednio notifier wersji jako IVersionFacade
          VersionCheckTask(ref.read(versionNotifierProvider.notifier)),
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

  /// Retry z ekranu błędu
  Future<void> recheck() async {
    state = const AppInitStatus.loading();
    await _runBootstrap();
  }
}
