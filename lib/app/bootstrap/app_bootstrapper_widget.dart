import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/bootstrap/app_bootstrapper.dart';
import 'package:obywatel_plus/app/app.dart';
import 'package:obywatel_plus/features/splash/presentation/splash_screen.dart';

class BootstrapApp extends StatefulWidget {
  const BootstrapApp({super.key});

  @override
  State<BootstrapApp> createState() => _BootstrapAppState();
}

class _BootstrapAppState extends State<BootstrapApp> {
  bool _initialized = false;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _fadeInSplash();
    _initApp();
  }

  Future<void> _fadeInSplash() async {
    // mały delay żeby zadziałało AnimatedOpacity
    await Future.delayed(const Duration(milliseconds: 50));
    if (mounted) {
      setState(() => _opacity = 1.0);
    }
  }

  Future<void> _initApp() async {
    await AppBootstrapper.init();
    // wymuszone 3 sekundy splasha
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => _initialized = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _initialized
          ? const ObywatelPlusApp()
          : MaterialApp(
              debugShowCheckedModeBanner: false,
              home: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(seconds: 1),
                child: const SplashScreen(),
              ),
            ),
    );
  }
}
