import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen extends StatelessWidget {
  final String? message;
  final GoRouterState? state;

  const ErrorScreen({super.key, this.message, this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorMsg = message ?? state?.error?.toString() ?? 'Nieznany błąd';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: theme.colorScheme.error,
                size: 72,
              ),
              const SizedBox(height: 24),
              Text(
                'Wystąpił błąd',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                errorMsg,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () {
                  context.go('/home'); // lub AppRoutes.home
                },
                icon: const Icon(Icons.home_outlined),
                label: const Text('Wróć do ekranu głównego'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
