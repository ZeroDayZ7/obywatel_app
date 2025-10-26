import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

/// ChangeNotifier, który nasłuchuje zmiany AuthState
class AuthRefreshListenable extends ChangeNotifier {
  late final ProviderSubscription<AuthState> _subscription;

  AuthRefreshListenable(Ref ref) {
    _subscription = ref.listen<AuthState>(
      authProvider, // teraz AuthState, nie bool
      (_, _) => notifyListeners(), // powiadamia wszystkie nasłuchujące widgety
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
