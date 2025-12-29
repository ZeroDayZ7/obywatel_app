import 'package:obywatel_plus/app/bootstrap/app_init_status.dart';

abstract interface class StartupTask {
  String get name;
  Future<AppInitStatus?> initialize();
}
