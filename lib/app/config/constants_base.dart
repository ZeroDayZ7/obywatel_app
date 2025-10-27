// lib/config/api_constants_base.dart
class ApiConstantsBase {
  final String baseUrl;
  final String pingEndpoint;
  final int connectTimeoutSeconds;
  final int receiveTimeoutSeconds;
  final String defaultEmail;
  final String defaultPassword;
  final String appName;
  final String appDescription;

  const ApiConstantsBase({
    required this.baseUrl,
    required this.pingEndpoint,
    this.connectTimeoutSeconds = 5,
    this.receiveTimeoutSeconds = 5,
    this.defaultEmail = '',
    this.defaultPassword = '',
    required this.appName,
    required this.appDescription,
  });
}
