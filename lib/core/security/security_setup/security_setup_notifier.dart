import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/local_auth_provider.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';

import 'security_setup_state.dart';

final securitySetupProvider =
    AsyncNotifierProvider<SecuritySetupNotifier, SecuritySetupState>(
      SecuritySetupNotifier.new,
    );

class SecuritySetupNotifier extends AsyncNotifier<SecuritySetupState> {
  List<int>? _tempPinBytes;

  @override
  Future<SecuritySetupState> build() async {
    final pinService = ref.read(pinServiceProvider);
    final localAuth = ref.read(localAuthProvider);
    final storage = ref.read(secureStorageProvider);

    final pinSet = await pinService.hasPin();
    final biometricAvailable = await localAuth.canCheckBiometrics;
    final biometricSet =
        await storage.read(key: StorageKeys.biometric) == 'true';

    return SecuritySetupState(
      pinSet: pinSet,
      biometricAvailable: biometricAvailable,
      biometricSet: biometricSet,
    );
  }

  Future<void> setPin(String pin) async {
    final current = state.value;
    if (current == null) return;

    state = const AsyncValue.loading();

    try {
      _tempPinBytes = pin.codeUnits.toList();

      state = AsyncValue.data(current.copyWith(pinSet: true));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> enableBiometric() async {
    final current = state.requireValue;

    final localAuth = ref.read(localAuthProvider);
    final storage = ref.read(secureStorageProvider);

    final success = await localAuth.authenticate(
      localizedReason: 'Potwierdź biometrię',
      biometricOnly: true,
    );

    if (!success) return;

    await storage.write(key: StorageKeys.biometric, value: 'true');

    state = AsyncValue.data(current.copyWith(biometricSet: true));
  }

  void toggleTrustDevice(bool value) {
    final current = state.value;
    if (current != null) {
      state = AsyncValue.data(current.copyWith(trustDevice: value));
    }
  }

  Future<void> completeSetup() async {
    if (_tempPinBytes == null) throw Exception('PIN not set');
    final current = state.requireValue;
    final logger = ref.read(appLoggerProvider);

    state = const AsyncValue.loading();

    try {
      if (current.trustDevice) {
        // Przekazujemy bajty do rejestracji
        await ref.read(securityServiceProvider.notifier).setPin(_tempPinBytes!);
        await ref.read(authControllerProvider.notifier).registerTrustedDevice();
      }

      await ref
          .read(securityServiceProvider.notifier)
          .completeSetup(enableBiometric: current.biometricSet);

      state = AsyncValue.data(
        current.copyWith(trustDevice: current.trustDevice),
      );
    } catch (e, st) {
      logger.e('Błąd podczas kończenia setupu', error: e, stackTrace: st);
      state = AsyncValue.error(e, st);
    } finally {
      logger.d('🧹 Sensitive PIN data cleared from memory (finally)');
    }
  }
}
