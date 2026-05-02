/// obywatel_app\lib\app\config\constants_base.dart
abstract class ApiConstantsBase {
  static const int defaultConnectTimeout = 5;
  static const int defaultReceiveTimeout = 5;
  static const String defaultPingEndpoint = '/health';
  static const Duration defaultMinSplashDuration = Duration(milliseconds: 1500);
  static const String defaultAppVersion = '1.0.0';

  final String appVersion;
  final String pingEndpoint;
  final int connectTimeoutSeconds;
  final int receiveTimeoutSeconds;
  final Duration minSplashDuration;

  const ApiConstantsBase({
    this.appVersion = defaultAppVersion,
    this.pingEndpoint = defaultPingEndpoint,
    this.connectTimeoutSeconds = defaultConnectTimeout,
    this.receiveTimeoutSeconds = defaultReceiveTimeout,
    this.minSplashDuration = defaultMinSplashDuration,
  });
}
