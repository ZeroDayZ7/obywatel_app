import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/di/injector.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return sl<AuthService>();
});
