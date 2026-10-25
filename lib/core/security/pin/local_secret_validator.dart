import 'dart:convert';

import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';
import 'package:obywatel_plus/core/utils/validators.dart';

class LocalSecretValidator {
  const LocalSecretValidator._();

  static String? validateForCreation({
    required LocalSecurityMethod method,
    required List<int> secret,
  }) {
    if (method == LocalSecurityMethod.none) {
      return 'errors.invalid_security_method';
    }

    if (method == LocalSecurityMethod.pin) {
      return Validators.validatePinDigits(secret);
    }

    if (secret.isEmpty) {
      return 'errors.required_password';
    }

    final password = utf8.decode(secret, allowMalformed: false);
    return Validators.validatePassword(password);
  }

  static String? validateForVerification({
    required LocalSecurityMethod method,
    required List<int> secret,
  }) {
    if (method == LocalSecurityMethod.none) {
      return 'errors.invalid_security_method';
    }

    if (method == LocalSecurityMethod.pin) {
      return Validators.validatePinDigitsFormat(secret);
    }

    if (secret.isEmpty) {
      return 'errors.required_password';
    }

    final password = utf8.decode(secret, allowMalformed: false);
    return Validators.validatePassword(password);
  }
}
