import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/features/auth/domain/auth_models.dart';

part 'pending_session_state.freezed.dart';
part 'pending_session_state.g.dart';

@freezed
sealed class PendingSession with _$PendingSession {
  const factory PendingSession({
    String? accessToken,
    String? setupToken,
    String? refreshToken,
    String? userId,
    String? userName,
    RbacData? rbac,
    String? devicePublicKey,
  }) = _PendingSession;

  factory PendingSession.fromJson(Map<String, dynamic> json) =>
      _$PendingSessionFromJson(json);
}
