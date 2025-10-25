import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'app/di/injector.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppInjector.setup();

  final storage = sl<SecureStorageService>();

  await storage.debugPrintAll();


  runApp(const ProviderScope(child: ObywatelPlusApp()));
}
