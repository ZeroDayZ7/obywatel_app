/// obywatel_app\lib\app\config\constants_base.dart
class ApiConstantsBase {
  static const int defaultConnectTimeout = 5;
  static const int defaultReceiveTimeout = 5;
  static const String defaultPingEndpoint = '/health';

  final String pingEndpoint;
  final int connectTimeoutSeconds;
  final int receiveTimeoutSeconds;

  const ApiConstantsBase({
    this.pingEndpoint = defaultPingEndpoint,
    this.connectTimeoutSeconds = defaultConnectTimeout,
    this.receiveTimeoutSeconds = defaultReceiveTimeout,
  });
}
