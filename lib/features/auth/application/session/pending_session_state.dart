import 'package:freezed_annotation/freezed_annotation.dart';

part 'pending_session_state.freezed.dart';
part 'pending_session_state.g.dart';

@freezed
sealed class PendingSession with _$PendingSession {
  const factory PendingSession({
    required String setupToken,
    required String userId,
  }) = _PendingSession;

  factory PendingSession.fromJson(Map<String, dynamic> json) =>
      _$PendingSessionFromJson(json);
}
