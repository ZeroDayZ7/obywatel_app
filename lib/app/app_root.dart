import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/app.dart';
import 'package:obywatel_plus/app/bootstrap/bootstrap_provider.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/error_app.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/splash_app.dart';

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(bootstrapProvider);

    return bootstrap.when(
      loading: () => const SplashApp(),
      error: (error, stackTrace) {
        return ErrorApp(error: error.toString(), ref: ref);
      },
      data: (_) => const ObywatelPlusApp(key: ValueKey('bootstrap_data')),
    );
  }
}
