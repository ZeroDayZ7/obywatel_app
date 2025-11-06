// lib/config/constants_dev.dart
import 'constants_base.dart';

class ApiConstants extends ApiConstantsBase {
  final String baseUrl;
  final String defaultEmail;
  final String defaultPassword;
  final String appName;
  final String appDescription;

  const ApiConstants()
    : baseUrl = 'http://localhost:8081',
      defaultEmail = 'user@example.com',
      defaultPassword = 'Zaq1@wsx',
      appName = "Obywatel+ Dev",
      appDescription = "Secure Citizen App Dev";
}
