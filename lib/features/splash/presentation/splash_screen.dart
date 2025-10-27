// lib/features/splash/presentation/splash_screen.dart
import 'package:flutter/material.dart';
import 'splash_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF777777), Color(0xFF353535)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(child: SplashLogo()),
      ),
    );
  }
}
