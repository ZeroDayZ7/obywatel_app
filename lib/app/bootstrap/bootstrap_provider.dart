// lib/app/bootstrap/bootstrap_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:obywatel_plus/app/bootstrap/migration_service.dart';
// import 'package:obywatel_plus/app/bootstrap/version_service.dart';
// import 'package:obywatel_plus/app/bootstrap/startup_service.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
// import 'package:obywatel_plus/features/auth/application/auth_provider.dart';

final bootstrapProvider = FutureProvider<void>((ref) async {
  final logger = ref.read(appLoggerProvider);
  logger.i('🚀 Inicjalizacja aplikacji startuje...');

  try {
    // 🔹 Wyczyszczenie wszystkiego (tylko w debugu/testach)
    if (kDebugMode) {
      final storage = ref.read(secureStorageProvider);
      final sharedPrefs = await ref.read(
        sharedPreferencesServiceProvider.future,
      );
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
    logger.e(
      '❌ Błąd podczas inicjalizacji aplikacji',
      error: e,
      stackTrace: st,
    );
    rethrow;
  }

  logger.i('✨ Inicjalizacja aplikacji zakończona');
});
