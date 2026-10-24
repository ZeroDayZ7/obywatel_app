import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/pin/change_pin_state.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';
import 'package:obywatel_plus/core/utils/validators.dart';

/// Provider flow zmiany PIN-u / hasła lokalnego.
final changePinProvider = NotifierProvider<ChangePinNotifier, ChangePinState>(
  ChangePinNotifier.new,
);

class ChangePinNotifier extends Notifier<ChangePinState> {
  List<int>? _newSecret;
  List<int>? _currentSecret;

  @override
  ChangePinState build() => const ChangePinState(
    currentMethod: LocalSecurityMethod.none,
    targetMethod: LocalSecurityMethod.none,
    operationType: ChangePinOperationType.changeSecret,
    step: ChangePinStep.selectMethod,
  );

  void _logTransition(String event) {
    final logger = ref.read(appLoggerProvider);
    logger.d(
      '[LOCAL-UNLOCK-01][$event] step=${state.step.name} operation=${state.operationType.name} current=${state.currentMethod.name} target=${state.targetMethod.name}',
      module: 'LocalUnlock',
    );
  }

  void initialize({
    required LocalSecurityMethod currentMethod,
    ChangePinOperationType operationType = ChangePinOperationType.changeSecret,
    LocalSecurityMethod? targetMethod,
  }) {
    if (currentMethod == LocalSecurityMethod.none) {
      return;
    }

    final resolvedTarget = switch (operationType) {
      ChangePinOperationType.changeMethod => targetMethod ?? LocalSecurityMethod.none,
      ChangePinOperationType.changeSecret => targetMethod ?? currentMethod,
    };

    final initialStep = switch (operationType) {
      ChangePinOperationType.changeMethod => ChangePinStep.selectMethod,
      ChangePinOperationType.changeSecret => ChangePinStep.enterOld,
    };

    state = state.copyWith(
      currentMethod: currentMethod,
      targetMethod: resolvedTarget,
      operationType: operationType,
      step: initialStep,
      errorMessageKey: null,
      isSubmitting: false,
    );
    _logTransition('INIT');
  }

  void beginMethodSwitch(LocalSecurityMethod targetMethod) {
    if (targetMethod == LocalSecurityMethod.none) {
      return;
    }

    if (targetMethod == state.currentMethod) {
      return;
    }

    state = state.copyWith(
      targetMethod: targetMethod,
      operationType: ChangePinOperationType.changeMethod,
      step: ChangePinStep.enterNew,
      errorMessageKey: null,
      isSubmitting: false,
    );
    _logTransition('METHOD_SWITCH');
  }

  void beginSecretChange() {
    state = state.copyWith(
      targetMethod: state.currentMethod,
      operationType: ChangePinOperationType.changeSecret,
      step: ChangePinStep.enterNew,
      errorMessageKey: null,
      isSubmitting: false,
    );
  }

  void _clearSecrets() {
    _newSecret?.fillRange(0, _newSecret!.length, 0);
    _currentSecret?.fillRange(0, _currentSecret!.length, 0);
    _newSecret = null;
    _currentSecret = null;
  }

  String? _validateSecret(List<int> secret, LocalSecurityMethod targetMethod) {
    if (targetMethod == LocalSecurityMethod.pin) {
      return Validators.validatePinDigits(secret);
    }

    return Validators.validatePassword(utf8.decode(secret));
  }

  void setNewSecret(
    List<int> secret, {
      required LocalSecurityMethod targetMethod,
    }) {
    final validationError = _validateSecret(secret, targetMethod);
    if (validationError != null) {
      state = state.copyWith(
        step: ChangePinStep.error,
        errorMessageKey: validationError,
        isSubmitting: false,
      );
      _logTransition('ERROR_INVALID_NEW_SECRET');
      return;
    }

    _newSecret = List<int>.from(secret);
    state = state.copyWith(
      targetMethod: targetMethod,
      step: ChangePinStep.confirmNew,
      errorMessageKey: null,
    );
    _logTransition('NEW_SECRET_SET');
  }

  @Deprecated('Use setNewSecret instead.')
  void setNewPin(
    List<int> secret, {
    required LocalSecurityMethod targetMethod,
  }) {
    setNewSecret(secret, targetMethod: targetMethod);
  }

  void confirmNewSecret(
    List<int> confirmSecret, {
    required LocalSecurityMethod targetMethod,
  }) {
    if (_newSecret == null) {
      state = state.copyWith(
        step: ChangePinStep.error,
        errorMessageKey: 'pin_dialog.invalid_pin',
        isSubmitting: false,
      );
      return;
    }

    if (!listEquals(confirmSecret, _newSecret)) {
      state = state.copyWith(
        step: ChangePinStep.error,
        errorMessageKey: 'errors.pin_not_identical',
        isSubmitting: false,
      );
      _logTransition('ERROR_CONFIRMATION_MISMATCH');
      return;
    }

    state = state.copyWith(
      targetMethod: targetMethod,
      step: ChangePinStep.enterOld,
      errorMessageKey: null,
    );
    _logTransition('SECRET_CONFIRMED');
  }

  @Deprecated('Use verifyCurrentSecretAndSave instead.')
  Future<void> verifyOldPin(
    List<int> secret, {
    required LocalSecurityMethod method,
  }) async {
    await verifyCurrentSecretAndSave(secret, currentMethod: method);
  }

  Future<void> verifyCurrentSecretAndSave(
    List<int> secret, {
    required LocalSecurityMethod currentMethod,
  }) async {
    if (_newSecret == null) {
      state = state.copyWith(
        step: ChangePinStep.error,
        errorMessageKey: 'pin_dialog.invalid_pin',
        isSubmitting: false,
      );
      _logTransition('ERROR_MISSING_NEW_SECRET');
      return;
    }

    final resolvedTargetMethod = state.targetMethod == LocalSecurityMethod.none
        ? currentMethod
        : state.targetMethod;

    state = state.copyWith(
      currentMethod: currentMethod,
      targetMethod: resolvedTargetMethod,
      step: ChangePinStep.loading,
      isSubmitting: true,
      errorMessageKey: null,
    );
    _currentSecret = List<int>.from(secret);

    try {
      final pinService = ref.read(pinServiceProvider);

      final isValid = await pinService.verifyLocalSecret(
        method: currentMethod,
        secretBytes: secret,
      );

      if (!isValid) {
        state = state.copyWith(
          step: ChangePinStep.error,
          errorMessageKey: 'pin_dialog.invalid_pin',
          isSubmitting: false,
        );
        _logTransition('ERROR_INVALID_CURRENT');
        return;
      }

      await pinService.updateLocalSecret(
        currentMethod: currentMethod,
        targetMethod: resolvedTargetMethod,
        currentSecret: _currentSecret!,
        newSecret: _newSecret!,
      );

      state = state.copyWith(
        step: ChangePinStep.success,
        errorMessageKey: null,
        isSubmitting: false,
      );
      _logTransition('SUCCESS');
    } catch (error, stackTrace) {
      debugPrint(
        '[ChangePinNotifier] Błąd operacji kryptograficznej: $error\n$stackTrace',
      );
      state = state.copyWith(
        step: ChangePinStep.error,
        errorMessageKey: 'errors.crypto_operation_failed',
        isSubmitting: false,
      );
      _logTransition('ERROR_CRYPTO_FAIL');
    } finally {
      _clearSecrets();
    }
  }
}