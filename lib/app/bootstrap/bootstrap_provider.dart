// lib/app/bootstrap/bootstrap_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:obywatel_plus/app/bootstrap/migration_service.dart';
// import 'package:obywatel_plus/app/bootstrap/version_service.dart';
// import 'package:obywatel_plus/app/bootstrap/startup_service.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_service.dart' show sharedPreferencesServiceProvider;
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:flutter_background/flutter_background.dart';

// import 'package:obywatel_plus/features/auth/application/auth_provider.dart';

final bootstrapProvider = FutureProvider<void>((ref) async {
  final logger = ref.read(appLoggerProvider);
  logger.i('🚀 Inicjalizacja aplikacji startuje...');

  try {
    // 🔹 BACKGROUND MODE — najlepiej na samym początku
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "Twoja aplikacja jest aktywna",
      notificationText: "Działa w tle, aby odbierać powiadomienia i połączenia.",
      notificationImportance: AndroidNotificationImportance.normal,
      enableWifiLock: true,
    );

    final hasPermissions = await FlutterBackground.initialize(androidConfig: androidConfig);

    if (hasPermissions) {
      await FlutterBackground.enableBackgroundExecution();
      logger.i('📡 Background mode aktywny');
    } else {
      logger.w('⚠️ Brak zgody na background mode');
    }
    // 🔹 Wyczyszczenie wszystkiego (tylko w debugu/testach)
    if (kDebugMode) {
      final storage = ref.read(secureStorageProvider);
      final sharedPrefs = await ref.read(sharedPreferencesServiceProvider.future);
      await storage.debugPrintAll();
      await sharedPrefs.debugPrintAll();

      // await storage.clearAll();
      // await sharedPrefs.clearAll();
    }

    // 2️ Inicjalizacja SecurityService, Auth**
    final securityService = ref.read(securityServiceProvider.notifier);
    // 🔹 Inicjalizacja SessionService
    final sessionService = ref.read(sessionServiceProvider.notifier);
    // final authNotifier = ref.read(authProvider.notifier);
    // 3️⃣ migracje / wersje
    // final migrationService = ref.read(migrationServiceProvider);
    // final versionService = ref.read(versionServiceProvider);
    await Future.wait([
      securityService.init(),
      sessionService.init(),
      // authNotifier.init(),
      // migrationService.run(),
      // versionService.checkForUpdates(),
    ]);
    logger.i('🔒 SecureStorage gotowy');
    logger.i('🔑 sessionService zainicjalizowany');
  } catch (e, st) {
    logger.e('❌ Błąd podczas inicjalizacji aplikacji', error: e, stackTrace: st);
    rethrow;
  }

  logger.i('✨ Inicjalizacja aplikacji zakończona');
});
