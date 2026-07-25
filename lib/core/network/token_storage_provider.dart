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
    _logger.d('🔑 [SecureTokenStorage.delete] Usunięcie tokenów z RAM i dysku');
    _inMemoryToken = null;
    await _sessionService.clearSession();
  }

  @override
  Future<OAuth2Token?> read() async {
    // 1. Jeśli mamy token w RAM, zwracamy go od razu
    if (_inMemoryToken != null && _inMemoryToken!.accessToken.isNotEmpty) {
      _logger.d(
        '🔑 [SecureTokenStorage.read] Zwracanie tokena z RAM (AccessToken: ${_inMemoryToken!.accessToken.substring(0, 15)}...)',
      );
      return _inMemoryToken;
    }

    // 2. Jeśli RAM jest pusty (zimny start), sprawdzamy dysk pod kątem refreshToken
    final refreshToken = await _sessionService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      _logger.d(
        '🔑 [SecureTokenStorage.read] Brak tokenów w RAM i brak RefreshToken na dysku -> NULL',
      );
      return null;
    }

    // 3. Zwracamy obiekt z pustym accessToken - Fresh wykryje to i zrobi refresh do API
    _logger.d(
      '🔑 [SecureTokenStorage.read] RAM pusty! Odnaleziono RefreshToken na dysku: ${refreshToken.substring(0, 15)}... TWORZENIE PUSTEGO ACCESSTOKENA DLA FRESH',
    );
    _inMemoryToken = OAuth2Token(accessToken: '', refreshToken: refreshToken);

    return _inMemoryToken;
  }

  @override
  Future<void> write(OAuth2Token token) async {
    _logger.d(
      '🔑 [SecureTokenStorage.write] Zapis nowego tokena. AccessToken pusty? ${token.accessToken.isEmpty}, RefreshToken present? ${token.refreshToken != null && token.refreshToken!.isNotEmpty}',
    );

    // Zapamiętujemy pełny token w RAM
    _inMemoryToken = token;

    // Na dysk w SecureStorage trafia WYŁĄCZNIE refreshToken
    if (token.refreshToken != null && token.refreshToken!.isNotEmpty) {
      _logger.d('🔑 [SecureTokenStorage.write] Zapisywanie RefreshToken');
      await _sessionService.saveSession(refreshToken: token.refreshToken!);
    }
  }
}
