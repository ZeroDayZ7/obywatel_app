import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './login_screen_basic.dart';
import './login_screen_fancy.dart';
import 'package:obywatel_plus/app/config/env.dart' show apiConstants;

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          // Pasek statusu serwera
          SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Text(
                apiConstants.serverOnline
                    ? '✅ Serwer online'
                    : '❌ Serwer offline',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          // Login widget w środku
          Expanded(
            child: apiConstants.isProduction
                ? const FancyLoginWidget()
                : const BasicLoginWidget(),
          ),
        ],
      ),
    );
  }
}
