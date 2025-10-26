import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';

class SplashService {
  final SecureStorageService _storage;

  SplashService(this._storage);

  /// Zwraca docelową ścieżkę po splash screenie
  Future<String> determineInitialRoute() async {
    final token = await _storage.read(key: 'accessToken');
    final pin = await _storage.read(key: 'user_pin');
    final biometricEnabled = await _storage.read(key: 'biometric') == 'true';

    if (token == null || token.isEmpty) return AppRoutes.login;
    if (pin == null || pin.isEmpty) return AppRoutes.securitySetup;
    if (biometricEnabled) return AppRoutes.pin;

    return AppRoutes.home;
  }
}
