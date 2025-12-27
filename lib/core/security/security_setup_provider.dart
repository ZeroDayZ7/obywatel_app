import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

/// Stan setupu (lokalny dla screena)
class SetupState {
  final bool pinSet;
  final bool biometricAvailable;
  final bool biometricSet;
  final bool canFinish;

  const SetupState({
    required this.pinSet,
    required this.biometricAvailable,
    required this.biometricSet,
    required this.canFinish,
  });

  factory SetupState.initial() => const SetupState(
    pinSet: false,
    biometricAvailable: false,
    biometricSet: false,
    canFinish: false,
  );

  SetupState copyWith({
    bool? pinSet,
    bool? biometricAvailable,
    bool? biometricSet,
    bool? canFinish,
  }) => SetupState(
    pinSet: pinSet ?? this.pinSet,
    biometricAvailable: biometricAvailable ?? this.biometricAvailable,
    biometricSet: biometricSet ?? this.biometricSet,
    canFinish: canFinish ?? this.canFinish,
  );
}

/// Notifier dla setupu
class SecuritySetupNotifier extends AsyncNotifier<SetupState> {
  @override
  Future<SetupState> build() async {
    final logger = ref.read(appLoggerProvider);
    logger.d('SetupNotifier: Inicjalizacja...');

    final pinService = ref.read(pinServiceProvider);
    final secureStorage = ref.read(secureStorageProvider);
    final localAuth = ref.read(localAuthProvider); // Teraz OK

    // Future.wait z typem <bool>
    final results = await Future.wait<bool>([
      pinService.hasPin(),
      localAuth.canCheckBiometrics,
      secureStorage.read(key: StorageKeys.biometric).then((v) => v == 'true'),
    ]);

    final pinSet = results[0];
    final biometricAvailable = results[1];
    final biometricSet = results[2];
    final canFinish = pinSet;

    logger.i(
      'Setup: PIN=$pinSet, bioAvail=$biometricAvailable, bioSet=$biometricSet',
    );
    return SetupState(
      pinSet: pinSet,
      biometricAvailable: biometricAvailable,
      biometricSet: biometricSet,
      canFinish: canFinish,
    );
  }

  Future<void> setPin(String pin) async {
    state = const AsyncValue.loading();
    try {
      final securityNotifier = ref.read(securityServiceProvider.notifier);
      await securityNotifier.setPin(pin);
      state = AsyncValue.data(
        state.value!.copyWith(pinSet: true, canFinish: true),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> enableBiometric() async {
    state = const AsyncValue.loading();
    try {
      final localAuth = ref.read(localAuthProvider);
      final secureStorage = ref.read(secureStorageProvider);
      final success = await localAuth.authenticate(
        localizedReason: 'Potwierdź biometrię',
        biometricOnly: true,
      );
      if (!success) throw Exception('Biometria nieudana');

      await secureStorage.write(key: StorageKeys.biometric, value: 'true');
      // Nie completeSetup tu – tylko update stanu lokalnego
      state = AsyncValue.data(state.value!.copyWith(biometricSet: true));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> completeSetup() async {
    final securityNotifier = ref.read(securityServiceProvider.notifier);
    // Sprawdź czy biometria włączona
    final enableBiometric = state.value?.biometricSet ?? false;
    await securityNotifier.completeSetup(enableBiometric: enableBiometric);
    ref.invalidate(securityServiceProvider);
  }

  void skipSetup() {
    ref.read(securityServiceProvider.notifier).skipPinSetup();
    ref.invalidate(securityServiceProvider);
  }
}

final securitySetupProvider =
    AsyncNotifierProvider<SecuritySetupNotifier, SetupState>(
      SecuritySetupNotifier.new,
    );
