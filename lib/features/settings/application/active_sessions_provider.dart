import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:obywatel_plus/features/settings/application/active_sessions_service.dart';
import 'package:obywatel_plus/features/settings/application/user_session.dart';

part 'active_sessions_provider.g.dart';

@riverpod
class ActiveSessions extends _$ActiveSessions {
  @override
  Future<List<UserSession>> build() async {
    final service = ref.watch(activeSessionsServiceProvider);
    return _fetch(service);
  }

  Future<List<UserSession>> _fetch(ActiveSessionsService service) async {
    // Pobieramy sesje bez żadnej obróbki
    final sessions = await service.getActiveSessions();
    return sessions;
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
