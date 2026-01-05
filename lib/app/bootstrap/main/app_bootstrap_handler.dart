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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appInitProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(sessionObserverProvider);

    final status = ref.watch(appInitProvider);

    return status.when(
      loading: () => const SplashScreen(),
      blocked: (reason) => ErrorApp(error: reason ?? 'unknown_error'),
      forceUpdate: () => const ForceUpdateScreen(),
      unauthenticated: () => GlobalErrorListener(child: widget.child),
      lockedPin: () => GlobalErrorListener(child: widget.child),
      authorized: () => GlobalErrorListener(child: widget.child),
    );
  }
}
