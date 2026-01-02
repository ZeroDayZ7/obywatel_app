import 'package:flutter/foundation.dart';
import 'package:obywatel_plus/app/bootstrap/app_init_status.dart';
import 'package:obywatel_plus/app/bootstrap/logic/tasks.dart';
import 'package:obywatel_plus/app/bootstrap/logic/version/version_models.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/security/device_integrity/device_integrity_facade.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_service.dart';

// 1. Storage Init - używa konkretnych serwisów (bo to warstwa core/infra)
class StorageInitTask implements StartupTask {
  final SecureStorageService storage;
  final SharedPreferencesService prefs;
  final AppDatabase database;

  StorageInitTask({
    required this.storage,
    required this.prefs,
    required this.database, // 2. Wymagamy jej w konstruktorze
  });

  @override
  String get name => 'Storage & Database';

  @override
  Future<AppInitStatus?> initialize() async {
    if (kDebugMode) {
      // await Future.wait([
      //   storage.clearAll(),
      //   prefs.clearAll(),
      //   database.clearDatabase(),
      // ]);

      await storage.debugPrintAll();
      await prefs.debugPrintAll();
    }

    return null;
  }
}

// 2. Security Init - teraz operuje na interfejsie klasy SecurityService
class SecurityInitTask implements StartupTask {
  // Zakładamy, że SecurityNotifier implementuje ten interfejs
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
  final IVersionFacade version; // Zmienione na IVersionFacade

  VersionCheckTask(this.version);

  @override
  String get name => 'Version Check';

  @override
  Future<AppInitStatus?> initialize() async {
    // Najpierw wymuszamy pobranie danych z API
    await version.check();

    if (version.forceUpdate) {
      return const AppInitStatus.forceUpdate();
    }
    return null;
  }
}
