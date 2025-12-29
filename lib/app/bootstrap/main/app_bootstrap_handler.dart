// lib/app/bootstrap/presentation/app_bootstrap_handler.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/app_init_provider.dart';
import 'package:obywatel_plus/app/bootstrap/app_init_status.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/error_app.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/force_update_screen.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/splash_screen.dart';
import 'package:obywatel_plus/core/errors/global_error_listener.dart';

class AppBootstrapHandler extends ConsumerWidget {
  final Widget child;

  const AppBootstrapHandler({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(appInitProvider);

    return status.when(
      loading: () => const SplashScreen(),
      blocked: (reason) => ErrorApp(error: reason ?? 'unknown_error'),
      forceUpdate: () => const ForceUpdateScreen(),
      unauthenticated: () => GlobalErrorListener(child: child),
      lockedPin: () => GlobalErrorListener(child: child),
      authorized: () => GlobalErrorListener(child: child),
    );
  }
}
