// lib/app/bootstrap/logic/version_models.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'version_models.freezed.dart';
part 'version_models.g.dart';

/// Kontrakt dla bootstrapu i UI
abstract interface class IVersionFacade {
  bool get forceUpdate;
  Future<void> check();
}

@freezed
sealed class VersionState with _$VersionState {
  const factory VersionState({
    @Default('0.0.0') String minVersion,
    @Default('0.0.0') String latestVersion,
    @Default(false) bool forceUpdate,
  }) = _VersionState;

  factory VersionState.fromJson(Map<String, dynamic> json) =>
      _$VersionStateFromJson(json);
}
