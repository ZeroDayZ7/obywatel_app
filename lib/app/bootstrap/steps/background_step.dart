import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:obywatel_plus/app/bootstrap/bootstrap_step.dart';
import 'package:obywatel_plus/core/core_providers.dart';

class BackgroundStep extends BootstrapStep {
  @override
  String get name => 'BackgroundStep';

  @override
  Future<void> run(Ref ref) async {
    final logger = ref.read(appLoggerProvider);

    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "Twoja aplikacja jest aktywna",
      notificationText:
          "Działa w tle, aby odbierać powiadomienia i połączenia.",
      notificationImportance: AndroidNotificationImportance.normal,
      enableWifiLock: true,
    );

    final hasPermissions = await FlutterBackground.initialize(
      androidConfig: androidConfig,
    );

    if (hasPermissions) {
      await FlutterBackground.enableBackgroundExecution();
      logger.i('📡 Background mode aktywny');
    } else {
      logger.w('⚠️ Brak zgody na background mode');
    }
  }
}
