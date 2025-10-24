import 'app_config.dart';

class AppConfigProd extends AppConfig {
  AppConfigProd()
      : super(
          baseUrl: 'http://localhost:8081',
          connectTimeout: 5,
          receiveTimeout: 5,
        );
}
