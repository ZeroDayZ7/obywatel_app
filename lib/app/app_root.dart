import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/app.dart';
import 'package:obywatel_plus/app/bootstrap/bootstrap_provider.dart';
// import 'package:obywatel_plus/core/security/security_service_provider.dart';
import 'package:obywatel_plus/features/splash/presentation/splash_screen.dart';

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obserwuj stan inicjalizacji
    final bootstrap = ref.watch(bootstrapProvider);
    // Użyj .when() Riverpoda do obsługi stanów
    return bootstrap.when(
      // Kiedy inicjalizacja trwa, pokaż Splash
      loading: () => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(), // Możesz tu dodać swoje AnimedOpacity
      ),

      // Kiedy wystąpi błąd inicjalizacji
      error: (error, stackTrace) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: Text('Błąd inicjalizacji aplikacji: $error')),
        ),
      ),

      // Kiedy inicjalizacja się powiedzie
      data: (_) => const ObywatelPlusApp(),
      // data: (_) {
      //   final securityState = ref.watch(securityServiceProvider);
      //   if (!securityState.initialized) {
      //     return const MaterialApp(home: SplashScreen());
      //   }
      //   return const ObywatelPlusApp();
      // },
    );
  }
}
