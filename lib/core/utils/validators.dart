class Validators {
  /// Walidacja email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email jest wymagany';
    }

    // Prosta walidacja email bez deprecated RegExp
    final parts = value.split('@');
    if (parts.length != 2 || parts[0].isEmpty || !parts[1].contains('.')) {
      return 'Nieprawidłowy format email';
    }

    final domainParts = parts[1].split('.');
    if (domainParts.any((part) => part.isEmpty)) {
      return 'Nieprawidłowy format email';
    }

    return null;
  }

  /// Walidacja hasła
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Hasło jest wymagane';
    }
    if (value.length < minLength) {
      return 'Hasło musi mieć minimum $minLength znaków';
    }
    return null;
  }

  /// Walidacja PIN (opcjonalny)
  static String? validatePin(String? value) {
    if (value == null || value.isEmpty) {
      return 'PIN jest wymagany';
    }
    if (value.length < 4 || value.length > 6 || int.tryParse(value) == null) {
      return 'PIN musi być liczbą 4-6 cyfr';
    }
    return null;
  }

  /// Możesz tu dorzucać kolejne walidatory np. dla loginu, numeru telefonu itp.
}
