import 'package:obywatel_plus/app/bootstrap/app_init_status.dart';
import 'package:obywatel_plus/app/bootstrap/logic/startup_runner.dart';
import 'package:obywatel_plus/app/bootstrap/logic/startup_task.dart';
import 'package:obywatel_plus/app/bootstrap/logic/version/version_provider.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/device_integrity/device_integrity_facade.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_init_provider.g.dart';

@riverpod
class AppInitNotifier extends _$AppInitNotifier {
  @override
  AppInitStatus build() {
    // Metoda build jest czysta (pure) - zwraca tylko stan początkowy.
    return const AppInitStatus.loading();
  }

  /// Inicjalizacja wywoływana jawnie z warstwy UI (np. w PostFrameCallback lub initState)
  Future<void> initialize() async {
    // Zapobiegamy wielokrotnemu uruchamianiu, jeśli już trwa ładowanie
    // (opcjonalne, zależnie od logiki UI)
    await _runBootstrap();
  }

  Future<void> _runBootstrap() async {
    final logger = ref.read(appLoggerProvider);

    try {
      final prefs = ref.read(activePrefsProvider);
      final storage = ref.read(secureStorageProvider);
      final database = ref.read(appDatabaseProvider);

      final runner = StartupRunner(
        logger: logger,
        tasks: [
          StorageInitTask(storage: storage, prefs: prefs, database: database),
          SecurityInitTask(ref.read(securityServiceProvider.notifier)),
          DeviceIntegrityTask(ref.read(deviceIntegrityServiceProvider)),
          VersionCheckTask(ref.read(versionProvider.notifier)),
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

  /// Metoda retry do ponownej próby inicjalizacji
  Future<void> recheck() async {
    state = const AppInitStatus.loading();
    await _runBootstrap();
  }
}
