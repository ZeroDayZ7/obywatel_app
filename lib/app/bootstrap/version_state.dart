import 'package:freezed_annotation/freezed_annotation.dart';

part 'version_state.freezed.dart';
part 'version_state.g.dart';

@freezed
sealed class VersionState with _$VersionState {
  const factory VersionState({
    required String minVersion,
    required String latestVersion,
    required bool forceUpdate,
  }) = _VersionState;

  factory VersionState.fromJson(Map<String, dynamic> json) =>
      _$VersionStateFromJson(json);
}
