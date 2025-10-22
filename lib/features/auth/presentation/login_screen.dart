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

    try {
      final authApi = sl<AuthApi>();
      final storage = sl<SecureStorageService>();

      // Wywołanie API i pobranie tokenu oraz flagi 2FA
      final response = await authApi.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      final token = response['token'] as String;
      final twoFaRequired = response['2fa_required'] as bool;

      // Zapis tokenu w secure storage
      await storage.write('user_token', token);

      // Aktualizacja stanu globalnego providerem
      ref.read(authProvider.notifier).login(token);

      if (!mounted) return;

      // Jeśli wymagana jest 2FA → przekierowanie do PIN/2FA
      if (twoFaRequired) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          context.go(AppRoutes.pin);
        });
        return;
      }

      // Przekierowanie po zwykłym logowaniu
      context.go(AppRoutes.home);
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
