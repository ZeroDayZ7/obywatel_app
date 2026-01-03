import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_status_provider.g.dart';

enum SessionStatus { active, expired }

@riverpod
class SessionStatusNotifier extends _$SessionStatusNotifier {
  @override
  SessionStatus build() => SessionStatus.active;

  void reportInvalidSession() {
    state = SessionStatus.expired;
  }

  void reset() {
    state = SessionStatus.active;
  }
}
