import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:obywatel_plus/app/config/constants_base.dart';

class ApiConstants extends ApiConstantsBase {
  final bool isProduction = false;
  final bool serverOnline = true;
  final String baseUrl;
  final bool enableSSLPinning;
  final List<String> apiFingerprints;
  final String defaultPassword;
  final String appName;
  final String appDescription;
  final Duration inactivityTimeout;

  String get defaultEmail {
    if (!kIsWeb) {
      if (Platform.isWindows) {
        return 'piotr@plus.pl';
      } else if (Platform.isAndroid) {
        return 'anna@plus.pl';
      }
    }
    return 'anna@plus.pl';
  }

  const ApiConstants()
      : baseUrl = 'http://localhost:8090',
        enableSSLPinning = false,
        apiFingerprints = const [],
        defaultPassword = 'Zaq1@wsx',
        appName = 'Obywatel Plus Dev',
        appDescription = 'Government Operating System Dev',
        inactivityTimeout = const Duration(minutes: 55),
        super(
          minSplashDuration: const Duration(milliseconds: 3500),
          appVersion: '1.0.0-DEV',
        );
}