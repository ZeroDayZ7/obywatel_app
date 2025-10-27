import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/security/security_service.dart';
import 'package:obywatel_plus/app/di/injector.dart';

final securityServiceProvider = Provider<SecurityService>((ref) {
  return sl<SecurityService>();
});
