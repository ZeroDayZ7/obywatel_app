import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/app.dart';
import 'package:obywatel_plus/app/di/injector.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
// import 'package:obywatel_plus/core/utils/device_info_service.dart';

class AppBootstrapper {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await AppInjector.setup();

    final storage = sl<SecureStorageService>();
    assert(() {
      storage.debugPrintAll();
      return true;
    }());

    // final deviceService = DeviceInfoService();
    // await deviceService.collectDeviceInfo();

    // await storage.clearAll();
    // final all = await storage.readAll();
    // assert(all.isEmpty);
    // await Future.delayed(const Duration(milliseconds: 300));
  }

  static void run() {
    runApp(const ProviderScope(child: ObywatelPlusApp()));
  }
}
