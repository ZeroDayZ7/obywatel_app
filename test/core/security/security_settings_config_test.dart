import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/crypto/crypto_service.dart';
import 'package:obywatel_plus/core/crypto/hash_service.dart';
import 'package:obywatel_plus/core/crypto/kdf_service.dart';
import 'package:obywatel_plus/core/crypto/symmetric_crypto.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/security/pin/change_pin_notifier.dart';
import 'package:obywatel_plus/core/security/pin/change_pin_state.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/security/security/security_state.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/core/utils/validators.dart';
import 'package:obywatel_plus/features/settings/presentation/pages/change_pin_screen.dart';

class _FixedSecurityService extends SecurityService {
  @override
  SecurityState build() => const SecurityState(
    hasLocalLock: false,
    isPinConfigured: false,
    isBiometricEnabled: false,
    canUseBiometrics: false,
    isSetupCompleted: true,
    initialized: true,
    localSecurityMethod: LocalSecurityMethod.password,
  );
}

class _FakePinService extends PinService {
  bool verifyResult = true;
  bool updateShouldSucceed = true;
  bool updateCalled = false;
  LocalSecurityMethod? lastCurrentMethod;
  LocalSecurityMethod? lastTargetMethod;
  List<int>? lastCurrentSecret;
  List<int>? lastNewSecret;

  _FakePinService()
    : super(
        storage: SecureStorageService(
          const FlutterSecureStorage(),
          AppLogger(),
        ),
        hashService: HashService(AppLogger()),
        kdfService: KdfService(AppLogger()),
        crypto: SymmetricCrypto(AppLogger()),
        cryptoService: CryptoService(),
        deviceInfoService: DeviceInfoService(AppLogger()),
        logger: AppLogger(),
      );

  @override
  Future<bool> verifyLocalSecret({
    required LocalSecurityMethod method,
    required List<int> secretBytes,
  }) async => verifyResult;

  @override
  Future<void> updateLocalSecret({
    required LocalSecurityMethod currentMethod,
    required LocalSecurityMethod targetMethod,
    required List<int> currentSecret,
    required List<int> newSecret,
  }) async {
    updateCalled = true;
    lastCurrentMethod = currentMethod;
    lastTargetMethod = targetMethod;
    lastCurrentSecret = List<int>.from(currentSecret);
    lastNewSecret = List<int>.from(newSecret);

    if (!updateShouldSucceed) {
      throw Exception('save failed');
    }
  }
}

