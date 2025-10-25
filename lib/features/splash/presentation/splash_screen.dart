import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'splash_logo.dart';
import 'package:obywatel_plus/app/di/injector.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final _storage = const FlutterSecureStorage();
  late final AppLogger _logger;

  @override
  void initState() {
    super.initState();
    _logger = sl<AppLogger>(); // inicjalizacja loggera z DI
    _logger.i('SplashScreen: initState');

    _initApp();
  }

  Future<void> _initApp() async {
    try {
      _logger.i('SplashScreen: Sprawdzanie tokena i ustawień lokalnych');

      // 1️⃣ Sprawdzenie tokena (sesji)
      final token = await _storage.read(key: 'accessToken');
      final hasSession = token != null && token.isNotEmpty;
      _logger.i('Token: ${token ?? "brak"}, hasSession=$hasSession');

      // 2️⃣ Sprawdzenie lokalnych zabezpieczeń
      final pin = await _storage.read(key: 'user_pin');
      final hasLocalLock = pin != null && pin.isNotEmpty;
      _logger.i('PIN: ${pin ?? "brak"}, hasLocalLock=$hasLocalLock');

      final biometricEnabled = await _storage.read(key: 'biometric') == 'true';
      _logger.i('Biometria włączona: $biometricEnabled');

      if (!mounted) return;

      // 3️⃣ Logika nawigacji
      if (!hasSession) {
        _logger.i('Brak sesji → przejście do LoginScreen');
        context.go(AppRoutes.login);
      } else if (!hasLocalLock) {
        _logger.i('Brak PIN → przejście do SecuritySetupScreen');
        context.go(AppRoutes.securitySetup);
      } else if (biometricEnabled) {
        _logger.i('PIN/biometria aktywna → przejście do PinScreen');
        context.go(AppRoutes.pin);
      } else {
        _logger.i('Wszystko ustawione → przejście do HomeScreen');
        context.go(AppRoutes.home);
      }
    } catch (e, st) {
      _logger.e(
        'Błąd podczas inicjalizacji SplashScreen',
        error: e,
        stackTrace: st,
      );
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
