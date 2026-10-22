import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/security/local_auth_provider.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/security/security/security_state.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_notifier.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

class _FakeLocalAuth implements LocalAuthentication {
  _FakeLocalAuth({required this.authResult, this.biometricAvailable = true});

  final bool authResult;
  final bool biometricAvailable;
  int calls = 0;

  @override
  Future<bool> get canCheckBiometrics async => biometricAvailable;

  @override
  Future<bool> isDeviceSupported() async => biometricAvailable;

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async {
    return biometricAvailable ? [BiometricType.fingerprint] : const [];
  }

  @override
  Future<bool> stopAuthentication() async => true;

  @override
  Future<bool> authenticate({
    required String localizedReason,
    Object? authMessages = const [],
    bool biometricOnly = false,
    bool sensitiveTransaction = true,
    bool persistAcrossBackgrounding = false,
  }) async {
    calls += 1;
    return authResult;
  }
}

class _FakeSecureStorage extends SecureStorageService {
  final Map<String, String> values = {};

  _FakeSecureStorage() : super(const FlutterSecureStorage(), AppLogger());

  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
  }

  @override
  Future<String?> read({required String key}) async => values[key];

  @override
  Future<void> delete({required String key}) async {
    values.remove(key);
  }

  @override
  Future<bool> readBool({required String key, bool defaultValue = false}) async {
    final value = values[key];
    return value == null ? defaultValue : value.toLowerCase() == 'true';
  }
}

void main() {
  group('security lock flow', () {
    test('lockApp should lock the app for password-based local security too', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(securityServiceProvider.notifier);
      notifier.state = SecurityState.initial().copyWith(
        initialized: true,
        isSetupCompleted: true,
        localSecurityMethod: LocalSecurityMethod.password,
        hasLocalLock: false,
      );

      await notifier.lockApp();

      final state = container.read(securityServiceProvider);
      expect(state.hasLocalLock, isTrue);
      expect(state.shouldShowLock, isTrue);
    });

    test('unlockApp clears the lock state and shouldShowLock guard', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(securityServiceProvider.notifier);
      notifier.state = SecurityState.initial().copyWith(
        initialized: true,
        isSetupCompleted: true,
        localSecurityMethod: LocalSecurityMethod.pin,
        hasLocalLock: true,
      );

      await notifier.unlockApp();

      final state = container.read(securityServiceProvider);
      expect(state.hasLocalLock, isFalse);
      expect(state.shouldShowLock, isFalse);
    });

    test('successful biometric unlock should flip the real lock state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(securityServiceProvider.notifier);
      notifier.state = SecurityState.initial().copyWith(
        initialized: true,
        isSetupCompleted: true,
        localSecurityMethod: LocalSecurityMethod.pin,
        hasLocalLock: true,
      );

      await notifier.unlockApp();

      final state = container.read(securityServiceProvider);
      expect(state.hasLocalLock, isFalse);
      expect(state.shouldShowLock, isFalse);
    });

    test('enable biometric succeeds only after successful system auth', () async {
      final fakeStorage = _FakeSecureStorage();
      final fakeAuth = _FakeLocalAuth(authResult: true, biometricAvailable: true);
      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWith((ref) => fakeStorage),
          localAuthProvider.overrideWith((ref) => fakeAuth),
        ],
      );
      addTearDown(container.dispose);

      await container.read(securitySetupProvider.future);
      final notifier = container.read(securitySetupProvider.notifier);
      await notifier.enableBiometric();

      final state = container.read(securitySetupProvider).value;
      expect(fakeAuth.calls, 1);
      expect(state?.biometricSet, isTrue);
      expect(
        await fakeStorage.readBool(key: StorageKeys.isBiometricConfigured),
        isTrue,
      );
    });

    test('cancel biometric keeps the button state off and leaves the app locked', () async {
      final fakeStorage = _FakeSecureStorage();
      final fakeAuth = _FakeLocalAuth(authResult: false, biometricAvailable: true);
      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWith((ref) => fakeStorage),
          localAuthProvider.overrideWith((ref) => fakeAuth),
        ],
      );
      addTearDown(container.dispose);

      await container.read(securitySetupProvider.future);
      final notifier = container.read(securitySetupProvider.notifier);
      await notifier.enableBiometric();

      final state = container.read(securitySetupProvider).value;
      expect(fakeAuth.calls, 1);
      expect(state?.biometricSet, isFalse);
      expect(
        await fakeStorage.readBool(key: StorageKeys.isBiometricConfigured),
        isFalse,
      );
    });

    test('disable biometric clears the persisted flag via the security service', () async {
      final fakeStorage = _FakeSecureStorage();
      final fakeAuth = _FakeLocalAuth(authResult: true, biometricAvailable: true);
      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWith((ref) => fakeStorage),
          localAuthProvider.overrideWith((ref) => fakeAuth),
        ],
      );
      addTearDown(container.dispose);

      await container.read(securitySetupProvider.future);
      final setupNotifier = container.read(securitySetupProvider.notifier);
      await setupNotifier.enableBiometric();

      final service = container.read(securityServiceProvider.notifier);
      final result = await service.toggleBiometrics(false);

      expect(result, isTrue);
      expect(
        await fakeStorage.readBool(key: StorageKeys.isBiometricConfigured),
        isFalse,
      );
    });

    test('restart reads the persisted biometric setting and keeps the lock state consistent', () async {
      final fakeStorage = _FakeSecureStorage();
      await fakeStorage.writeBool(
        key: StorageKeys.isBiometricConfigured,
        value: true,
      );
      await fakeStorage.write(
        key: StorageKeys.localSecurityMethod,
        value: LocalSecurityMethod.pin.name,
      );

      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWith((ref) => fakeStorage),
        ],
      );
      addTearDown(container.dispose);

      final service = container.read(securityServiceProvider.notifier);
      await service.init();

      final state = container.read(securityServiceProvider);
      expect(state.isBiometricEnabled, isTrue);
      expect(state.canUseBiometrics, isTrue);
      expect(state.localSecurityMethod, LocalSecurityMethod.pin);
      expect(state.shouldShowLock, isFalse);
    });
  });
}
