import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_session.freezed.dart';
part 'user_session.g.dart';

@freezed
sealed class UserSession with _$UserSession {
  const factory UserSession({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'device_name_encrypted') required String deviceName,
    required String platform,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    required String fingerprint,
    String? location,
    @Default(false) bool isCurrent,
  }) = _UserSession;

  factory UserSession.fromJson(Map<String, dynamic> json) =>
      _$UserSessionFromJson(json);
}
