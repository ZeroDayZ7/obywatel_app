// lib/core/network/api_endpoints.dart
import 'package:obywatel_plus/app/config/services_config.dart'
    show ServicesConfig;

class ApiEndpoints {
  // AUTH
  static String get login => '${ServicesConfig.authBaseUrl}/auth/login';
  static String get logout => '${ServicesConfig.authBaseUrl}/auth/logout';
  static String get userProfile => '${ServicesConfig.authBaseUrl}/user/profile';
  static String get fetchConfig => '${ServicesConfig.authBaseUrl}/app/config';

  /// Endpoint do odświeżania tokena
  static String get refreshToken => '${ServicesConfig.authBaseUrl}/auth/refresh';

  // APP CONFIG (PUBLIC)
  static String get checkVersion => '${ServicesConfig.authBaseUrl}/app/version';
}
