import 'package:fresh_dio/fresh_dio.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_storage_provider.g.dart';

@Riverpod(keepAlive: true)
TokenStorage<OAuth2Token> tokenStorage(Ref ref) {
  final sessionService = ref.watch(sessionServiceProvider);
  return SecureTokenStorage(sessionService);
}

class SecureTokenStorage extends TokenStorage<OAuth2Token> {
  final SessionService _sessionService;

  // Przechowujemy accessToken wyłącznie w pamięci RAM
  OAuth2Token? _inMemoryToken;

  SecureTokenStorage(this._sessionService);

  @override
  Future<void> delete() async {
    _inMemoryToken = null;
    await _sessionService.clearSession();
  }

  @override
  Future<OAuth2Token?> read() async {
    // 1. Jeśli mamy token w RAM, zwracamy go od razu
    if (_inMemoryToken != null && _inMemoryToken!.accessToken.isNotEmpty) {
      return _inMemoryToken;
    }

    // 2. Jeśli RAM jest pusty (zimny start), sprawdzamy dysk pod kątem refreshToken
    final refreshToken = await _sessionService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    // 3. Zwracamy obiekt ze pustym accessToken - Fresh wykryje to i zrobi refresh do API
    _inMemoryToken = OAuth2Token(accessToken: '', refreshToken: refreshToken);

    return _inMemoryToken;
  }

  @override
  Future<void> write(OAuth2Token token) async {
    // Zapamiętujemy pełny token w RAM
    _inMemoryToken = token;

    // Na dysk w SecureStorage trafia WYŁĄCZNIE refreshToken
    if (token.refreshToken != null && token.refreshToken!.isNotEmpty) {
      final currentUserId = await _sessionService.getUserId();
      await _sessionService.saveSession(
        refreshToken: token.refreshToken!,
        userId: currentUserId ?? '',
      );
    }
  }
}
