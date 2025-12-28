// lib/features/auth/application/auth/auth_refresh_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';

import 'package:obywatel_plus/core/security/security/security_state.dart';

import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart'; // NOWY IMPORT
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';

class AuthRefreshListenable extends ChangeNotifier {
  AuthRefreshListenable(Ref ref) {
    // 1. Zmiany w głównym stanie autoryzacji (Login -> 2FA -> Authenticated -> Logout)
    ref.listen<AuthState>(authControllerProvider, (_, _) => notifyListeners());

    // 2. Zmiany w bezpieczeństwie (Blokada PIN, zakończenie setupu)
    ref.listen<SecurityState>(
      securityServiceProvider,
      (_, _) => notifyListeners(),
    );
  }
}

final authRefreshListenableProvider = Provider<AuthRefreshListenable>((ref) {
  return AuthRefreshListenable(ref);
});
