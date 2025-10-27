// lib/config/constants_prod.dart
import 'constants_base.dart';

class ApiConstants extends ApiConstantsBase {
  const ApiConstants()
    : super(
        baseUrl: 'https://prod-backend.com',
        pingEndpoint: '/ping',
        defaultEmail: '',
        defaultPassword: '',
        appName: "Obywatel+",
        appDescription: "Secure Citizen App",
      );
}
