// lib\app\bootstrap\logic\tasks.dart
import 'package:flutter/foundation.dart';
import 'package:obywatel_plus/app/bootstrap/app_init_status.dart';
import 'package:obywatel_plus/app/bootstrap/logic/startup_task.dart';
import 'package:obywatel_plus/app/bootstrap/logic/version/version_models.dart';
import 'package:obywatel_plus/app/bootstrap/migration_service.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/security/device_integrity/device_integrity_facade.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';

bool shouldResetLocalDataForDevelopment({
  required bool isDebugMode,
  required bool developerResetEnabled,
}) {
  return isDebugMode && developerResetEnabled;
}

class StorageInitTask implements StartupTask {
  final SecureStorageService storage;
  final SharedPreferencesService prefs;
  final AppDatabase? database;
  final AppDatabase Function()? databaseBuilder;
  final bool developerResetEnabled;

  StorageInitTask({
    required this.storage,
    required this.prefs,
    this.database,
    this.databaseBuilder,
    this.developerResetEnabled = false,
  }) : assert(database != null || databaseBuilder != null);

  @override
  String get name => 'Storage & Database';

  @override
  Future<AppInitStatus?> initialize() async {
    final shouldResetForDevelopment = shouldResetLocalDataForDevelopment(
      isDebugMode: kDebugMode,
      developerResetEnabled: developerResetEnabled,
    );

    if (kDebugMode) {
      // await prefs.clearAll();
      // await storage.clearAll();

      await storage.debugPrintAll();
      await prefs.debugPrintAll();

      // final db = database ?? databaseBuilder?.call();
      // if (db != null) {
      //   try {
      //     await db.dumpDatabaseTables();
      //   } catch (e) {
      //     debugPrint('[StorageInitTask] ⚠️ Nie udało się zrzucić tabel bazy: $e');
      //   }
      // }

      // final db = database ?? databaseBuilder?.call();
      // if (db != null) {
      //   try {
      //     await db.close();
      //   } catch (_) {}
      // }

      // final dbFolder = await getApplicationDocumentsDirectory();
      // final file = File(p.join(dbFolder.path, 'obywatel_plus_encrypted.sqlite'));
      
      // if (file.existsSync()) {
      //   file.deleteSync();
      //   debugPrint('[StorageInitTask] ✅ Fizyczny plik bazy danych został usunięty z urządzenia.');
      // }
    }

    if (!shouldResetForDevelopment) {
      return null;
    }

    try {
      // await prefs.clearAll();
      // await storage.clearAll();

      // final db = database ?? databaseBuilder?.call();

      // if (db != null) {
      //   try {
      //     // To wywołanie wymusza natychmiastowe wykonanie openConnection() oraz setup()
      //     await db.customSelect('SELECT 1;').get();
      //     debugPrint(
      //       '[StorageInitTask] ✅ Database connection initialized & encrypted.',
      //     );
      //   } catch (e, st) {
      //     debugPrint(
      //       '[StorageInitTask] ❌ Database initialization failed: $e\n$st',
      //     );
      //     return const AppInitStatus.blocked(reason: 'database_init_failed');
      //   }
      // }
      return null;
    } catch (e, st) {
      debugPrint('[StorageInitTask] ❌ Reset failed: $e\n$st');
      return const AppInitStatus.blocked(reason: 'storage_reset_failed');
    }
  }
}

// 2. Security Init
class SecurityInitTask implements StartupTask {
  final ISecurityService securityService;

  SecurityInitTask(this.securityService);

  @override
  String get name => 'Security Service';

  @override
  Future<AppInitStatus?> initialize() async {
    await securityService.init();
    return null;
  }
}

// 3. Device Integrity - operuje na interfejsie/fasadzie
class DeviceIntegrityTask implements StartupTask {
  final IDeviceIntegrityFacade deviceIntegrity;

  DeviceIntegrityTask(this.deviceIntegrity);

  @override
  String get name => 'Device Integrity';

  @override
  Future<AppInitStatus?> initialize() async {
    if (!await deviceIntegrity.isDeviceAllowed()) {
      return const AppInitStatus.blocked(reason: 'device_integrity');
    }
    return null;
  }
}

// 4️⃣ Sprawdzenie wersji (Force Update)
class VersionCheckTask implements StartupTask {
  final IVersionFacade version;

  VersionCheckTask(this.version);

  @override
  String get name => 'Version Check';

  @override
  Future<AppInitStatus?> initialize() async {
    await version.check();

    if (version.forceUpdate) {
      return const AppInitStatus.forceUpdate();
    }
    return null;
  }
}

class MigrationTask implements StartupTask {
  final MigrationService migrationService;

  MigrationTask(this.migrationService);

  @override
  String get name => 'Data Migration';

  @override
  Future<AppInitStatus?> initialize() async {
    await migrationService.performMigrations();
    return null;
  }
}
