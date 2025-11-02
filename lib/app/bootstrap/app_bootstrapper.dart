// lib/app/bootstrap/app_bootstrapper.dart
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/di/injector.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/security/security_service.dart';

class AppBootstrapper {
  static bool get isProduction => bool.fromEnvironment('dart.vm.product');

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      await AppInjector.setup();
      sl<AppLogger>().i('AppInjector setup finished ✅');
    } catch (e, st) {
      if (isProduction) {
        rethrow;
      } else {
        debugPrint('AppInjector setup failed: $e');
        debugPrintStack(stackTrace: st);
      }
    }

    try {
      await sl<SecurityService>().init();
    } catch (e, st) {
      sl<AppLogger>().e(
        'SecurityService init failed',
        error: e,
        stackTrace: st,
      );
    }
    // --- StartupService ---
    // try {
    //   await sl<StartupService>().run();
    // } catch (e, st) {
    //   // Logging is already done inside StartupService;
    //   sl<AppLogger>().w(
    //     'AppBootstrapper: startupService failed but continuing',
    //     error: e,
    //     stackTrace: st,
    //   );
    // }

    // final deviceService = DeviceInfoService();
    // await deviceService.collectDeviceInfo();

    // await storage.clearAll();
    // final all = await storage.readAll();
    // assert(all.isEmpty);
    // await Future.delayed(const Duration(milliseconds: 300));
    final storage = sl<SecureStorageService>();
    await storage.clearAll();
    // await storage.readAll();
    assert(() {
      storage.debugPrintAll();
      return true;
    }());
  }
}
