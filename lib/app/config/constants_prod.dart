// lib/config/constants_prod.dart
import 'constants_base.dart';

class ApiConstants extends ApiConstantsBase {
  const ApiConstants()
    : super(
        baseUrl: 'http://localhost:8081',
        pingEndpoint: '/health',
        defaultEmail: '',
        defaultPassword: '',
        appName: "Obywatel+",
        appDescription: "Secure Citizen App",
      );
}
