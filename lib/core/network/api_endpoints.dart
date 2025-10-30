// lib/core/network/api_endpoints.dart
import 'package:obywatel_plus/app/config/env.dart';

class ApiEndpoints {
  static String get login => '${apiConstants.baseUrl}/auth/login';
  static String get logout => '${apiConstants.baseUrl}/auth/logout';
  static String get userProfile => '${apiConstants.baseUrl}/user/profile';
  static String get fetchConfig => '${apiConstants.baseUrl}/app/config';
  static String get checkVersion => '${apiConstants.baseUrl}/app/version';

  /// Endpoint do odświeżania tokena
  static String get refreshToken => '${apiConstants.baseUrl}/auth/refresh';
}
