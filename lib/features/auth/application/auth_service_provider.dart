import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_service.dart';
import 'package:obywatel_plus/core/core_providers.dart';

// Provider dla AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storage = ref.watch(secureStorageProvider);
  final logger = ref.watch(appLoggerProvider);

  final service = AuthService(
    apiClient: apiClient,
    storage: storage,
    logger: logger,
  );

  ref.onDispose(() {
    logger.i('🧹 AuthService disposed');
  });

  logger.i('✅ AuthService gotowy');
  return service;
});
