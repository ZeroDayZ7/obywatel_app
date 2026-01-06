import 'package:obywatel_plus/core/utils/device_info_service.dart'; // Dodaj ten import
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'active_sessions_service.dart';
import 'user_session.dart';

part 'active_sessions_provider.g.dart';

@riverpod
class ActiveSessions extends _$ActiveSessions {
  @override
  Future<List<UserSession>> build() async {
    final service = ref.watch(activeSessionsServiceProvider);
    final deviceInfo = ref.watch(deviceInfoServiceProvider);

    return _fetch(service, deviceInfo);
  }

  Future<List<UserSession>> _fetch(
    ActiveSessionsService service,
    DeviceInfoService deviceInfo,
  ) async {
    final sessions = await service.getActiveSessions();

    final decryptedSessions = await Future.wait(
      sessions.map((session) async {
        try {
          final clearName = await deviceInfo.decryptDeviceName(
            session.deviceName,
          );
          return session.copyWith(deviceName: clearName);
        } catch (e) {
          return session.copyWith(deviceName: "Unknown Device");
        }
      }),
    );

    return decryptedSessions;
  }

  Future<void> terminateSession(int sessionId) async {
    final service = ref.read(activeSessionsServiceProvider);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await service.terminateSession(sessionId);

      ref.invalidateSelf();

      return await future;
    });
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
