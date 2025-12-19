import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/migration_service_provider.dart';
import 'package:obywatel_plus/app/bootstrap/version_providers.dart';
import 'startup_service.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';

final startupServiceProvider = Provider<StartupService>((ref) {
  return StartupService(
    logger: ref.read(appLoggerProvider),
    versionService: ref.read(versionServiceProvider),
    migrationService: ref.read(migrationServiceProvider),
  );
});
