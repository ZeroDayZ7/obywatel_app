import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/app.dart';
import 'package:obywatel_plus/app/bootstrap/bootstrap_provider.dart';
// import 'package:obywatel_plus/core/security/security_service_provider.dart';
import 'package:obywatel_plus/features/splash/presentation/splash_screen.dart';

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  /// Builds the root widget with animated transitions between app states.
  /// Uses Riverpod's AsyncValue.when() wrapped in AnimatedSwitcher for smooth UX.
  /// Each state widget has a unique ValueKey to trigger animations on changes.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the bootstrap provider for initialization state.
    final bootstrap = ref.watch(bootstrapProvider);

    // Wrap states in AnimatedSwitcher for cross-fade/scale transitions.
    // Customize transitionBuilder for fade effect (professional smooth switch).
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300), // Short, snappy animation.
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        // Fade transition for seamless screen switches (avoids jarring cuts).
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1), // Subtle slide-up from bottom.
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: bootstrap.when(
        // Loading state: Full splash app with unique key.
        loading: () =>
            _buildSplashApp(key: const ValueKey('bootstrap_loading')),

        // Error state: Simple error screen with unique key.
        error: (error, stackTrace) => _buildErrorApp(
          key: const ValueKey('bootstrap_error'),
          error: error.toString(),
        ),

        // Success state: Main app with unique key.
        data: (_) => const ObywatelPlusApp(key: ValueKey('bootstrap_data')),
      ),
    );
  }

  /// Builds a standalone MaterialApp for splash/loading.
  /// No router needed during init – keeps it lightweight.
  static Widget _buildSplashApp({required Key key}) {
    return MaterialApp(
      key: key,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      // Optional: Share base theme here if extracted globally.
      // theme: AppTheme.lightTheme, // Extract from app_theme.dart for consistency.
    );
  }

  /// Builds a standalone MaterialApp for errors.
  /// Displays error with retry option (professional: user can act).
  static Widget _buildErrorApp({required Key key, required String error}) {
    return MaterialApp(
      key: key,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Błąd inicjalizacji aplikacji',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Professional: Retry bootstrap (requires Consumer context, but simulate restart).
                    // In full impl: Use ref.invalidate(bootstrapProvider) if in Consumer.
                    // For now, placeholder – restart app or retry init.
                  },
                  child: const Text('Spróbuj ponownie'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
