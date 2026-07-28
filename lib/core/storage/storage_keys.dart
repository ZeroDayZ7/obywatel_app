// lib/config/storage_keys.dart
abstract class StorageKeys {
  StorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userProfile = 'user_profile';
  static const String setupToken = 'setup_token';
  static const String challenge = 'challenge';
  static const String isTrusted = 'is_trusted';
  static const String twoFaToken = 'two_fa_token';
  static const String twoFaRequired = '2fa_required';
  static const String appDeviceId = 'app_device_id';
  static const String kekSalt = 'kek_salt';

  // Device Identity & Cryptography
  static const String devicePrivateKey = 'device_private_key_enc';
  static const String devicePublicKey = 'device_public_key';
  static const String deviceKeySignature = 'device_key_signature';
  static const String identityKeyPair = 'identity_key_pair_enc';

  static const String userPin = 'user_pin';
  static const String pinHash = 'pin_hash';
  static const String setupCompleted = 'setup_completed';
  static const String localLockEnabled = 'local_lock_enabled';
  static const String isPinConfigured = 'isPinConfigured';
  static const String isBiometricConfigured = 'isBiometricConfigured';
  static const String databaseKey = 'database_key';

  static const String pinAttempts = 'pin_attempts';
  static const String pinLockUntil = 'pin_lock_until';
  static const String userId = 'user_id';

  static const String language = '_languageKey';

  static const String securitySecret = 'security_secret';
  static const String securityConfig = 'security_config';

  // Headers
  static const String headerFingerPrint = 'X-Device-Fingerprint';
}
