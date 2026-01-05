// lib/config/constants_dev.dart
import 'constants_base.dart';

class ApiConstants extends ApiConstantsBase {
  final bool isProduction = false;
  final bool serverOnline = true;
  final String baseUrl;
  final bool enableSSLPinning;
  final String? apiFingerprint;
  final String defaultEmail;
  final String defaultPassword;
  final String appName;
  final String appDescription;

  const ApiConstants()
    : baseUrl = 'http://localhost:8081',
      enableSSLPinning = false,
      apiFingerprint = null,
      defaultEmail = 'user@example.com',
      defaultPassword = 'Zaq1@wsx',
      appName = "Obywatel+ Dev",
      appDescription = "Government Operating System Dev";
}
