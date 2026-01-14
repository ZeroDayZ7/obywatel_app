// lib/config/storage_keys.dart
class StorageKeys {
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
  static const setupToken = 'setup_token';
  static const challenge = 'challenge';
  static const isTrusted = 'is_trusted';
  static const twoFaToken = 'two_fa_token';
  static const twoFaRequired= '2fa_required';

  static const userPin = 'user_pin';
  static const pinHash = 'pin_hash';
  static const biometric = 'biometric';
  static const setupCompleted = 'setup_completed';
  static const localLockEnabled = 'local_lock_enabled';
  static const isPinConfigured = 'isPinConfigured';
  static const isBiometricConfigured = 'isBiometricConfigured';
  static const databaseKey = 'database_key';

  static const pinAttempts = 'pin_attempts';
  static const pinLockUntil = 'pin_lock_until';
  static const userId = 'user_id';

  static const language = '_languageKey';

  static const securitySecret = 'security_secret';
  static const securityConfig = 'security_config';

  // Headers
  static const headerFingerPrint = 'X-Device-Fingerprint';
}
