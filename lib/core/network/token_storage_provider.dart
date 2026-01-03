import 'package:fresh_dio/fresh_dio.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_storage_provider.g.dart';

@Riverpod(keepAlive: true)
TokenStorage<OAuth2Token> tokenStorage(Ref ref) {
  final sessionService = ref.watch(sessionServiceProvider);
  return SecureTokenStorage(sessionService);
}

// Sama klasa implementująca TokenStorage
class SecureTokenStorage extends TokenStorage<OAuth2Token> {
  final SessionService _sessionService;

  SecureTokenStorage(this._sessionService);

  @override
  Future<void> delete() async {
    await _sessionService.clearSession();
  }

  @override
  Future<OAuth2Token?> read() async {
    final access = await _sessionService.getAccessToken();
    final refresh = await _sessionService.getRefreshToken();

    if (access == null || refresh == null) return null;

    return OAuth2Token(accessToken: access, refreshToken: refresh);
  }

  @override
  Future<void> write(OAuth2Token token) async {
    await _sessionService.saveSession(
      accessToken: token.accessToken,
      refreshToken: token.refreshToken ?? '',
      userId: await _sessionService.getUserId() ?? '',
    );
  }
}
