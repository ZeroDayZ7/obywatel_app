import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/app_init_status.dart';
import 'package:obywatel_plus/app/bootstrap/version_notifier.dart';
import 'package:obywatel_plus/core/security/application/device_integrity_facade.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';

final appInitProvider = NotifierProvider<AppInitNotifier, AppInitStatus>(
  AppInitNotifier.new,
);

class AppInitNotifier extends Notifier<AppInitStatus> {
  @override
  AppInitStatus build() {
    _bootstrap();
    return const AppInitStatus.loading();
  }

  Future<void> _bootstrap() async {
    try {
      final deviceService = ref.read(deviceIntegrityServiceProvider);
      final sessionService = ref.read(sessionServiceProvider);
      final securityService = ref.read(securityServiceProvider);
      final versionState = ref.read(versionNotifierProvider);

      // 1. Device
      if (!await deviceService.isDeviceAllowed()) {
        state = const AppInitStatus.blocked(reason: 'device_integrity');
        return;
      }

      // 2. FORCE UPDATE
      if (versionState.forceUpdate) {
        state = const AppInitStatus.forceUpdate();
        return;
      }

      // 3. Session
      if (!await sessionService.hasSession()) {
        state = const AppInitStatus.unauthenticated();
        return;
      }

      // 4. PIN
      if (securityService.hasLocalLock) {
        state = const AppInitStatus.lockedPin();
        return;
      }

      // 5. OK
      state = const AppInitStatus.authorized();
    } catch (e) {
      state = AppInitStatus.blocked(reason: e.toString());
    }
  }

  /// Ponowne sprawdzenie stanu inicjalizacji
  Future<void> recheck() async {
    state = const AppInitStatus.loading();
    await _bootstrap();
  }

  /// Opcjonalnie
  void unlock() {
    state = const AppInitStatus.authorized();
  }

  void logout() {
    state = const AppInitStatus.unauthenticated();
  }
}
