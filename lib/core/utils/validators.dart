// core/utils/validators.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

class Validators {
  /// Walidacja email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.validators_required_email.tr();
    }
    // Prosta walidacja email bez deprecated RegExp
    final parts = value.split('@');
    if (parts.length != 2 || parts[0].isEmpty || !parts[1].contains('.')) {
      return LocaleKeys.validators_invalid_email.tr();
    }

    final domainParts = parts[1].split('.');
    if (domainParts.any((part) => part.isEmpty)) {
      return LocaleKeys.validators_invalid_email.tr();
    }

    return null;
  }

  /// Walidacja hasła
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.validators_required_password.tr();
    }
    if (value.length < minLength) {
      return LocaleKeys.validators_password_min_length.tr(
        namedArgs: {'min': minLength.toString()},
      );
    }
    return null;
  }

  /// Walidacja PIN
  static String? validatePin(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.validators_required_pin.tr();
    }
    if (value.length < 4 || value.length > 6 || int.tryParse(value) == null) {
      return LocaleKeys.validators_invalid_pin.tr();
    }
    return null;
  }

  /// Walidacja numeru telefonu
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.validators_required_phone.tr();
    }

    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length < 9 || cleaned.length > 15) {
      return LocaleKeys.validators_invalid_phone.tr();
    }

    return null;
  }

  /// Sprawdza czy tekst wygląda jak email
  static bool isEmail(String value) {
    return validateEmail(value) == null;
  }

  /// Sprawdza czy tekst wygląda jak numer telefonu (prosta walidacja)
  static bool isPhone(String value) {
    return validatePhone(value) == null;
  }
}
