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

  static String? validateIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocaleKeys.validators_required_identifier.tr();
    }

    final trimmed = value.trim();
    final isDigitsOnly = RegExp(r'^\d+$').hasMatch(trimmed);

    if (!isDigitsOnly || trimmed.length != 12) {
      return LocaleKeys.validators_invalid_identifier.tr();
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

    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasUpper = RegExp(r'[A-Z]').hasMatch(value);
    final hasLower = RegExp(r'[a-z]').hasMatch(value);
    final hasDigit = RegExp(r'\d').hasMatch(value);
    final hasSpecial = RegExp(r'[!@#\$&*~]').hasMatch(value);

    if (!hasLetter || !hasUpper || !hasLower) {
      return LocaleKeys.validators_password_letter.tr();
    }

    if (!hasDigit) {
      return LocaleKeys.validators_password_digit.tr();
    }

    if (!hasSpecial) {
      return LocaleKeys.validators_password_special_char.tr();
    }

    return null;
  }

  /// Walidacja poprawności formatu PIN-u używanego do weryfikacji.
  /// Nie blokuje prostych PIN-ów, bo polityka „słabości” powinna dotyczyć tylko ustawiania nowego PIN-u.
  static String? validatePinDigitsFormat(List<int>? digits) {
    if (digits == null || digits.isEmpty) {
      return LocaleKeys.validators_required_pin.tr();
    }

    if (digits.length != 4) {
      return LocaleKeys.validators_pin_length.tr();
    }

    for (final digit in digits) {
      if (digit < 0 || digit > 9) {
        return LocaleKeys.validators_invalid_pin.tr();
      }
    }

    return null;
  }

  /// Walidacja PIN-u podczas tworzenia / zmiany.
  /// Tutaj stosujemy dodatkową politykę bezpieczeństwa w stosunku do prostej konfiguracji.
  static String? validatePinDigits(List<int>? digits) {
    final formatError = validatePinDigitsFormat(digits);
    if (formatError != null) {
      return formatError;
    }

    final value = digits!.join();
    const simplePins = [
      '0000',
      '1111',
      '2222',
      '3333',
      '4444',
      '5555',
      '6666',
      '7777',
      '8888',
      '9999',
      '1234',
      '2345',
      '3456',
      '4567',
      '5678',
      '6789',
      '7890',
      '0123',
      '0987',
      '9876',
      '8765',
      '7654',
      '6543',
      '5432',
      '4321',
    ];

    if (simplePins.contains(value)) {
      return LocaleKeys.validators_pin_too_simple.tr();
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

  /// Walidacja 2FA kodu (6-cyfrowy)
  static String? validateTwoFaCode(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.validators_required_field.tr();
    }
    if (value.length != 6 || int.tryParse(value) == null) {
      return LocaleKeys.login_2fa_invalid_code.tr();
    }
    return null; // wszystko OK
  }

  /// Sprawdza czy tekst wygląda jak email
  static bool isEmail(String value) {
    return validateEmail(value) == null;
  }

  /// Sprawdza czy tekst wygląda jak numer telefonu (prosta walidacja)
  static bool isPhone(String value) {
    return validatePhone(value) == null;
  }

  static bool isIdentifier(String value) {
    return validateIdentifier(value) == null;
  }
}
