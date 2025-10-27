// lib/config/constants_dev.dart
import 'constants_base.dart';

class ApiConstants extends ApiConstantsBase {
  const ApiConstants()
    : super(
        baseUrl: 'http://localhost:8081',
        pingEndpoint: '/health',
        defaultEmail: 'user@example.com',
        defaultPassword: 'Zaq1@wsx',
        appName: "Obywatel+ Dev",
        appDescription: "Secure Citizen App Dev",
      );
}
