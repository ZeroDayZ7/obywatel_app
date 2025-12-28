import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/app_init_status.dart';
import 'package:obywatel_plus/app/bootstrap/version_notifier.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/application/device_integrity_facade.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_service.dart';

final appInitProvider = NotifierProvider<AppInitNotifier, AppInitStatus>(
  AppInitNotifier.new,
);

class AppInitNotifier extends Notifier<AppInitStatus> {
  @override
  AppInitStatus build() {
    _bootstrap();
    return const AppInitStatus.loading();
  }

  Future<void> _bootstrap() async {
    try {
      final deviceService = ref.read(deviceIntegrityServiceProvider);
      final versionState = ref.read(versionNotifierProvider);
      final logger = ref.read(appLoggerProvider);
      final security = ref.read(securityServiceProvider.notifier);

      // 🔹 DEBUG: print wszystko ze storage
      final storage = ref.read(secureStorageProvider);
      final sharedPrefs = await ref.read(
        sharedPreferencesServiceProvider.future,
      );

      await storage.debugPrintAll();
      await sharedPrefs.debugPrintAll();

      // await storage.clearAll();
      // await sharedPrefs.clearAll();

      await security.init();

      logger.i('🧪 ===== Debug storage printed =====');

      // 1️⃣ Device
      if (!await deviceService.isDeviceAllowed()) {
        state = const AppInitStatus.blocked(reason: 'device_integrity');
        return;
      }

      // 2️⃣ FORCE UPDATE
      if (versionState.forceUpdate) {
        state = const AppInitStatus.forceUpdate();
        return;
      }

      // 3️⃣ Wszystko OK → bootstrap zakończony
      state = const AppInitStatus.authorized();
    } catch (e) {
      state = AppInitStatus.blocked(reason: e.toString());
    }
  }

  /// Ponowne sprawdzenie stanu inicjalizacji
  Future<void> recheck() async {
    state = const AppInitStatus.loading();
    await _bootstrap();
  }
}
