import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/migration_service.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';

final migrationServiceProvider = Provider<MigrationService>((ref) {
  return MigrationService(
    ref.read(secureStorageProvider),
    ref.read(appLoggerProvider),
  );
});
