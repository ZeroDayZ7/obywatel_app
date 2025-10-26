import 'package:flutter_riverpod/flutter_riverpod.dart';
import './login_service.dart';
import '../../state/login/login_state.dart';
import '../auth_provider.dart';

class LoginController {
  final LoginService service;
  final Ref ref;

  LoginController({required this.service, required this.ref});

  Future<void> login(String email, String password) async {
    final loginState = ref.read(loginStateProvider.notifier);
    loginState.setLoading(true);
    try {
      final token = await service.login(email, password);
      ref.read(authProvider.notifier).login(token);

      final nextRoute = await service.determineNextRoute();
      ref.read(loginStateProvider.notifier).setNextRoute(nextRoute);
    } catch (e) {
      loginState.setError(e.toString());
    } finally {
      loginState.setLoading(false);
    }
  }
}
