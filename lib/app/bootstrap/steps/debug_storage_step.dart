import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_service.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import '../bootstrap_step.dart';

class DebugStorageStep implements BootstrapStep {
  @override
  String get name => 'DebugStorageStep';

  @override
  bool shouldRun(Ref ref) => kDebugMode;

  @override
  Future<void> run(Ref ref) async {
    final logger = ref.read(appLoggerProvider);

    final storage = ref.read(secureStorageProvider);
    final sharedPrefs = await ref.read(sharedPreferencesServiceProvider.future);

    await storage.debugPrintAll();
    await sharedPrefs.debugPrintAll();

    // await storage.clearAll();
    // await sharedPrefs.clearAll();

    logger.i('🧪 ===== Debug storage printed =====');
  }
}
