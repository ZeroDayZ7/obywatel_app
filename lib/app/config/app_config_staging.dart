import 'app_config.dart';

class AppConfigStaging extends AppConfig {
  AppConfigStaging()
      : super(
          baseUrl: 'http://localhost:8081',
          connectTimeout: 5,
          receiveTimeout: 5,
        );
}
