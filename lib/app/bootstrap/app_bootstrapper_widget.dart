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

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await AppBootstrapper.init();
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
          : const MaterialApp(
              home: SplashScreen(),
              debugShowCheckedModeBanner: false,
            ),
    );
  }
}
