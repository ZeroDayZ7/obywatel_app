// lib/app/bootstrap/bootstrap_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/security/security_provider.dart';
// import 'package:obywatel_plus/app/bootstrap/migration_service.dart';
// import 'package:obywatel_plus/app/bootstrap/version_service.dart';
// import 'package:obywatel_plus/app/bootstrap/startup_service.dart';

final bootstrapProvider = FutureProvider<void>((ref) async {
  final logger = ref.read(appLoggerProvider);
  logger.i('🚀 Inicjalizacja aplikacji startuje...');

  try {
    // 1️⃣ Inicjalizacja secure storage
    final storage = SecureStorageService(const FlutterSecureStorage());
    ref.onDispose(() => logger.i('🔒 SecureStorage disposed'));
    logger.i('🔒 SecureStorage gotowy');

    // 2️⃣ Inicjalizacja SecurityService (lub pobranie z providera)
    final securityService = ref.read(securityServiceProvider(storage));
    await securityService.init();
    logger.i('🛡️ SecurityService gotowy');

    // 3️⃣ (Opcjonalnie) migracje / wersje
    // final migrationService = ref.read(migrationServiceProvider);
    // await migrationService.run();
    // final versionService = ref.read(versionServiceProvider);
    // await versionService.checkForUpdates();

    // 4️⃣ (Opcjonalnie) sprawdzenie sesji użytkownika
    await securityService.checkSession();
    logger.i('✅ Sesja użytkownika sprawdzona');
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
