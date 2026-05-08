// lib\app\bootstrap\app_init_status.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_init_status.freezed.dart';

@freezed
sealed class AppInitStatus with _$AppInitStatus {
  const factory AppInitStatus.loading() = _Loading;

  const factory AppInitStatus.unauthenticated() = _Unauthenticated;

  const factory AppInitStatus.lockedPin() = _LockedPin;

  const factory AppInitStatus.authorized() = _Authorized;

  const factory AppInitStatus.forceUpdate() = _ForceUpdate;

  const factory AppInitStatus.maintenance({
    String? message,
    DateTime? estimatedEndTime,
  }) = _Maintenance;

  const factory AppInitStatus.blocked({String? reason}) = _Blocked;
}
