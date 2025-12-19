import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/force_update_provider.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/app/bootstrap/version_service.dart';
import 'package:obywatel_plus/app/bootstrap/migration_service.dart';

class StartupService {
  final AppLogger _logger;
  final VersionService _versionService;
  final MigrationService _migrationService;

  const StartupService({
    required AppLogger logger,
    required VersionService versionService,
    required MigrationService migrationService,
  }) : _logger = logger,
       _versionService = versionService,
       _migrationService = migrationService;

  /// 🔑 Ref przekazywany z StartupStep
  Future<void> run(Ref ref) async {
    _logger.i('StartupService: starting initialization');

    try {
      await _checkVersion(ref);
      await _migrationService.performMigrations();

      _logger.i('StartupService: initialization finished');
    } catch (e, st) {
      _logger.e('StartupService failed', error: e, stackTrace: st);
      // ❗ Celowo nie rzucamy dalej – app ma się uruchomić
    }
  }

  Future<void> _checkVersion(Ref ref) async {
    final current = await _versionService.currentVersion();
    final minimum = await _versionService.fetchMinimumSupportedVersion();

    _logger.i('Version check: current=$current, minimum=$minimum');

    final needsUpdate = _versionService.isBelowMinimum(current, minimum);

    if (needsUpdate) {
      ref.read(forceUpdateProvider.notifier).requireUpdate();
      _logger.w('🚨 Force update required');
    }
  }
}
