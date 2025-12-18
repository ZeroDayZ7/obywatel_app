import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/auth/presentation/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Witaj ponownie 👋",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  "Zaloguj się do swojego konta",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                const LoginForm(),

                const SizedBox(height: 24),

                TextButton(
                  onPressed: () {},
                  child: const Text("Nie masz konta? Zarejestruj się"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
