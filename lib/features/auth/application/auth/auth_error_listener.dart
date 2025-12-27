import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_error_provider.dart';
// 1. Poprawny import Twojego kontrolera
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';

class AuthErrorListener extends ConsumerWidget {
  final Widget child;

  const AuthErrorListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2. Używamy poprawnego providera: authControllerProvider
    ref.listen(authControllerProvider, (previous, next) {
      // 3. Używamy poprawnego pola 'error' (zamiast errorMessage)
      //    oraz gettera 'isLoading' z AuthState
      if (next.error != null && !next.isLoading) {
        // Sprawdzenie, czy błąd jest nowy (inny niż poprzedni)
        if (previous?.error != next.error) {
          // Konwersja obiektu błędu (Object?) na String i usunięcie prefiksu "Exception: "
          final errorMsg = next.error.toString().replaceAll('Exception: ', '');

          // Wyświetlenie toasta
          ref
              .read(globalNotificationProvider.notifier)
              .show(errorMsg, type: NotificationType.error);

          // Opcjonalnie: wyczyść błąd w kontrolerze, aby stan był czysty
          // ref.read(authControllerProvider.notifier).clearError();
        }
      }
    });

    return child;
  }
}
