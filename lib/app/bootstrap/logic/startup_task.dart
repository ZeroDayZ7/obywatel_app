import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/app_init_status.dart';
import 'package:obywatel_plus/app/bootstrap/logic/tasks.dart';
import 'package:obywatel_plus/app/bootstrap/version_notifier.dart';
import 'package:obywatel_plus/core/security/application/device_integrity_facade.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_service.dart';

// 1️⃣ Inicjalizacja Storage (musi być pierwsza)
class StorageInitTask implements StartupTask {
  @override
  String get name => 'Storage & Prefs';

  @override
  Future<AppInitStatus?> initialize(Ref ref) async {
    // Rozgrzewanie instancji (AsyncProvider / FutureProvider)
    final storage = ref.read(secureStorageProvider);
    final sharedPrefs = await ref.read(sharedPreferencesServiceProvider.future);

    // Opcjonalne: debug printy (z Twojego kodu)
    await storage.debugPrintAll();
    await sharedPrefs.debugPrintAll();

    // await storage.clearAll();
    // await sharedPrefs.clearAll();

    return null; // OK
  }
}

// 2️⃣ Inicjalizacja Security (musi być po Storage, bo czyta z niego klucze)
class SecurityInitTask implements StartupTask {
  @override
  String get name => 'Security Service';

  @override
  Future<AppInitStatus?> initialize(Ref ref) async {
    final security = ref.read(securityServiceProvider.notifier);
    await security.init();
    return null; // OK
  }
}

// 3️⃣ Sprawdzenie integralności urządzenia
class DeviceIntegrityTask implements StartupTask {
  @override
  String get name => 'Device Integrity';

  @override
  Future<AppInitStatus?> initialize(Ref ref) async {
    final deviceService = ref.read(deviceIntegrityServiceProvider);

    // [cite: 14] Sprawdzenie Root/Jailbreak
    if (!await deviceService.isDeviceAllowed()) {
      return const AppInitStatus.blocked(reason: 'device_integrity');
    }
    return null; // OK
  }
}

// 4️⃣ Sprawdzenie wersji (Force Update)
class VersionCheckTask implements StartupTask {
  @override
  String get name => 'Version Check';

  @override
  Future<AppInitStatus?> initialize(Ref ref) async {
    final versionState = ref.read(versionNotifierProvider);

    // [cite: 15] Jeśli wymuszona aktualizacja -> przerywamy bootstrap
    if (versionState.forceUpdate) {
      return const AppInitStatus.forceUpdate();
    }
    return null; // OK
  }
}
