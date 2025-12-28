import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';

import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'security_setup_state.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

final securitySetupProvider =
    AsyncNotifierProvider<SecuritySetupNotifier, SecuritySetupState>(
      SecuritySetupNotifier.new,
    );

class SecuritySetupNotifier extends AsyncNotifier<SecuritySetupState> {
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
    final current = state.requireValue;

    await ref.read(securityServiceProvider.notifier).setPin(pin);

    state = AsyncValue.data(current.copyWith(pinSet: true));
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

  Future<void> completeSetup() async {
    final enableBiometric = state.requireValue.biometricSet;

    await ref
        .read(securityServiceProvider.notifier)
        .completeSetup(enableBiometric: enableBiometric);

    ref.invalidate(securityServiceProvider);
  }

  void skipSetup() {
    ref.read(securityServiceProvider.notifier).skipPinSetup();
    ref.invalidate(securityServiceProvider);
  }
}
