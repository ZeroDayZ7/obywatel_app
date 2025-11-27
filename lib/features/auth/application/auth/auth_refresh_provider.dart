// lib/features/auth/application/auth_refresh_provider.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';

/// Adapter - zamienia Riverpodowy Notifier (SessionService)
/// na ChangeNotifier wymagany przez GoRouter
class AuthRefreshListenable extends ChangeNotifier {
  late final ProviderSubscription<AuthState> _subscription;

  AuthRefreshListenable(Ref ref) {
    _subscription = ref.listen<AuthState>(
      sessionServiceProvider,
      (_, _) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

final authRefreshListenableProvider = Provider<AuthRefreshListenable>((ref) {
  final listenable = AuthRefreshListenable(ref);
  ref.onDispose(listenable.dispose);
  return listenable;
});
