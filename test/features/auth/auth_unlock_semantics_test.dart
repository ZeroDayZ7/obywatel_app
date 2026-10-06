import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/errors/exceptions/app_exception.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/clients/no_auth_client.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/security/security/security_state.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_service.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/auth/domain/auth_user.dart';

class _FakeSessionService extends SessionService {
  _FakeSessionService()
      : super(
          SecureStorageService(const FlutterSecureStorage(), AppLogger()),
          AppLogger(),
        );

  @override
  Future<String?> getRefreshToken() async => 'refresh-token';

  @override
  Future<AuthUser?> getCachedUser() async => const AuthUser(
        id: 'user-1',
        username: 'jan',
        email: 'jan@example.com',
        displayName: 'Jan',
        role: 'CITIZEN',
      );

  @override
  Future<void> cacheUser(AuthUser user) async {}
}

class _FakeAuthService extends AuthService {
  _FakeAuthService()
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

  @override
  Future<AuthUser> fetchAuthMe() async {
    throw DioException(
      requestOptions: RequestOptions(path: '/auth/me'),
      error: const BackendUnavailableException(),
    );
  }
}

class _FakeSecurityService extends SecurityService {
  bool unlocked = false;

  @override
  SecurityState build() => SecurityState.initial();

  @override
  Future<void> unlockApp() async {
    unlocked = true;
  }

  @override
  Future<void> lockApp() async {}

  @override
  Future<void> unlockManually() async {}

  @override
  Future<void> markSecurityAsInitialized() async {}
}

void main() {
  group('AuthController unlock semantics', () {
    test('backend unavailable keeps local authenticated state on valid PIN', () async {
      final container = ProviderContainer(
        overrides: [
          sessionServiceProvider.overrideWith((ref) => _FakeSessionService()),
          authServiceProvider.overrideWith((ref) => _FakeAuthService()),
          securityServiceProvider.overrideWith(() => _FakeSecurityService()),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(authControllerProvider.notifier);
      final result = await controller.unlockWithPinAndValidateSession();

      expect(result, isTrue);
      expect(container.read(authControllerProvider).isAuthenticated, isTrue);
    });

  });
}

