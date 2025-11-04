import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

final appLoggerProvider = Provider<AppLogger>((ref) => AppLogger());
