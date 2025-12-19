import 'package:obywatel_plus/core/security/domain/auth_method.dart';

class SecurityConfig {
  final AuthMethod method;
  final int failedAttempts;
  final DateTime? lockUntil;

  const SecurityConfig({
    required this.method,
    this.failedAttempts = 0,
    this.lockUntil,
  });

  bool get isLocked {
    final until = lockUntil;
    return until != null && DateTime.now().isBefore(until);
  }
}
