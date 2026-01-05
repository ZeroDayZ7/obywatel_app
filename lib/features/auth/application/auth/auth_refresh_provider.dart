import 'package:flutter/foundation.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/security/security/security_state.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_refresh_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthRefreshListenable extends _$AuthRefreshListenable
    implements Listenable {
  // Używamy wewnętrznego ChangeNotifier do zarządzania listenerami
  final ChangeNotifier _notifier = ChangeNotifier();

  @override
  void addListener(VoidCallback listener) => _notifier.addListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      _notifier.removeListener(listener);

  @override
  void build() {
    // Nasłuchiwanie zmian w AuthState
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (previous != next) {
        // Wywołujemy notifyListeners() przez wewnętrzny mechanizm
        // ignore: invalid_use_of_protected_member
        (_notifier as dynamic).notifyListeners();
      }
    });

    // Nasłuchiwanie zmian w SecurityState
    ref.listen<SecurityState>(securityServiceProvider, (previous, next) {
      if (previous != next) {
        // ignore: invalid_use_of_protected_member
        (_notifier as dynamic).notifyListeners();
      }
    });
  }
}
