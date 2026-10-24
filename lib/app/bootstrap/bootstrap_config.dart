import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/logic/startup_task.dart';
import 'package:obywatel_plus/app/bootstrap/logic/tasks.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';

class BootstrapConfig {
  final List<StartupTask> sequentialTasks;
  final List<StartupTask> parallelTasks;

  const BootstrapConfig({
    required this.sequentialTasks,
    this.parallelTasks = const [],
  });
}

final bootstrapConfigProvider = Provider<BootstrapConfig>((ref) {
  // DEVELOPMENT RESET: odkomentuj na jeden start, aby zresetować lokalne dane,
  // a następnie ponownie zakomentuj, żeby aplikacja normalnie zachowała dane.
  const developerResetEnabled = false;
  // const developerResetEnabled = true;

  return BootstrapConfig(
    sequentialTasks: [
      StorageInitTask(
        storage: ref.read(secureStorageProvider),
        prefs: ref.read(activePrefsProvider),
        developerResetEnabled: developerResetEnabled,
      ),
      // MigrationTask(ref.read(migrationServiceProvider)),
      SecurityInitTask(ref.read(securityServiceProvider.notifier)),
    ],
  );
});
