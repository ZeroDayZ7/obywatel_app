import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/auth/application/session/session_status_provider.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_observer.g.dart';

@riverpod
void sessionObserver(Ref ref) {
  final logger = ref.read(appLoggerProvider);
  final sessionService = ref.read(sessionServiceProvider);

  // 1. Reagujemy na wygaśnięcie sesji zgłoszone przez Interceptor
  ref.listen(sessionStatusProvider, (previous, next) {
    if (next == SessionStatus.expired) {
      logger.w('⚠️ Session expired (401/Invalid). Triggering force logout...');
      ref.read(authControllerProvider.notifier).logout();
    }
  });

  // 2. Obsługa persystencji sesji i sprzątania
  ref.listen(authControllerProvider, (previous, next) {
    next.maybeMap(
      authenticated: (auth) async {
        if (auth.accessToken != null && auth.refreshToken != null) {
          try {
            await sessionService.saveSession(
              accessToken: auth.accessToken!,
              refreshToken: auth.refreshToken!,
              userId: auth.userId.toString(),
            );
            logger.i('✅ Session persisted securely via Observer');
          } catch (e) {
            logger.e('❌ Session persistence failed', error: e);
          }
        }
      },
      unauthenticated: (_) {
        // Logika czyszczenia po wylogowaniu
        logger.i('👋 User unauthenticated - Observer cleanup');
        // Resetujemy status sesji na aktywny (gotowy dla nowego logowania)
        ref.read(sessionStatusProvider.notifier).reset();
      },
      orElse: () {},
    );
  });
}
