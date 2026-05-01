import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:obywatel_plus/core/logger/app_logger.dart';

part 'logger_provider.g.dart';

@Riverpod(keepAlive: true)
AppLogger appLogger(Ref ref) {
  return AppLogger();
}
