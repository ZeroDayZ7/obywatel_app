import 'dart:async';

import 'package:obywatel_plus/app/config/env.dart';
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

  late final Duration _timeout = apiConstants.inactivityTimeout;

  @override
  void build() {
    final logger = ref.read(appLoggerProvider);

    ref.listen(sessionStatusProvider, (previous, next) {
      if (next == SessionStatus.expired) {
        logger.w(
          '⚠️ Session expired (401/Invalid). Triggering force logout...',
        );
        ref.read(authControllerProvider.notifier).logout();
      }
    });

    ref.listen(authControllerProvider, (previous, next) {
      next.maybeMap(
        unauthenticated: (_) {
          final wasAuthenticating = previous?.isLoading ?? false;

          if (!wasAuthenticating) {
            logger.i('👋 Cleaning up session and stopping timer');
            _inactivityTimer?.cancel();
            ref.read(sessionStatusProvider.notifier).reset();
          } else {
            logger.d(
              '❌ Login failed (previous was authenticating) - skipping cleanup',
            );
          }
        },

        authenticated: (_) => onUserInteraction(),
        orElse: () {},
      );
    });

    // 🚀 INICJALIZACJA STOPERAR PRZY STARCIENIE:
    // Jeśli observer montuje się, gdy user jest już uwierzytelniony,
    // od razu uruchamiamy timer bez czekania na zmianę stanu w ref.listen.
    final initialAuthState = ref.read(authControllerProvider);
    initialAuthState.maybeMap(
      authenticated: (_) => onUserInteraction(),
      orElse: () {},
    );

    ref.onDispose(() => _inactivityTimer?.cancel());
  }

  void onUserInteraction() {
    final authState = ref.read(authControllerProvider);
    final isUserActive = authState.maybeMap(
      authenticated: (_) => true,
      orElse: () => false,
    );

    if (!isUserActive) return;

    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_timeout, () => _handleInactivity());
  }

  void _handleInactivity() {
    final logger = ref.read(appLoggerProvider);
    logger.i(
      '⏰ User inactive for ${_timeout.inMinutes} min. Locking application...',
    );

    ref.read(securityServiceProvider.notifier).lockApp();
  }
}
