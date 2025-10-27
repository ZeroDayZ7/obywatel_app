// lib/main.dart
import 'package:obywatel_plus/app/bootstrap/app_bootstrapper.dart';

Future<void> main() async {
  await AppBootstrapper.init();
  AppBootstrapper.run();
}
