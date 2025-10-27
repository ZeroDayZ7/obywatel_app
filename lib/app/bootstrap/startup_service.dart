// lib/app/bootstrap/startup_service.dart
import 'dart:async';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/api_client.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/app/bootstrap/version_service.dart';
import 'package:obywatel_plus/app/bootstrap/migration_service.dart';
import 'package:obywatel_plus/app/bootstrap/remote_config_service.dart';

class StartupService {
  final SecureStorageService _storage;
  final ApiClient _api; // ignore: unused_field
  final AppLogger _logger;
  final VersionService _versionService;
  final MigrationService _migrationService;
  final RemoteConfigService _remoteConfig;

  const StartupService({
    required SecureStorageService storage,
    required ApiClient api,
    required AppLogger logger,
    required VersionService versionService,
    required MigrationService migrationService,
    required RemoteConfigService remoteConfigService,
  }) : _storage = storage,
       _api = api,
       _logger = logger,
       _versionService = versionService,
       _migrationService = migrationService,
       _remoteConfig = remoteConfigService;

  /// Główny entry - wykona wszystkie startupowe kroki.
  Future<void> run() async {
    _logger.i('StartupService: starting initialization');

    try {
      // 1. Sprawdź wersję aplikacji i ewentualnie wymuś upgrade / alert
      await _runWithTimeout(
        _checkVersion(),
        'checkVersion',
        Duration(seconds: 8),
      );

      // 2. Wykonaj migracje storage
      await _runWithTimeout(
        _migrationService.performMigrations(),
        'migrations',
        Duration(seconds: 10),
      );

      // 3. Pobierz konfigurację z serwera (theme, komunikaty)
      await _runWithRetry(
        () => _remoteConfig.fetchRemoteConfig(),
        retries: 2,
        delay: Duration(seconds: 2),
      );

      _logger.i('StartupService: initialization finished');
    } catch (e, st) {
      _logger.e('StartupService failed', error: e, stackTrace: st);
      // Nie rzucamy dalej — aplikacja powinna nadal się uruchomić, lecz w trybie ograniczonym.
    }
  }

  Future<void> _checkVersion() async {
    final current = await _versionService.currentVersion();
    final server = await _versionService.fetchMinimumSupportedVersion();

    _logger.i('Version check: current=$current, minimumSupported=$server');

    if (_versionService.isBelowMinimum(current, server)) {
      // Możesz tutaj wyrzucić flagę do storage, którą potem splash/launcher odczyta i pokaże dialog
      await _storage.write(key: 'force_update_required', value: 'true');
      _logger.w('App version below minimum supported. Forcing update flow.');
    } else {
      await _storage.write(key: 'force_update_required', value: 'false');
    }
  }

  Future<T> _runWithTimeout<T>(
    Future<T> future,
    String name,
    Duration timeout,
  ) {
    return future.timeout(
      timeout,
      onTimeout: () {
        final err = Exception('Startup step [$name] timed out after $timeout');
        _logger.w(err.toString());
        throw err;
      },
    );
  }

  Future<T> _runWithRetry<T>(
    Future<T> Function() fn, {
    int retries = 1,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempt = 0;
    while (true) {
      attempt++;
      try {
        return await fn();
      } catch (e, st) {
        _logger.w(
          'Attempt $attempt failed for startup network call',
          error: e,
          stackTrace: st,
        );
        if (attempt > retries) rethrow;
        await Future.delayed(delay);
      }
    }
  }
}
