import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/di/injector.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'splash_logo.dart';
import 'package:obywatel_plus/features/splash/application/splash_service.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';



class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late final SplashService _splashService;
  late final AppLogger _logger;

  @override
  void initState() {
    super.initState();
    _logger = sl<AppLogger>();
    _splashService = SplashService(sl<SecureStorageService>());

    _navigate();
  }

  Future<void> _navigate() async {
    try {
      final route = await _splashService.determineInitialRoute();
      _logger.i('SplashScreen → nawigacja do: $route');
      if (mounted) context.go(route);
    } catch (e, st) {
      _logger.e('Błąd SplashScreen', error: e, stackTrace: st);
      if (mounted) context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 119, 119, 119),
              Color.fromARGB(255, 53, 53, 53),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(child: SplashLogo()),
      ),
    );
  }
}
