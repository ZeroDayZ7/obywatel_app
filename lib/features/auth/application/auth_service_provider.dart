// lib/features/auth/application/auth_service_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_service.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/features/auth/application/auth/session_service.dart';

/// Provider dla AuthService
final authServiceProvider = Provider<AuthService>((ref) {

  return AuthService(
    apiClient: ref.watch(apiClientProvider),
    logger: ref.watch(appLoggerProvider),
    session: ref.watch(sessionServiceProvider),
  );
});
