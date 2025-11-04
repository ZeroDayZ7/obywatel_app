// lib/app/bootstrap/bootstrap_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:obywatel_plus/app/bootstrap/migration_service.dart';
// import 'package:obywatel_plus/app/bootstrap/version_service.dart';
// import 'package:obywatel_plus/app/bootstrap/startup_service.dart';
import 'package:obywatel_plus/core/core_providers.dart';

final bootstrapProvider = FutureProvider<void>((ref) async {
  final logger = ref.read(appLoggerProvider);
  logger.i('🚀 Inicjalizacja aplikacji startuje...');

  try {
    // 1️⃣ Pobranie SecureStorageService z providera
    final storage = ref.read(secureStorageProvider);

    // 🔹 Opcjonalne wyczyszczenie wszystkiego (tylko w debugu/testach)
    if (kDebugMode) {
      // await storage.clearAll(); // odkomentuj jeśli chcesz wyczyścić w debug
      await storage.debugPrintAll();
    }

    logger.i('🔒 SecureStorage gotowy');

    // 2️⃣ Inicjalizacja SecurityService
    final securityService = ref.read(securityServiceProvider.notifier);
    await securityService.init();
    logger.i('🛡️ SecurityService gotowy');

    // 3️⃣ (Opcjonalnie) migracje / wersje
    // final migrationService = ref.read(migrationServiceProvider);
    // await migrationService.run();
    // final versionService = ref.read(versionServiceProvider);
    // await versionService.checkForUpdates();
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
