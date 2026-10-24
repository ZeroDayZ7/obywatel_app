import 'package:fresh_dio/fresh_dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_storage_provider.g.dart';

@Riverpod(keepAlive: true)
TokenStorage<OAuth2Token> tokenStorage(Ref ref) {
  final sessionService = ref.watch(sessionServiceProvider);
  final logger = ref.watch(appLoggerProvider);

  return SecureTokenStorage(sessionService: sessionService, logger: logger);
}

class SecureTokenStorage extends TokenStorage<OAuth2Token> {
  final SessionService _sessionService;
  final AppLogger _logger;

  // Przechowujemy accessToken wyłącznie w pamięci RAM
  OAuth2Token? _inMemoryToken;

  SecureTokenStorage({
    required SessionService sessionService,
    required AppLogger logger,
  }) : _sessionService = sessionService,
       _logger = logger;

  @override
  Future<void> delete() async {
    _logger.d('🔑 [SecureTokenStorage.delete] Clearing in-memory and persisted token state');
    _inMemoryToken = null;
    await _sessionService.clearSession();
  }

  @override
  Future<OAuth2Token?> read() async {
    if (_inMemoryToken != null && _inMemoryToken!.accessToken.isNotEmpty) {
      _logger.d('🔑 [SecureTokenStorage.read] Returning cached access token from memory');
      return _inMemoryToken;
    }

    final refreshToken = await _sessionService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      _logger.d('🔑 [SecureTokenStorage.read] No persisted refresh token available');
      return null;
    }

    _logger.d('🔑 [SecureTokenStorage.read] Persisted refresh token found; creating empty access token for refresh flow');
    _inMemoryToken = OAuth2Token(accessToken: '', refreshToken: refreshToken);
    return _inMemoryToken;
  }

  @override
  Future<void> write(OAuth2Token token) async {
    final hasRefreshToken = token.refreshToken != null && token.refreshToken!.isNotEmpty;
    _logger.d(
      '🔑 [SecureTokenStorage.write] Persisting token state. access_present=${token.accessToken.isNotEmpty}, refresh_present=$hasRefreshToken',
    );

    _inMemoryToken = token;

    if (hasRefreshToken) {
      await _sessionService.saveSession(refreshToken: token.refreshToken!);
    }
  }
}
