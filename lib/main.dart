import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'app/di/injector.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:dargon2_flutter/dargon2_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppInjector.setup();

  final storage = sl<SecureStorageService>();

  await storage.debugPrintAll();

  DArgon2Flutter.init();
  runApp(const ProviderScope(child: ObywatelPlusApp()));
}
