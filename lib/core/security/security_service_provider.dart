import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/security/security_service.dart';
import '../../app/di/injector.dart'; // Twój plik z AppInjector

final securityServiceProvider = Provider<SecurityService>((ref) {
  // Pobieramy SecurityService z GetIt
  final service = sl<SecurityService>();

  // Opcjonalnie inicjalizacja od razu (jeśli nie zrobiłeś w AppInjector)
  service.init();

  return service;
});
