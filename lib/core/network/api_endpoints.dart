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

  /// Endpoint do wysyłania kodu resetu
  static String get reset => '${ServicesConfig.authBaseUrl}/auth/reset/send';

  /// Endpoint do weryfikacji kodu resetu
  static String get verifyResetCode => '${ServicesConfig.authBaseUrl}/auth/reset/verify';

  /// Endpoint do finalnego resetu hasła
  static String get resetFinal => '${ServicesConfig.authBaseUrl}/auth/reset/final';

  // APP CONFIG (PUBLIC)
  static String get checkVersion => '${ServicesConfig.authBaseUrl}/app/version';
}
