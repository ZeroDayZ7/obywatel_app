import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

import 'security_setup_state.dart';

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

    // 1. Ustawiamy stan na loading, co automatycznie pokaże spinner w UI
    state = const AsyncLoading();

    try {
      // 2. Wywołujemy serwis (który w środku odpala Isolate)
      await ref.read(securityServiceProvider.notifier).setPin(pin);

      // 3. Wracamy do danych z zaktualizowanym statusem
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

  Future<void> completeSetup() async {
    final enableBiometric = state.requireValue.biometricSet;

    await ref
        .read(securityServiceProvider.notifier)
        .completeSetup(enableBiometric: enableBiometric);
  }

  void skipSetup() {
    ref.read(securityServiceProvider.notifier).skipPinSetup();
    // ref.invalidate(securityServiceProvider);
  }
}
