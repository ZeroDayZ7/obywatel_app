// lib/config/constants_prod.dart
import 'constants_base.dart';

class ApiConstants extends ApiConstantsBase {
  final bool isProduction = true;
  final bool serverOnline = true;
  final String baseUrl;
  final bool enableSSLPinning;
  final String? apiFingerprint;
  final String defaultEmail;
  final String defaultPassword;
  final String appName;
  final String appDescription;

  const ApiConstants()
    : baseUrl = 'https://api-test.ct8.pl',
      enableSSLPinning = true,
      apiFingerprint =
          '6D739691D5F16774369B7C96A8F1C946753204A4440375A81689D6C84B2BA510',
      defaultEmail = 'user@example.com',
      defaultPassword = 'Zaq1@wsx',
      appName = "Obywatel+",
      appDescription = "Government Operating System";
}
