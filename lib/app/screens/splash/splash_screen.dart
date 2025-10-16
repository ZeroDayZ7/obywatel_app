import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../providers/backend_provider.dart';
import 'splash_logo.dart';
import 'splash_status.dart';
import '../pin_screen.dart';
import '../login_screen.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backendStatus = ref.watch(backendProvider);

    // ref.listen do nawigacji
    ref.listen<BackendStatus>(backendProvider, (previous, next) {
      if (next == BackendStatus.ok) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final storage = FlutterSecureStorage();
          String? pin = await storage.read(key: 'user_pin');
          if (!context.mounted) return;

          if (pin != null && pin.isNotEmpty) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PinScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        });
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2ABF91), Color(0xFF1F8C6E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SplashLogo(),
              SplashStatus(
                isLoading: backendStatus == BackendStatus.loading,
                isError: backendStatus == BackendStatus.error,
                onRetry: () =>
                    ref.read(backendProvider.notifier).checkBackend(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
