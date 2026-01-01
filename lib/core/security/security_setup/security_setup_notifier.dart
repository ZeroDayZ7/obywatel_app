import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/security/local_auth_provider.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_service.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';

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
    // 1. Zabezpieczamy aktualny stan
    final current = state.value;
    if (current == null) return;

    state = const AsyncValue.loading();

    try {
      // 2. KONWERSJA: Zamieniamy String na kody bajtów (List<int>)
      // Dzięki temu utrzymujemy "bezpieczny łańcuch" danych wrażliwych.
      final pinCodes = pin.codeUnits.toList();

      // 3. Wywołujemy serwis z bajtami zamiast Stringa
      await ref.read(securityServiceProvider.notifier).setPin(pinCodes);

      // 4. Czyścimy listę bajtów z pamięci RAM zaraz po użyciu
      pinCodes.fillRange(0, pinCodes.length, 0);

      // 5. Sukces - aktualizujemy stan
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
    final current = state.requireValue;
    final deviceService = ref.read(deviceInfoServiceProvider);
    final authService = ref.read(authServiceProvider);

    state = const AsyncValue.loading();

    try {
      if (current.trustDevice) {
        final authState = ref.read(authControllerProvider);

        // Wyciągamy userId z RAMu
        String? userId = authState.mapOrNull(authenticated: (s) => s.userId);

        // LINT FIX: Próba ratunkowa z dysku, jeśli w RAMie pusto
        userId ??= await ref.read(sessionServiceProvider).getUserId();

        if (userId == null) {
          throw Exception(
            "Błąd: Brak ID użytkownika w pamięci RAM i na dysku.",
          );
        }

        // 1. Generujemy parę kluczy
        final keyPair = await deviceService.generateDeviceKeyPair();
        final publicKey = await keyPair.extractPublicKey();
        final publicKeyBytes = publicKey.bytes;

        // 2. Dane urządzenia (używamy bezpiecznego userId)
        final fingerprint = await deviceService.getSecureFingerprint(userId);
        final encryptedName = await deviceService.getEncryptedMarketingName();

        // 3. Rejestrujemy urządzenie w Go
        await authService.registerTrustedDevice(
          fingerprint: fingerprint,
          publicKey: base64Encode(publicKeyBytes),
          encryptedName: encryptedName,
          platform: Platform.operatingSystem,
        );
      }

      // 4. Kończymy setup (PIN i Biometria)
      await ref
          .read(securityServiceProvider.notifier)
          .completeSetup(enableBiometric: current.biometricSet);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
