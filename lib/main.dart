import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'app/di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppInjector.setup();

  runApp(const ProviderScope(child: ObywatelPlusApp()));
}
