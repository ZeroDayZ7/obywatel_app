// lib/core/network/api_endpoints.dart

class ApiEndpoints {
  // AUTH
  static String get login => '/auth/login';
  static String get logout => '/auth/logout';
  static String get userProfile => '/user/profile';
  static String get fetchConfig => '/app/config';
  static String get refreshToken => '/auth/refresh';
  static String get reset => '/auth/reset/send';
  static String get verifyResetCode => '/auth/reset/verify';
  static String get resetFinal => '/auth/reset/final';

  // PUBLIC
  static String get checkVersion => '/version';
}
