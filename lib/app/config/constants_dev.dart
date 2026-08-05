// lib/config/constants_dev.dart
import 'package:obywatel_plus/app/config/constants_base.dart';

class ApiConstants extends ApiConstantsBase {
  final bool isProduction = false;
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
    : baseUrl = 'http://localhost:8081',
      enableSSLPinning = false,
      apiFingerprints = const [],
      defaultEmail = 'root@plus.pl',
      defaultPassword = 'Zaq1@wsx',
      appName = 'Obywatel Plus Dev',
      appDescription = 'Government Operating System Dev',
      inactivityTimeout = const Duration(minutes: 15),
      super(
        minSplashDuration: const Duration(milliseconds: 3500),
        appVersion: '1.0.0-DEV',
      );
}
