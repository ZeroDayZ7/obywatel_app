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
  LocalSecurityMethod _currentMethod = LocalSecurityMethod.none;
  LocalSecurityMethod _targetMethod = LocalSecurityMethod.pin;

  @override
  ChangePinState build() => const ChangePinState.enterOld();

  /// Walidacja nowego PIN-u / hasła lokalnego.
  Future<void> setNewPin(
    List<int> secret, {
    required LocalSecurityMethod targetMethod,
  }) async {
    // state = const ChangePinState.loading();

    final validationError = targetMethod == LocalSecurityMethod.pin
        ? Validators.validatePinDigits(secret)
        : Validators.validatePassword(utf8.decode(secret));

    if (validationError != null) {
      state = ChangePinState.error(validationError);
      return;
    }

    _newSecret = List<int>.from(secret);
    _targetMethod = targetMethod;
    state = const ChangePinState.confirmNew();
  }

  Future<void> confirmNewSecret(
    List<int> confirmSecret, {
    required LocalSecurityMethod targetMethod,
  }) async {
    if (_newSecret == null) {
      state = const ChangePinState.error('pin_dialog.invalid_pin');
      return;
    }

    if (!listEquals(confirmSecret, _newSecret)) {
      state = const ChangePinState.error('errors.pin_not_identical');
      return;
    }

    _targetMethod = targetMethod;
    state = const ChangePinState.enterOld();
  }

  /// Weryfikacja obecnego PIN-u / hasła lokalnego po ustaleniu nowego sekretu.
  Future<void> verifyCurrentSecretAndSave(
    List<int> secret, {
    required LocalSecurityMethod currentMethod,
  }) async {
    if (_newSecret == null || _targetMethod == LocalSecurityMethod.none) {
      state = const ChangePinState.error('pin_dialog.invalid_pin');
      return;
    }

    state = const ChangePinState.loading();
    _currentSecret = List<int>.from(secret);
    if (_currentMethod == LocalSecurityMethod.none) {
      _currentMethod = currentMethod;
    } else {
      _currentMethod = currentMethod;
    }

    final isValid = await ref
        .read(pinServiceProvider)
        .verifyLocalSecret(method: currentMethod, secretBytes: secret);

    if (!isValid) {
      state = const ChangePinState.error('pin_dialog.invalid_pin');
      return;
    }

    try {
      await ref
          .read(pinServiceProvider)
          .updateLocalSecret(
            currentMethod: currentMethod,
            targetMethod: _targetMethod,
            currentSecret: _currentSecret!,
            newSecret: _newSecret!,
          );

      state = const ChangePinState.success();
      _currentMethod = _targetMethod;
      _newSecret = null;
      _currentSecret = null;
      _targetMethod = LocalSecurityMethod.none;
    } catch (error) {
      state = ChangePinState.error(error.toString());
    }
  }

  /// Backward compatibility for older callers in current screen flow.
  Future<void> verifyOldPin(
    List<int> secret, {
    required LocalSecurityMethod method,
  }) async {
    await verifyCurrentSecretAndSave(secret, currentMethod: method);
  }

  /// Backward compatibility for older callers in current screen flow.
  Future<void> confirmAndSave(
    List<int> confirmSecret, {
    required LocalSecurityMethod method,
  }) async {
    await confirmNewSecret(confirmSecret, targetMethod: method);
  }
}
