import 'package:obywatel_plus/core/utils/device_info_service.dart'; // Dodaj ten import
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'active_sessions_service.dart';
import 'user_session.dart';

part 'active_sessions_provider.g.dart';

@riverpod
class ActiveSessions extends _$ActiveSessions {
  @override
  Future<List<UserSession>> build() async {
    return _fetch();
  }

  Future<List<UserSession>> _fetch() async {
    final service = ref.watch(activeSessionsServiceProvider);
    final deviceInfo = ref.watch(deviceInfoServiceProvider);

    // 1. Pobierz sesje z API (nazwy są jeszcze zaszyfrowane)
    final sessions = await service.getActiveSessions();

    // 2. Deszyfruj nazwy wszystkich sesji równolegle
    final decryptedSessions = await Future.wait(
      sessions.map((session) async {
        try {
          // Wywołujemy metodę, którą dodaliśmy do DeviceInfoService
          final clearName = await deviceInfo.decryptDeviceName(
            session.deviceName,
          );
          return session.copyWith(deviceName: clearName);
        } catch (e) {
          // W razie błędu zostawiamy jak jest lub dajemy fallback
          return session.copyWith(deviceName: "Unknown Device");
        }
      }),
    );

    return decryptedSessions;
  }

  Future<void> terminateSession(int sessionId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(activeSessionsServiceProvider).terminateSession(sessionId);
      // ref.invalidateSelf() automatycznie wywoła build() i nasz nowy _fetch()
      return _fetch();
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetch());
  }
}
