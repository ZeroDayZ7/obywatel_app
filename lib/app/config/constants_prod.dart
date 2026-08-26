// lib/config/constants_prod.dart
import 'package:obywatel_plus/app/config/constants_base.dart';

class ApiConstants extends ApiConstantsBase {
  final bool isProduction = true;
  final bool serverOnline = true;
  final String baseUrl;
  final bool enableSSLPinning;
  final List<String> apiFingerprints;
  final String defaultEmail;
  final String defaultPassword;
  final String appName;
  final String appDescription;
  final Duration inactivityTimeout;

  const ApiConstants()
    : baseUrl = 'https://localhost-0.tail400384.ts.net',
      enableSSLPinning = true,
      apiFingerprints = const [
        '6D739691D5F16774369B7C96A8F1C946753204A4440375A81689D6C84B2BA510',
        // 'TUTAJ_DODAJ_BACKUP_PIN_NA_WYPADEK_ROTACJI_CERTYFIKATU',
      ],
      defaultEmail = '',
      defaultPassword = '',
      appName = 'Obywatel Plus',
      appDescription = 'Government Operating System',
      inactivityTimeout = const Duration(minutes: 5),
      super(
        minSplashDuration: const Duration(milliseconds: 500),
        appVersion: '1.0.0',
      );
}
