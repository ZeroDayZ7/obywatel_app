import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/pin/change_pin_state.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
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

  void _flowLog(String functionName, int index, String details) {
    final logger = ref.read(appLoggerProvider);
    final msg = '[$functionName $index] $details';
    logger.d(msg, module: 'LocalUnlock');
    debugPrint(msg);
  }

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
    _flowLog('ChangePinNotifier.initialize', 1,
        'start current=${currentMethod.name} operation=${operationType.name} requestedTarget=${targetMethod?.name ?? 'none'}');

    if (currentMethod == LocalSecurityMethod.none) {
      _flowLog('ChangePinNotifier.initialize', 2,
          'skip because current method is none');
      return;
    }

    final resolvedTarget = switch (operationType) {
      ChangePinOperationType.changeMethod => targetMethod ?? LocalSecurityMethod.none,
      ChangePinOperationType.changeSecret => targetMethod ?? currentMethod,
    };

    final initialStep = switch (operationType) {
      ChangePinOperationType.changeMethod => ChangePinStep.selectMethod,
      ChangePinOperationType.changeSecret => ChangePinStep.enterNew,
    };

    state = state.copyWith(
      currentMethod: currentMethod,
      targetMethod: resolvedTarget,
      operationType: operationType,
      step: initialStep,
      errorMessageKey: null,
      isSubmitting: false,
    );
    _flowLog('ChangePinNotifier.initialize', 3,
        'state=${state.logSummary()}');
    _logTransition('INIT');
  }

  void beginMethodSwitch(LocalSecurityMethod targetMethod) {
    _flowLog('ChangePinNotifier.beginMethodSwitch', 1,
        'request target=${targetMethod.name} current=${state.currentMethod.name}');

    if (targetMethod == LocalSecurityMethod.none) {
      _flowLog('ChangePinNotifier.beginMethodSwitch', 2,
          'skip because target is none');
      return;
    }

    if (targetMethod == state.currentMethod) {
      _flowLog('ChangePinNotifier.beginMethodSwitch', 3,
          'skip because target equals current method');
      return;
    }

    state = state.copyWith(
      targetMethod: targetMethod,
      operationType: ChangePinOperationType.changeMethod,
      step: ChangePinStep.enterNew,
      errorMessageKey: null,
      isSubmitting: false,
    );
    _flowLog('ChangePinNotifier.beginMethodSwitch', 4,
        'state=${state.logSummary()}');
    _logTransition('METHOD_SWITCH');
  }

  void beginSecretChange() {
    _flowLog('ChangePinNotifier.beginSecretChange', 1,
        'start current=${state.currentMethod.name}');
    state = state.copyWith(
      targetMethod: state.currentMethod,
      operationType: ChangePinOperationType.changeSecret,
      step: ChangePinStep.enterNew,
      errorMessageKey: null,
      isSubmitting: false,
    );
    _flowLog('ChangePinNotifier.beginSecretChange', 2,
        'state=${state.logSummary()}');
  }

  void _clearSecrets() {
    _flowLog('ChangePinNotifier._clearSecrets', 1,
        'beforeClear newLength=${_newSecret?.length ?? 0} currentLength=${_currentSecret?.length ?? 0}');
    _newSecret?.fillRange(0, _newSecret!.length, 0);
    _currentSecret?.fillRange(0, _currentSecret!.length, 0);
    _newSecret = null;
    _currentSecret = null;
    _flowLog('ChangePinNotifier._clearSecrets', 2,
        'cleared');
  }

  String? _validateSecret(List<int> secret, LocalSecurityMethod targetMethod) {
    _flowLog('ChangePinNotifier._validateSecret', 1,
        'method=${targetMethod.name} bytes=${secret.length}');
    if (targetMethod == LocalSecurityMethod.pin) {
      final result = Validators.validatePinDigits(secret);
      _flowLog('ChangePinNotifier._validateSecret', 2,
          'pinValidation=${result ?? 'ok'}');
      return result;
    }

    final result = Validators.validatePassword(utf8.decode(secret));
    _flowLog('ChangePinNotifier._validateSecret', 3,
        'passwordValidation=${result ?? 'ok'}');
    return result;
  }

  void setNewSecret(
    List<int> secret, {
      required LocalSecurityMethod targetMethod,
    }) {
    _flowLog('ChangePinNotifier.setNewSecret', 1,
        'target=${targetMethod.name} bytes=${secret.length}');
    final validationError = _validateSecret(secret, targetMethod);
    if (validationError != null) {
      final stateSummary = state.logSummary();
      state = state.copyWith(
        step: ChangePinStep.error,
        errorMessageKey: validationError,
        isSubmitting: false,
      );
      _flowLog('ChangePinNotifier.setNewSecret', 2,
          'invalidSecret error=$validationError state=$stateSummary');
      _logTransition('ERROR_INVALID_NEW_SECRET');
      return;
    }

    _newSecret = List<int>.from(secret);
    state = state.copyWith(
      targetMethod: targetMethod,
      step: ChangePinStep.confirmNew,
      errorMessageKey: null,
    );
    _flowLog('ChangePinNotifier.setNewSecret', 3,
        'newSecretStored bytes=${_newSecret!.length} state=${state.logSummary()}');
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
    _flowLog('ChangePinNotifier.confirmNewSecret', 1,
        'target=${targetMethod.name} confirmBytes=${confirmSecret.length} newSecretBytes=${_newSecret?.length ?? 0}');

    if (_newSecret == null) {
      state = state.copyWith(
        step: ChangePinStep.error,
        errorMessageKey: 'pin_dialog.invalid_pin',
        isSubmitting: false,
      );
      _flowLog('ChangePinNotifier.confirmNewSecret', 2,
          'missingNewSecret state=${state.logSummary()}');
      return;
    }

    if (!listEquals(confirmSecret, _newSecret)) {
      state = state.copyWith(
        step: ChangePinStep.error,
        errorMessageKey: 'errors.pin_not_identical',
        isSubmitting: false,
      );
      _flowLog('ChangePinNotifier.confirmNewSecret', 3,
          'confirmationMismatch expected=${_newSecret!.length} actual=${confirmSecret.length} state=${state.logSummary()}');
      _logTransition('ERROR_CONFIRMATION_MISMATCH');
      return;
    }

    state = state.copyWith(
      targetMethod: targetMethod,
      step: ChangePinStep.enterOld,
      errorMessageKey: null,
    );
    _flowLog('ChangePinNotifier.confirmNewSecret', 4,
        'confirmationPassed state=${state.logSummary()}');
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
    _flowLog('ChangePinNotifier.verifyCurrentSecretAndSave', 1,
        'current=${currentMethod.name} currentSecretBytes=${secret.length} newSecretBytes=${_newSecret?.length ?? 0} target=${state.targetMethod.name}');

    if (_newSecret == null) {
      state = state.copyWith(
        step: ChangePinStep.error,
        errorMessageKey: 'pin_dialog.invalid_pin',
        isSubmitting: false,
      );
      _flowLog('ChangePinNotifier.verifyCurrentSecretAndSave', 2,
          'missingNewSecret state=${state.logSummary()}');
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
    _flowLog('ChangePinNotifier.verifyCurrentSecretAndSave', 3,
        'loading state=${state.logSummary()} target=${resolvedTargetMethod.name}');

    try {
      final pinService = ref.read(pinServiceProvider);

      final isValid = await pinService.verifyLocalSecret(
        method: currentMethod,
        secretBytes: secret,
      );

      _flowLog('ChangePinNotifier.verifyCurrentSecretAndSave', 4,
          'verificationResult isValid=$isValid currentMethod=${currentMethod.name}');

      if (!isValid) {
        state = state.copyWith(
          step: ChangePinStep.error,
          errorMessageKey: 'pin_dialog.invalid_pin',
          isSubmitting: false,
        );
        _flowLog('ChangePinNotifier.verifyCurrentSecretAndSave', 5,
            'currentSecretRejected state=${state.logSummary()}');
        _logTransition('ERROR_INVALID_CURRENT');
        return;
      }

      await pinService.updateLocalSecret(
        currentMethod: currentMethod,
        targetMethod: resolvedTargetMethod,
        currentSecret: _currentSecret!,
        newSecret: _newSecret!,
      );

      await ref.read(securityServiceProvider.notifier).syncLocalSecurityMethod(
        resolvedTargetMethod,
      );

      state = state.copyWith(
        step: ChangePinStep.success,
        errorMessageKey: null,
        isSubmitting: false,
      );
      _flowLog('ChangePinNotifier.verifyCurrentSecretAndSave', 6,
          'saveSucceeded state=${state.logSummary()}');
      _logTransition('SUCCESS');
    } catch (error, stackTrace) {
      final msg =
          '[ChangePinNotifier.verifyCurrentSecretAndSave 7] cryptoFailed error=$error stackTrace=$stackTrace';
      debugPrint(msg);
      ref.read(appLoggerProvider).e(msg, module: 'LocalUnlock', error: error, stackTrace: stackTrace);
      state = state.copyWith(
        step: ChangePinStep.error,
        errorMessageKey: 'errors.crypto_operation_failed',
        isSubmitting: false,
      );
      _flowLog('ChangePinNotifier.verifyCurrentSecretAndSave', 8,
          'cryptoFailure state=${state.logSummary()}');
      _logTransition('ERROR_CRYPTO_FAIL');
    } finally {
      _flowLog('ChangePinNotifier.verifyCurrentSecretAndSave', 9,
          'cleanup started');
      _clearSecrets();
    }
  }
}