import 'package:obywatel_plus/features/auth/application/session/pending_session_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pending_session_provider.g.dart';

@Riverpod(keepAlive: true)
class PendingSessionNotifier extends _$PendingSessionNotifier {
  @override
  PendingSession? build() {
    return null;
  }

  void update(PendingSession session) {
    state = session;
  }

  void clear() {
    state = null;
  }
}
