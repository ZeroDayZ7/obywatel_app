// lib/features/auth/presentation/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/config/env.dart';
// import 'package:obywatel_plus/app/config/storage_keys.dart';
import 'package:obywatel_plus/app/di/injector.dart';
import 'package:obywatel_plus/features/auth/application/auth_provider.dart';
import 'package:obywatel_plus/features/auth/state/login/login_state.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_service.dart';
// import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final AuthService _authService;

  final TextEditingController _emailController = TextEditingController(
    text: apiConstants.defaultEmail,
  );
  final TextEditingController _passwordController = TextEditingController(
    text: apiConstants.defaultPassword,
  );

  @override
  void initState() {
    super.initState();
    // inicjalizacja LoginService przez DI
    _authService = sl<AuthService>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // przykładowy _onLogin
  Future<void> _onLogin() async {
    final loginNotifier = ref.read(loginStateProvider.notifier);
    final authNotifier = ref.read(authProvider.notifier);
    final logger = sl<AppLogger>();

    loginNotifier.setLoading(true);
    loginNotifier.setError(null);

    try {
      final result = await _authService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (result.success) {
        authNotifier.login();
      } else {
        loginNotifier.setError('Login failed: ${result.error}');
      }
    } catch (e, st) {
      logger.e('Unexpected login error', error: e, stackTrace: st);
      loginNotifier.setError('Unexpected error');
    } finally {
      loginNotifier.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginStateProvider);
    final isLoading = loginState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // zamiast center
              children: [
                const SizedBox(height: 80),
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
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
                  onPressed: isLoading ? null : _onLogin,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login"),
                ),
                if (loginState.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      loginState.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 50), // margines od dołu
              ],
            ),
          ),
        ),
      ),
    );
  }
}
