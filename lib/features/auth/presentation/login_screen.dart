import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/providers/auth_provider.dart';

import 'package:obywatel_plus/app/di/injector.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/features/auth/data/remote/auth_api.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(
    text: ApiConstants.defaultEmail,
  );
  final TextEditingController _passwordController = TextEditingController(
    text: ApiConstants.defaultPassword,
  );

  bool _isLoading = false;

  Future<void> _login() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final logger = sl<AppLogger>();
    final authApi = sl<AuthApi>();
    final storage = sl<SecureStorageService>();

    try {
      // 1️⃣ Wywołanie API logowania
      final response = await authApi.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      final token = response['token'] as String;

      // 2️⃣ Zapis tokenu i aktualizacja providera
      await storage.write(key: 'accessToken', value: token);
      ref.read(authProvider.notifier).login(token);

      if (!mounted) return;

      // 3️⃣ Sprawdzenie lokalnych zabezpieczeń
      await _navigateAfterLogin(storage);
    } on DioException catch (e) {
      logger.e('DioException during login', error: e, stackTrace: e.stackTrace);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Nieprawidłowe dane")));
    } catch (e, st) {
      logger.e('Unexpected error during login', error: e, stackTrace: st);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Coś poszło nie tak, spróbuj ponownie")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _navigateAfterLogin(SecureStorageService storage) async {
    final pin = await storage.read(key: 'user_pin');
    final hasLocalLock = pin != null && pin.isNotEmpty;
    final biometricEnabled = await storage.read(key: 'biometric') == 'true';

    if (!mounted) return;

    if (!hasLocalLock) {
      context.go(AppRoutes.securitySetup); // brak PIN → setup
    } else if (biometricEnabled) {
      context.go(AppRoutes.pin); // PIN/biometria włączona → ekran blokady
    } else {
      context.go(AppRoutes.home); // wszystko ustawione → home
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
