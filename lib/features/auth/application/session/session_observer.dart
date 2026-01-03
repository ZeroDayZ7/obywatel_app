import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_observer.g.dart';

@riverpod
void sessionObserver(Ref ref) {
  final logger = ref.read(appLoggerProvider);
  final sessionService = ref.read(sessionServiceProvider);

  // Słuchamy zmian w AuthController
  ref.listen(authControllerProvider, (previous, next) {
    next.maybeMap(
      authenticated: (auth) async {
        // Sprawdzamy stan security w momencie zmiany auth
        final securityState = ref.read(securityServiceProvider);

        if (securityState.isSetupCompleted && auth.accessToken != null) {
          try {
            await sessionService.saveSession(
              accessToken: auth.accessToken!,
              refreshToken: auth.refreshToken!,
              userId: auth.userId,
            );
            logger.i('✅ Session persisted securely via Observer');
          } catch (e) {
            logger.e('❌ Session persistence failed', error: e);
          }
        }
      },
      orElse: () {},
    );
  });
}
