// lib/features/auth/application/auth_refresh_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

/// ChangeNotifier, który nasłuchuje zmiany AuthState
class AuthRefreshListenable extends ChangeNotifier {
  late final ProviderSubscription<AsyncValue<AuthState>> _subscription;

  AuthRefreshListenable(Ref ref) {
    _subscription = ref.listen<AsyncValue<AuthState>>(
      authProvider,
      (_, _) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

/// Provider, który daje dostęp do listenable w całej aplikacji
final authRefreshListenableProvider = Provider<AuthRefreshListenable>((ref) {
  final listenable = AuthRefreshListenable(ref);
  ref.onDispose(listenable.dispose);
  return listenable;
});
