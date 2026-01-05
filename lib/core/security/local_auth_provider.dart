// lib/core/security/local_auth_provider.dart
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_auth_provider.g.dart';

@Riverpod(keepAlive: true)
LocalAuthentication localAuth(Ref ref) {
  return LocalAuthentication();
}
