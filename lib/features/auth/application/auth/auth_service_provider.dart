// auth_service_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/core_providers.dart' show appLoggerProvider;
import 'package:obywatel_plus/core/network/api_provider.dart' show apiClientProvider;
import 'auth_service.dart';
import '../auth/session_service.dart';


final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    apiClient: ref.watch(apiClientProvider),
    logger: ref.watch(appLoggerProvider),
    session: ref.watch(sessionServiceProvider.notifier),
  );
});
