import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/version_service.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/providers.dart';

final versionServiceProvider = Provider<VersionService>((ref) {
  return VersionService(
    ref.read(publicApiClientProvider),
    ref.read(appLoggerProvider),
  );
});
