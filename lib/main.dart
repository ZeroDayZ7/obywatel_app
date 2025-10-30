// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/app_bootstrapper_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- Inicjalizacja DI i serwisów ---
  // await AppBootstrapper.init();

  // --- Uruchomienie aplikacji ---
  runApp(const ProviderScope(child: BootstrapApp()));
}
