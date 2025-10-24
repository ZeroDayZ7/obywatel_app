// app_config_dev.dart
import 'app_config.dart';

class AppConfigDev extends AppConfig {
  AppConfigDev()
      : super(
          baseUrl: 'http://localhost:8081',
          pingEndpoint: '/health',
          connectTimeout: 5,
          receiveTimeout: 5,
          defaultEmail: 'user@example.com',
          defaultPassword: 'Zaq1@wsx',
        );
}
