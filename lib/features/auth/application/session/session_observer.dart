import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/application/session/session_status_provider.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_observer.g.dart';

@riverpod
void sessionObserver(Ref ref) {
  final logger = ref.read(appLoggerProvider);

  // 1. Reagujemy na wygaśnięcie sesji zgłoszone przez Interceptor
  ref.listen(sessionStatusProvider, (previous, next) {
    if (next == SessionStatus.expired) {
      logger.w('⚠️ Session expired (401/Invalid). Triggering force logout...');
      ref.read(authControllerProvider.notifier).logout();
    }
  });

  // 2. Obsługa persystencji sesji i sprzątania
  ref.listen(sessionStatusProvider, (previous, next) {
    if (next == SessionStatus.expired) {
      logger.w('⚠️ Session expired. Forcing logout...');
      ref.read(authControllerProvider.notifier).logout();
    }
  });

  // Tylko logowanie i sprzątanie stanów pomocniczych
  ref.listen(authControllerProvider, (previous, next) {
    next.maybeMap(
      unauthenticated: (_) {
        logger.i('👋 Cleaning up session status');
        ref.read(sessionStatusProvider.notifier).reset();
      },
      orElse: () {},
    );
  });
}
