// lib/features/splash/presentation/splash_screen.dart
import 'package:flutter/material.dart';
import 'splash_screen_basic.dart';
import 'splash_screen_fancy.dart';
import '../../../app/config/env.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (isProduction) {
      return const SplashScreenFancy();
    } else {
      return const SplashScreenBasic();
    }
  }
}
