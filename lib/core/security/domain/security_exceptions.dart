class DeviceNotSecureException implements Exception {
  const DeviceNotSecureException();

  @override
  String toString() => 'DEVICE_NOT_SECURE';
}

class SecurityNotConfiguredException implements Exception {}

class SecurityLockedException implements Exception {
  final DateTime until;
  SecurityLockedException(this.until);
}

class SecuritySecretMissingException implements Exception {}

class SecurityVerificationFailedException implements Exception {}
