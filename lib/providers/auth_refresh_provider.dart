import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class AuthRefreshListenable extends ChangeNotifier {
  late final ProviderSubscription<bool> _subscription;

  AuthRefreshListenable(Ref ref) {
    _subscription = ref.listen<bool>(
      authProvider,
      (_, __) => notifyListeners(),
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
