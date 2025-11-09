// lib/features/splash/presentation/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/config/env.dart' show isProduction;
// import 'splash_screen_basic.dart';
import 'splash_screen_fancy.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (isProduction) {
      return const SplashScreenFancy();
    } else {
      // return const SplashScreenBasic();
      return const SplashScreenFancy();
    }
  }
}
