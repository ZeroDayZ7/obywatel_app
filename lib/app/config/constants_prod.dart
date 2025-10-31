// lib/config/constants_prod.dart
import 'constants_base.dart';

class ApiConstants extends ApiConstantsBase {
  const ApiConstants()
    : super(
        baseUrl: 'https://api-test.ct8.pl',
        pingEndpoint: '/health',
        defaultEmail: 'user@example.com',
        defaultPassword: 'Zaq1@wsx',
        appName: "Obywatel+",
        appDescription: "Secure Citizen App",
      );
}
