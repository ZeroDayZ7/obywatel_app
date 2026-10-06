import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/clients/no_auth_client.dart';
import 'package:obywatel_plus/core/network/network_manager.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/sync/sync_coordinator.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_service.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/auth/domain/auth_user.dart';

class _FakeConnectivity implements ConnectivityFacade {
  _FakeConnectivity(this.results);

  final List<ConnectivityResult> results;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      Stream<List<ConnectivityResult>>.empty();

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => results;
}

class _FakeTokenStorage extends TokenStorage<OAuth2Token> {
  _FakeTokenStorage(this.token);

  OAuth2Token? token;

  @override
  Future<OAuth2Token?> read() async => token;

  @override
  Future<void> write(OAuth2Token newToken) async {
    token = newToken;
  }

  @override
  Future<void> delete() async {
    token = null;
  }
}

class _FakeSessionService extends SessionService {
  _FakeSessionService({String? refreshToken})
      : _refreshToken = refreshToken,
        super(
          SecureStorageService(const FlutterSecureStorage(), AppLogger()),
          AppLogger(),
        );

  String? _refreshToken;

  @override
  Future<String?> getRefreshToken() async => _refreshToken;

  @override
  Future<void> clearSession() async {
    _refreshToken = null;
  }
}

class _CountingAuthService extends AuthService {
  _CountingAuthService()
      : super(
          apiClient: ApiClient(
            dio: Dio(),
            storage: SecureStorageService(
              const FlutterSecureStorage(),
              AppLogger(),
            ),
            logger: AppLogger(),
          ),
          noAuthApiClient: NoAuthApiClient(
            dio: Dio(),
            logger: AppLogger(),
          ),
          logger: AppLogger(),
        );

  int fetchCalls = 0;

  @override
  Future<AuthUser> fetchAuthMe() async {
    fetchCalls += 1;
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return const AuthUser(
      id: 'user-1',
      username: 'citizen',
      email: 'citizen@example.com',
      displayName: 'Citizen',
    );
  }
}

void main() {
  group('SyncCoordinator', () {
    test('offline blocks sync readiness', () async {
      final networkManager = NetworkManager(
        connectivity: _FakeConnectivity([ConnectivityResult.none]),
      );
      final authService = _CountingAuthService();
      final sessionService = _FakeSessionService(refreshToken: 'refresh-token');

      final container = ProviderContainer(
        overrides: [
          networkManagerProvider.overrideWithValue(networkManager),
          sessionServiceProvider.overrideWithValue(sessionService),
          authServiceProvider.overrideWithValue(authService),
          authFreshProvider.overrideWith(
            (ref) => Fresh.oAuth2(
              tokenStorage: _FakeTokenStorage(
                OAuth2Token(accessToken: 'access-token', refreshToken: 'refresh-token'),
              ),
              refreshToken: (_, _) async => OAuth2Token(
                accessToken: 'access-token',
                refreshToken: 'refresh-token',
              ),
              shouldRefresh: (_) => false,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      await networkManager.start();

      final readiness = await container.read(syncCoordinatorProvider.notifier).ensureReady();

      expect(readiness, SyncReadiness.offline);
      expect(authService.fetchCalls, 0);
    });

    test('backend unavailable blocks sync readiness', () async {
      final networkManager = NetworkManager(
        connectivity: _FakeConnectivity([ConnectivityResult.wifi]),
      );
      final authService = _CountingAuthService();
      final sessionService = _FakeSessionService(refreshToken: 'refresh-token');

      final container = ProviderContainer(
        overrides: [
          networkManagerProvider.overrideWithValue(networkManager),
          sessionServiceProvider.overrideWithValue(sessionService),
          authServiceProvider.overrideWithValue(authService),
          authFreshProvider.overrideWith(
            (ref) => Fresh.oAuth2(
              tokenStorage: _FakeTokenStorage(
                OAuth2Token(accessToken: 'access-token', refreshToken: 'refresh-token'),
              ),
              refreshToken: (_, _) async => OAuth2Token(
                accessToken: 'access-token',
                refreshToken: 'refresh-token',
              ),
              shouldRefresh: (_) => false,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      await networkManager.start();
      networkManager.markBackendUnavailable();

      final readiness = await container.read(syncCoordinatorProvider.notifier).ensureReady();

      expect(readiness, SyncReadiness.backendUnavailable);
      expect(authService.fetchCalls, 0);
    });

    test('concurrent ensureReady uses a single auth readiness flow', () async {
      final networkManager = NetworkManager(
        connectivity: _FakeConnectivity([ConnectivityResult.wifi]),
      );
      final authService = _CountingAuthService();
      final sessionService = _FakeSessionService(refreshToken: 'refresh-token');

      final container = ProviderContainer(
        overrides: [
          networkManagerProvider.overrideWithValue(networkManager),
          sessionServiceProvider.overrideWithValue(sessionService),
          authServiceProvider.overrideWithValue(authService),
          authFreshProvider.overrideWith(
            (ref) => Fresh.oAuth2(
              tokenStorage: _FakeTokenStorage(
                OAuth2Token(accessToken: 'access-token', refreshToken: 'refresh-token'),
              ),
              refreshToken: (_, _) async => OAuth2Token(
                accessToken: 'access-token',
                refreshToken: 'refresh-token',
              ),
              shouldRefresh: (_) => false,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      await networkManager.start();

      final futures = <Future<SyncReadiness>>[
        container.read(syncCoordinatorProvider.notifier).ensureReady(),
        container.read(syncCoordinatorProvider.notifier).ensureReady(),
      ];

      final results = await Future.wait(futures);

      expect(results, const <SyncReadiness>[SyncReadiness.ready, SyncReadiness.ready]);
      expect(authService.fetchCalls, 1);
    });
  });
}
