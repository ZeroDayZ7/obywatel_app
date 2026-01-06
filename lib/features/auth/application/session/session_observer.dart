// lib/features/auth/application/session/session_observer.dart

import 'dart:async';

import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/application/session/session_status_provider.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_observer.g.dart';

@riverpod
class SessionObserver extends _$SessionObserver {
  Timer? _inactivityTimer;

  // Konfiguracja czasu bezczynności (np. 5 minut)
  static const _timeout = Duration(minutes: 5);

  @override
  void build() {
    final logger = ref.read(appLoggerProvider);

    // 1. REAKCJA NA WYGAŚNIĘCIE SESJI (Twój kod z 401/Invalid)
    ref.listen(sessionStatusProvider, (previous, next) {
      if (next == SessionStatus.expired) {
        logger.w(
          '⚠️ Session expired (401/Invalid). Triggering force logout...',
        );
        ref.read(authControllerProvider.notifier).logout();
      }
    });

    // 2. SPRZĄTANIE I LOGOWANIE (Twój kod)
    ref.listen(authControllerProvider, (previous, next) {
      next.maybeMap(
        unauthenticated: (_) {
          logger.i('👋 Cleaning up session and stopping timer');
          _inactivityTimer?.cancel(); // Zatrzymujemy timer po wylogowaniu
          ref.read(sessionStatusProvider.notifier).reset();
        },
        // Gdy użytkownik pomyślnie wejdzie do aplikacji, odpalamy timer
        authenticated: (_) => onUserInteraction(),
        orElse: () {},
      );
    });

    // Zabezpieczenie przed wyciekiem pamięci
    ref.onDispose(() => _inactivityTimer?.cancel());
  }

  /// Metoda wołana przy każdym dotknięciu ekranu w AppBootstrapHandler
  void onUserInteraction() {
    // Sprawdzamy tylko czy użytkownik jest zalogowany
    final authState = ref.read(authControllerProvider);
    final isUserActive = authState.maybeMap(
      authenticated: (_) => true,
      orElse: () => false,
    );

    if (!isUserActive) return;

    // Resetujemy timer
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_timeout, () => _handleInactivity());
  }

  /// Wyzwalane, gdy przez 5 minut nie było żadnego dotyku
  void _handleInactivity() {
    final logger = ref.read(appLoggerProvider);
    logger.i(
      '⏰ User inactive for ${_timeout.inMinutes} min. Locking application...',
    );

    // Zmieniamy stan w SecurityService na zablokowany
    // Router automatycznie przekieruje na ekran PIN
    ref.read(securityServiceProvider.notifier).lockApp();
  }
}