void main() {
  testWidgets(
    'same method is a no-op and does not trigger save',
    (tester) async {
      final router = GoRouter(
        initialLocation: '${AppRoutes.settings}/${AppRoutes.settingsChangePin}?mode=change_method&method=password',
        routes: [
          GoRoute(
            path: AppRoutes.settings,
            builder: (_, _) => const SizedBox(),
            routes: [
              GoRoute(
                path: AppRoutes.settingsChangePin,
                builder: (_, _) => const ChangePinScreen(),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            securityServiceProvider.overrideWith(() => _FixedSecurityService()),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Wybierz aktywną metodę lokalnego odblokowania'), findsOneWidget);

      await tester.tap(find.text('Hasło lokalne'));
      await tester.pumpAndSettle();

      expect(find.text('Wybierz aktywną metodę lokalnego odblokowania'), findsOneWidget);
      expect(find.text('Ustaw nowe hasło lokalne'), findsNothing);
    },
  );

  test('PIN values must be numeric digits, not ASCII code units', () {
    expect(Validators.validatePinDigits([49, 50, 51, 52]), isNotNull);
    expect(Validators.validatePinDigits([1, 2, 3, 8]), isNull);
  });

  test('verification accepts a structurally valid simple PIN without reusing setup policy', () {
    expect(Validators.validatePinDigitsFormat([0, 0, 0, 0]), isNull);
    expect(Validators.validatePinDigits([0, 0, 0, 0]), isNotNull);
  });

  test('method switch flow begins with an explicit select method step', () async {
    final container = ProviderContainer();
    final notifier = container.read(changePinProvider.notifier);

    notifier.initialize(
      currentMethod: LocalSecurityMethod.password,
      operationType: ChangePinOperationType.changeMethod,
    );

    expect(container.read(changePinProvider).step, ChangePinStep.selectMethod);
    expect(container.read(changePinProvider).operationType, ChangePinOperationType.changeMethod);

    notifier.beginMethodSwitch(LocalSecurityMethod.pin);

    expect(container.read(changePinProvider).step, ChangePinStep.enterNew);
    expect(container.read(changePinProvider).targetMethod, LocalSecurityMethod.pin);
  });

  test('password -> PIN flow validates current password only after the new PIN is confirmed', () async {
    final fakeService = _FakePinService();
    final container = ProviderContainer(
      overrides: [
        pinServiceProvider.overrideWith((ref) => fakeService),
      ],
    );

    final notifier = container.read(changePinProvider.notifier);

    notifier.setNewSecret([4, 2, 8, 7], targetMethod: LocalSecurityMethod.pin);
    notifier.confirmNewSecret([4, 2, 8, 7], targetMethod: LocalSecurityMethod.pin);
    await notifier.verifyCurrentSecretAndSave(
      [9, 9, 9, 9],
      currentMethod: LocalSecurityMethod.password,
    );

    expect(fakeService.updateCalled, isTrue);
    expect(fakeService.lastCurrentMethod, LocalSecurityMethod.password);
    expect(fakeService.lastTargetMethod, LocalSecurityMethod.pin);
    expect(fakeService.lastNewSecret, [4, 2, 8, 7]);

    final successState = container.read(changePinProvider);
    expect(successState.step, ChangePinStep.success);
    expect(successState.currentMethod, LocalSecurityMethod.password);
    expect(successState.targetMethod, LocalSecurityMethod.pin);
  });

  test('bad current secret blocks the change', () async {
    final fakeService = _FakePinService()..verifyResult = false;
    final container = ProviderContainer(
      overrides: [
        pinServiceProvider.overrideWith((ref) => fakeService),
      ],
    );

    final notifier = container.read(changePinProvider.notifier);

    notifier.setNewSecret([4, 2, 8, 7], targetMethod: LocalSecurityMethod.pin);
    notifier.confirmNewSecret([4, 2, 8, 7], targetMethod: LocalSecurityMethod.pin);
    await notifier.verifyCurrentSecretAndSave(
      [0, 0, 0, 0],
      currentMethod: LocalSecurityMethod.password,
    );

    expect(fakeService.updateCalled, isFalse);

    final invalidState = container.read(changePinProvider);
    expect(invalidState.step, ChangePinStep.error);
    expect(invalidState.errorMessageKey, 'pin_dialog.invalid_pin');
    expect(invalidState.currentMethod, LocalSecurityMethod.password);
    expect(invalidState.targetMethod, LocalSecurityMethod.pin);
  });

  test('bad confirmation blocks the change', () async {
    final fakeService = _FakePinService();
    final container = ProviderContainer(
      overrides: [
        pinServiceProvider.overrideWith((ref) => fakeService),
      ],
    );

    final notifier = container.read(changePinProvider.notifier);

    notifier.setNewSecret([4, 2, 8, 7], targetMethod: LocalSecurityMethod.pin);
    notifier.confirmNewSecret([9, 9, 9, 9], targetMethod: LocalSecurityMethod.pin);

    expect(fakeService.updateCalled, isFalse);

    final mismatchState = container.read(changePinProvider);
    expect(mismatchState.step, ChangePinStep.error);
    expect(mismatchState.errorMessageKey, 'errors.pin_not_identical');
    expect(mismatchState.targetMethod, LocalSecurityMethod.pin);
  });

  test('save failure leaves state without success and without stale change', () async {
    final fakeService = _FakePinService()..updateShouldSucceed = false;
    final container = ProviderContainer(
      overrides: [
        pinServiceProvider.overrideWith((ref) => fakeService),
      ],
    );

    final notifier = container.read(changePinProvider.notifier);

    notifier.setNewSecret([4, 2, 8, 7], targetMethod: LocalSecurityMethod.pin);
    notifier.confirmNewSecret([4, 2, 8, 7], targetMethod: LocalSecurityMethod.pin);
    await notifier.verifyCurrentSecretAndSave(
      [9, 9, 9, 9],
      currentMethod: LocalSecurityMethod.password,
    );

    expect(fakeService.updateCalled, isTrue);
    final state = container.read(changePinProvider);
    final message = state.errorMessageKey;

    expect(message, isNotNull);
    expect(message, 'errors.crypto_operation_failed');
  });

  test('successful secret change updates the active security method immediately', () async {
    final fakeService = _FakePinService();
    final container = ProviderContainer(
      overrides: [
        pinServiceProvider.overrideWith((ref) => fakeService),
        securityServiceProvider.overrideWith(() => _FixedSecurityService()),
      ],
    );

    final notifier = container.read(changePinProvider.notifier);
    notifier.setNewSecret([4, 2, 8, 7], targetMethod: LocalSecurityMethod.pin);
    notifier.confirmNewSecret([4, 2, 8, 7], targetMethod: LocalSecurityMethod.pin);
    await notifier.verifyCurrentSecretAndSave(
      [9, 9, 9, 9],
      currentMethod: LocalSecurityMethod.password,
    );

    expect(container.read(securityServiceProvider).localSecurityMethod, LocalSecurityMethod.pin);
    expect(container.read(changePinProvider).step, ChangePinStep.success);
  });
}
