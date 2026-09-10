import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/crypto/crypto_service.dart';
import 'package:obywatel_plus/core/crypto/kdf_service.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/local_auth_provider.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';

final securitySetupProvider =
    AsyncNotifierProvider<SecuritySetupNotifier, SecuritySetupState>(
      SecuritySetupNotifier.new,
    );

class SecuritySetupNotifier extends AsyncNotifier<SecuritySetupState> {
  List<int>? _tempPinBytes;

  @override
  Future<SecuritySetupState> build() async {
    final logger = ref.read(appLoggerProvider);
    logger.d('[SecuritySetupNotifier] Initializing build...');

    final pinService = ref.read(pinServiceProvider);
    final localAuth = ref.read(localAuthProvider);
    final storage = ref.read(secureStorageProvider);

    final pinSet = await pinService.hasPin();
    final biometricAvailable = await localAuth.canCheckBiometrics;
    final biometricSet = await storage.readBool(
      key: StorageKeys.isBiometricConfigured,
    );

    logger.d(
      '[SecuritySetupNotifier] Initial state loaded: pinSet=$pinSet, biometricAvailable=$biometricAvailable, biometricSet=$biometricSet',
    );

    return SecuritySetupState(
      pinSet: pinSet,
      biometricAvailable: biometricAvailable,
      biometricSet: biometricSet,
      trustDevice: false,
    );
  }

  Future<void> setPin(String pin) async {
    final logger = ref.read(appLoggerProvider);
    logger.d('[SecuritySetupNotifier] setPin called (length: ${pin.length})');

    final current = state.value;
    if (current == null) {
      logger.w('[SecuritySetupNotifier] setPin aborted: current state is null');
      return;
    }
    state = const AsyncValue.loading();

    try {
      _tempPinBytes = pin.split('').map(int.parse).toList();
      logger.d('[SecuritySetupNotifier] _tempPinBytes set successfully');
      state = AsyncValue.data(current.copyWith(pinSet: true));
    } catch (e, st) {
      logger.e(
        '[SecuritySetupNotifier] setPin error',
        error: e,
        stackTrace: st,
      );
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> enableBiometric() async {
    final logger = ref.read(appLoggerProvider);
    logger.d('[SecuritySetupNotifier] enableBiometric called');

    final current = state.requireValue;
    final localAuth = ref.read(localAuthProvider);
    final storage = ref.read(secureStorageProvider);

    final success = await localAuth.authenticate(
      localizedReason: 'Potwierdź biometrię',
      biometricOnly: true,
    );

    logger.d('[SecuritySetupNotifier] Biometric auth result: $success');

    if (!success) return;

    await storage.writeBool(
      key: StorageKeys.isBiometricConfigured,
      value: true,
    );
    state = AsyncValue.data(current.copyWith(biometricSet: true));
  }

  void toggleTrustDevice(bool value) {
    final logger = ref.read(appLoggerProvider);
    logger.d('[SecuritySetupNotifier] toggleTrustDevice: $value');

    final current = state.value;
    if (current != null) {
      state = AsyncValue.data(current.copyWith(trustDevice: value));
    }
  }

  /// Pominięcie rejestracji urządzenia (tworzenie sesji tymczasowej)
  Future<void> skipDeviceRegistration() async {
    final logger = ref.read(appLoggerProvider);
    logger.d('[SecuritySetupNotifier] === START skipDeviceRegistration ===');

    final current = state.requireValue;
    state = const AsyncValue.loading();

    try {
      logger.d(
        '[SecuritySetupNotifier] Requesting temporary session from AuthController...',
      );

      // 1. Wywołanie endpointu na backendzie dla sesji tymczasowej
      await ref.read(authControllerProvider.notifier).createTemporarySession();

      logger.d(
        '[SecuritySetupNotifier] Finalizing temporary security setup...',
      );

      // 2. Dedykowana metoda dla trybu tymczasowego (BEZ PIN-u)
      await ref.read(securityServiceProvider.notifier).completeTemporarySetup();

      state = AsyncValue.data(current);
      logger.d(
        '[SecuritySetupNotifier] === SKIP setup finished successfully ===',
      );
    } catch (e, st) {
      logger.e(
        '[SecuritySetupNotifier] === EXCEPTION in skipDeviceRegistration ===',
        error: e,
        stackTrace: st,
      );
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> completeSetup() async {
    final logger = ref.read(appLoggerProvider);
    logger.d('[SecuritySetupNotifier] === START completeSetup ===');

    if (_tempPinBytes == null) {
      logger.e(
        '[SecuritySetupNotifier] PIN not set in memory before completeSetup',
      );
      throw Exception('PIN not set');
    }
    final current = state.requireValue;

    state = const AsyncValue.loading();

    try {
      logger.d('[SecuritySetupNotifier] 1/6 Copying PIN bytes...');
      final pinForHash = List<int>.from(_tempPinBytes!);
      final pinForPersist = List<int>.from(_tempPinBytes!);

      logger.d('[SecuritySetupNotifier] 2/6 Setting PIN hash...');
      await ref.read(pinServiceProvider).setPin(pinForHash);

      logger.d(
        '[SecuritySetupNotifier] 3/6 Generating KDF salt & persisting...',
      );
      final kdf = ref.read(kdfServiceProvider);
      final salt = kdf.generateSalt();
      final storage = ref.read(secureStorageProvider);
      await storage.write(key: StorageKeys.kekSalt, value: base64Encode(salt));

      logger.d(
        '[SecuritySetupNotifier] 4/6 Generating & persisting device keypairs...',
      );
      final crypto = ref.read(cryptoServiceProvider.notifier);
      await crypto.generateAndHoldKeyPair();
      await crypto.finalizeAndPersist(pinForPersist, salt);
      logger.d('[SecuritySetupNotifier] Crypto keys finalized.');

      logger.d(
        '[SecuritySetupNotifier] 5/6 Executing registerTrustedDevice...',
      );
      final authState = ref.read(authControllerProvider);
      logger.d(
        '[SecuritySetupNotifier] Current AuthState before register: $authState',
      );

      await ref.read(authControllerProvider.notifier).registerTrustedDevice();
      logger.d(
        '[SecuritySetupNotifier] Device registered successfully on backend.',
      );

      logger.d(
        '[SecuritySetupNotifier] 6/6 Finalizing security service setup...',
      );
      await ref
          .read(securityServiceProvider.notifier)
          .completeSetup(enableBiometric: current.biometricSet);

      state = AsyncValue.data(current.copyWith(pinSet: true));
      logger.d(
        '[SecuritySetupNotifier] === COMPLETE setup finished successfully ===',
      );
    } catch (e, st) {
      logger.e(
        '[SecuritySetupNotifier] === EXCEPTION in completeSetup ===',
        error: e,
        stackTrace: st,
      );
      state = AsyncValue.error(e, st);
      rethrow;
    } finally {
      logger.d('[SecuritySetupNotifier] Cleaning up PIN bytes from RAM...');
      if (_tempPinBytes != null) {
        for (int i = 0; i < _tempPinBytes!.length; i++) {
          _tempPinBytes![i] = 0;
        }
        _tempPinBytes = null;
      }
      logger.d('[SecuritySetupNotifier] RAM cleanup completed.');
    }
  }
}
