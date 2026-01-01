import 'package:flutter/foundation.dart'; // listEquals
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/security/pin/change_pin_state.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/utils/validators.dart';

/// Provider flow zmiany PIN-u
final changePinProvider =
    NotifierProvider.autoDispose<ChangePinNotifier, ChangePinState>(
      ChangePinNotifier.new,
    );

class ChangePinNotifier extends Notifier<ChangePinState> {
  List<int>? _newPin;

  @override
  ChangePinState build() => const ChangePinState.enterOld();

  /// Weryfikacja starego PIN-u
  Future<void> verifyOldPin(List<int> pin) async {
    state = const ChangePinState.loading();

    final isValid = await ref.read(pinServiceProvider).verifyPin(pin);

    if (!isValid) {
      state = const ChangePinState.error('pin_dialog.invalid_pin');
      return;
    }

    state = const ChangePinState.enterNew();
  }

  /// Ustawienie nowego PIN-u (tylko walidacja długości + proste sekwencje)
  Future<void> setNewPin(List<int> pin) async {
    state = const ChangePinState.loading();

    final validationError = Validators.validatePinDigits(pin);

    if (validationError != null) {
      state = ChangePinState.error(validationError);
      state = const ChangePinState.enterNew();
      return;
    }

    _newPin = pin;
    state = const ChangePinState.confirmNew();
  }

  /// Potwierdzenie i zapis PIN-u
  Future<void> confirmAndSave(List<int> confirmPin) async {
    if (_newPin == null || !listEquals(confirmPin, _newPin)) {
      state = const ChangePinState.error('errors.pin_not_identical');
      state = const ChangePinState.enterNew();
      return;
    }

    state = const ChangePinState.loading();
    await ref.read(pinServiceProvider).setPin(confirmPin);

    state = const ChangePinState.success();
    _newPin = null;
  }
}
