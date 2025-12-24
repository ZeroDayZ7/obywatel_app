// lib/features/auth/application/auth/auth_refresh_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/security/security_service.dart';
import 'package:obywatel_plus/core/security/security_service_provider.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';

class AuthRefreshListenable extends ChangeNotifier {
  AuthRefreshListenable(Ref ref) {
    // 1. Nasłuchuj zmian w sesji
    ref.listen<AuthState>(sessionServiceProvider, (_, _) => notifyListeners());

    // 2. Nasłuchuj zmian w bezpieczeństwie
    ref.listen<SecurityState>(securityServiceProvider, (_, _) => notifyListeners());
  }
}

final authRefreshListenableProvider = Provider<AuthRefreshListenable>((ref) {
  return AuthRefreshListenable(ref);
});
