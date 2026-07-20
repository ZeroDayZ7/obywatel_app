import 'package:flutter/foundation.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/security/security/security_state.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_refresh_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthRefreshListenable extends _$AuthRefreshListenable
    with ChangeNotifier {
  @override
  void build() {
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });

    ref.listen<SecurityState>(securityServiceProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }
}
