// lib/app/bootstrap/presentation/app_bootstrap_handler.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/app_init_provider.dart';
import 'package:obywatel_plus/app/bootstrap/app_init_status.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/error_app.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/force_update_screen.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/splash_screen.dart';
import 'package:obywatel_plus/core/errors/global_error_listener.dart';
import 'package:obywatel_plus/features/auth/application/session/session_observer.dart'; // Import observera

class AppBootstrapHandler extends ConsumerStatefulWidget {
  final Widget child;

  const AppBootstrapHandler({super.key, required this.child});

  @override
  ConsumerState<AppBootstrapHandler> createState() =>
      _AppBootstrapHandlerState();
}

class _AppBootstrapHandlerState extends ConsumerState<AppBootstrapHandler> {
  @override
  void initState() {
    super.initState();
    // Odpalamy bootstrap po wyrenderowaniu pierwszej klatki
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appInitProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Aktywujemy observera sesji. Będzie działał "w tle" tak długo,
    // jak aplikacja jest uruchomiona i ten widget jest w drzewie.
    ref.watch(sessionObserverProvider);

    // 2. Słuchamy stanu inicjalizacji
    final status = ref.watch(appInitProvider);

    return status.when(
      loading: () => const SplashScreen(),
      blocked: (reason) => ErrorApp(error: reason ?? 'unknown_error'),
      forceUpdate: () => const ForceUpdateScreen(),
      // Poniższe stany oznaczają, że bootstrap się udał i możemy pokazać resztę aplikacji
      unauthenticated: () => GlobalErrorListener(child: widget.child),
      lockedPin: () => GlobalErrorListener(child: widget.child),
      authorized: () => GlobalErrorListener(child: widget.child),
    );
  }
}
