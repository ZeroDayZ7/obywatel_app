// lib/app/config/env.dart

import 'app_config.dart';

class Env {
  static const Environment current = Environment.dev;

  static AppConfig get config => AppConfig.fromEnvironment(current);
}
