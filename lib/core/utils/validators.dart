class Validators {
  // Walidacja email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email jest wymagany';
    }
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) {
      return 'Nieprawidłowy format email';
    }
    return null;
  }

  // Walidacja hasła
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hasło jest wymagane';
    }
    if (value.length < 6) {
      return 'Hasło musi mieć minimum 6 znaków';
    }
    return null;
  }

  // Możesz tu dorzucać kolejne walidatory np. dla loginu, numeru telefonu, PIN-u itp.
}
