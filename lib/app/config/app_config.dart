import 'app_config_dev.dart';
import 'app_config_prod.dart';
import 'app_config_staging.dart';

enum Environment { dev, staging, prod }

class AppConfig {
  final String baseUrl;
  final int connectTimeout;
  final int receiveTimeout;

  AppConfig({
    required this.baseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
  });

  factory AppConfig.fromEnvironment(Environment env) {
    switch (env) {
      case Environment.prod:
        return AppConfigProd();
      case Environment.staging:
        return AppConfigStaging();
      case Environment.dev:
        return AppConfigDev();
    }
  }
}
