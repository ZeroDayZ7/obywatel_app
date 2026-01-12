import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'pending_session_state.dart';

// To jest potrzebne do generowania kodu
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
