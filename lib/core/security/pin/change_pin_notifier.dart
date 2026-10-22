import 'dart:convert';

import 'package:flutter/foundation.dart'; // listEquals
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/security/pin/change_pin_state.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';
import 'package:obywatel_plus/core/utils/validators.dart';

/// Provider flow zmiany PIN-u
final changePinProvider =
    NotifierProvider.autoDispose<ChangePinNotifier, ChangePinState>(
      ChangePinNotifier.new,
    );

class ChangePinNotifier extends Notifier<ChangePinState> {
  List<int>? _newSecret;
  List<int>? _currentSecret;
  LocalSecurityMethod _currentMethod = LocalSecurityMethod.pin;

  @override
  ChangePinState build() => const ChangePinState.enterOld();

  /// Weryfikacja obecnego PIN-u / hasła lokalnego.
  Future<void> verifyOldPin(
    List<int> secret, {
    required LocalSecurityMethod method,
  }) async {
    state = const ChangePinState.loading();
    _currentSecret = List<int>.from(secret);
    _currentMethod = method;

    final isValid = await ref
        .read(pinServiceProvider)
        .verifyLocalSecret(method: method, secretBytes: secret);

    if (!isValid) {
      state = const ChangePinState.error('pin_dialog.invalid_pin');
      return;
    }

    state = const ChangePinState.enterNew();
  }

  /// Walidacja nowego PIN-u lub hasła lokalnego.
  Future<void> setNewPin(
    List<int> secret, {
    required LocalSecurityMethod method,
  }) async {
    state = const ChangePinState.loading();

    final validationError = method == LocalSecurityMethod.pin
        ? Validators.validatePinDigits(secret)
        : Validators.validatePassword(utf8.decode(secret));

    if (validationError != null) {
      state = ChangePinState.error(validationError);
      return;
    }

    _newSecret = List<int>.from(secret);
    _currentMethod = method;
    state = const ChangePinState.confirmNew();
  }

  /// Potwierdzenie i zapis nowej wersji lokalnego sekrety.
  Future<void> confirmAndSave(
    List<int> confirmSecret, {
    required LocalSecurityMethod method,
  }) async {
    if (_currentSecret == null || _newSecret == null) {
      state = const ChangePinState.error('pin_dialog.invalid_pin');
      return;
    }

    if (!listEquals(confirmSecret, _newSecret)) {
      state = const ChangePinState.error('errors.pin_not_identical');
      return;
    }

    state = const ChangePinState.loading();

    try {
      await ref
          .read(pinServiceProvider)
          .updateLocalSecret(
            currentMethod: _currentMethod,
            targetMethod: method,
            currentSecret: _currentSecret!,
            newSecret: confirmSecret,
          );

      state = const ChangePinState.success();
      _newSecret = null;
      _currentSecret = null;
    } catch (error) {
      state = ChangePinState.error(error.toString());
    }
  }
}
